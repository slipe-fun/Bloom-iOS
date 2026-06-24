//
//  AmbientUnderglowShader.metal
//  Bloom
//
//  Created by Аскольд on 25.06.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

struct PocketConstant {
    float speed;
    float phaseOffset;
    float posXOffset;
    float2 scale;
};

struct MoteConstant {
    float speed;
    float phaseOffset;
    float posXOffset;
    float radius;
};

constant PocketConstant kPockets[6] = {
    { 0.081f, 0.234f, 0.451f, float2(0.210f, 0.150f) },
    { 0.134f, 0.789f, 0.123f, float2(0.290f, 0.240f) },
    { 0.112f, 0.456f, 0.890f, float2(0.250f, 0.190f) },
    { 0.151f, 0.123f, 0.678f, float2(0.310f, 0.270f) },
    { 0.095f, 0.567f, 0.345f, float2(0.190f, 0.130f) },
    { 0.122f, 0.912f, 0.734f, float2(0.270f, 0.210f) }
};

constant MoteConstant kMotes[16] = {
    { 0.042f, 0.112f, 0.154f, 0.00015f },
    { 0.078f, 0.891f, 0.823f, 0.00042f },
    { 0.055f, 0.434f, 0.412f, 0.00028f },
    { 0.088f, 0.671f, 0.619f, 0.00048f },
    { 0.037f, 0.235f, 0.091f, 0.00011f },
    { 0.061f, 0.512f, 0.314f, 0.00031f },
    { 0.073f, 0.781f, 0.742f, 0.00039f },
    { 0.049f, 0.923f, 0.956f, 0.00022f },
    { 0.082f, 0.356f, 0.211f, 0.00045f },
    { 0.051f, 0.612f, 0.543f, 0.00026f },
    { 0.069f, 0.189f, 0.881f, 0.00035f },
    { 0.045f, 0.741f, 0.034f, 0.00018f },
    { 0.086f, 0.012f, 0.691f, 0.00049f },
    { 0.058f, 0.567f, 0.478f, 0.00032f },
    { 0.071f, 0.812f, 0.129f, 0.00037f },
    { 0.064f, 0.294f, 0.356f, 0.00034f }
};

inline float renderSoftMote(float2 coord, float2 center, float r, float edgeBlur) {
    float dist = length(coord - center);
    return 1.0f - smoothstep(r, r + edgeBlur, dist);
}

[[ stitchable ]] half4 ambientUnderglow(
    float2 pos,
    half4 currentColor,
    float2 res,
    float t,
    float revealVal,
    half4 baseColor,
    half4 particleColor
) {
    float2 st = pos / max(res, float2(1.0f));
    float aspect = res.x / max(res.y, 1.0f);
    float activeProgress = smoothstep(0.0f, 1.0f, saturate(revealVal));

    float dy = 1.0f - st.y;

    float fadeBottom = 1.0f - smoothstep(0.0f, 0.62f, dy);
    float bloomLow = exp(-dy * 4.4f);
    float mistHigh = exp(-dy * 3.0f) * 0.2f;

    float waveX = sin(st.x * 4.2f + t * 5.5f) * 0.08f + sin(st.x * 9.0f - t * 0.38f) * 0.035f;
    float wideSpread = 0.72f + sin(st.x * 5.4f - t * 0.72f) * 0.12f + sin(st.x * 12.0f + t * 0.42f) * 0.06f;

    float2 ptLeft  = float2(0.08f + waveX, 1.08f);
    float2 ptMid   = float2(0.52f - waveX * 0.45f, 1.12f);
    float2 ptRight = float2(0.94f + waveX * 0.35f, 1.06f);
    
    float glowL = 1.0f - smoothstep(0.0f, 0.88f, length(st - ptLeft));
    float glowM = 1.0f - smoothstep(0.0f, 1.04f, length(st - ptMid));
    float glowR = 1.0f - smoothstep(0.0f, 0.82f, length(st - ptRight));
    float combinedGlow = glowL * 0.7f + glowM * 0.82f + glowR * 0.64f;

    float noiseUp = sin(st.x * 7.0f + dy * 9.0f - t * 0.78f) * 0.08f + sin(st.x * 15.0f - dy * 5.0f + t * 0.56f) * 0.045f;
    float mistDrift = saturate(0.76f + noiseUp);
    float pulse = 0.92f + sin(t * 0.64f) * 0.08f;

    float warpReveal = sin(st.x * 5.0f - t * 1.4f) * 0.055f + sin(st.x * 13.0f + t * 0.86f) * 0.025f;
    float currentHeight = mix(0.0f, 0.86f, activeProgress);
    float maskOrganic = 1.0f - smoothstep(currentHeight - 0.14f, currentHeight + 0.1f, dy + warpReveal);
    maskOrganic *= smoothstep(0.0f, 0.12f, activeProgress);

    float warpWisp = st.x + sin(st.y * 7.0f - t * 1.35f) * 0.085f + sin(st.y * 16.0f + t * 0.82f) * 0.032f;
    float bandsRising = 0.5f + sin(dy * 15.0f - t * 2.15f + sin(warpWisp * 9.0f + t * 0.36f) * 1.1f) * 0.5f;
    bandsRising *= 0.58f + sin(warpWisp * 13.0f - t * 0.68f) * 0.24f;
    float wispPatterns = bandsRising * exp(-dy * 3.2f);

    float pocketIntensity = 0.0f;
    for (ushort i = 0; i < 6; ++i) {
        constant PocketConstant& p = kPockets[i];
        
        float phase = fract(t * p.speed + p.phaseOffset);
        float posX = p.posXOffset + sin(t * 0.8f + (float(i) + 1.0f) * 1.7f) * 0.08f;
        float posY = mix(1.14f, -0.16f, phase);
        
        float2 offsetPos = (st - float2(posX, posY)) / p.scale;
        float fade = smoothstep(0.0f, 0.15f, phase) * (1.0f - smoothstep(0.52f, 1.0f, phase));
        
        float distSq = dot(offsetPos, offsetPos);
        pocketIntensity += (1.0f / (1.0f + distSq * 1.8f)) * fade;
    }

    float accumVolume = saturate(
        (bloomLow * 0.42f + mistHigh) * combinedGlow * wideSpread * mistDrift * pulse
            + wispPatterns * combinedGlow * 0.13f
            + pocketIntensity * exp(-dy * 3.0f) * 0.24f
            + fadeBottom * 0.1f
    ) * maskOrganic;

    float dustParticles = 0.0f;
    float2 spaceScaled = float2(st.x * aspect, st.y);
    for (ushort j = 0; j < 16; ++j) {
        constant MoteConstant& m = kMotes[j];
        
        float phase = fract(t * m.speed + m.phaseOffset);
        float px = m.posXOffset + sin(t * 0.62f + (float(j) + 1.0f)) * 0.025f;
        float py = mix(1.04f, 0.06f, phase);
        
        float fade = smoothstep(0.0f, 0.16f, phase) * (1.0f - smoothstep(0.48f, 1.0f, phase));
        float2 centerCoord = float2(px * aspect, py);
        dustParticles += renderSoftMote(spaceScaled, centerCoord, m.radius, 0.005f) * fade;
    }

    half glowAlpha = half(saturate(accumVolume * 0.48f));
    half dustAlpha = half(saturate(dustParticles * 0.14f * smoothstep(0.18f, 0.72f, activeProgress)));
    
    half alphaMask = currentColor.a;
    glowAlpha *= baseColor.a * alphaMask;
    dustAlpha *= particleColor.a * alphaMask;
    
    half finalAlpha = saturate(glowAlpha + dustAlpha);
    half3 finalColor = baseColor.rgb * glowAlpha + particleColor.rgb * dustAlpha;
    
    return half4(finalColor, finalAlpha);
}
