//
//  GooeyShader.metal
//  Bloom
//
//  Created by Аскольд on 21.06.2026.
//

#include <metal_stdlib>
using namespace metal;

float smin_gooey(float a, float b, float k) {
    if (k <= 0.0) return min(a, b);
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

float sdRoundRect_gooey(float2 p, float2 b, float r) {
    float2 d = abs(p) - b + float2(r);
    return min(max(d.x, d.y), 0.0) + length(max(d, 0.0)) - r;
}

float sdCircle_gooey(float2 p, float r) {
    return length(p) - r;
}

[[ stitchable ]] half4 gooeyShader(float2 pos,
                                   half4 currentColor, 
                                   float2 islandCenter,
                                   float2 islandHalfSize,
                                   float islandRadius,
                                   float2 ballCenter,
                                   float ballRadius,
                                   float gooeyness) {
    
    float dIsland = sdRoundRect_gooey(pos - islandCenter, islandHalfSize, islandRadius);
    float dBall = sdCircle_gooey(pos - ballCenter, ballRadius);

    float clipPlane = islandCenter.y - pos.y + 6.0;
    float dBallClipped = max(dBall, clipPlane);

    float dMerged = smin_gooey(dIsland, dBallClipped, gooeyness);
    
    float alphaMerged = 1.0 - smoothstep(-0.5, 0.5, dMerged);
    
    float alphaBall = 1.0 - smoothstep(-0.5, 0.5, dBallClipped);

    float finalAlpha = clamp(alphaMerged - alphaBall, 0.0, 1.0);
    
    float3 black = float3(0.0, 0.0, 0.0);
    
    half3 blendedRgb = mix(currentColor.rgb, (half3)black, (half)finalAlpha);
    
    blendedRgb *= (half)alphaMerged;
    
    return half4(blendedRgb, (half)alphaMerged);
}
