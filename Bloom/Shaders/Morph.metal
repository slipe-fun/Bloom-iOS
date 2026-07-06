//
//  Morph.metal
//  Bloom
//
//  Created by Аскольд on 07.07.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] half4 alphaThreshold(
    float2 position,
    half4 color,
    float threshold,
    float smoothness
) {
    half alpha = color.a;
    
    half minThreshold = half(threshold - smoothness);
    half maxThreshold = half(threshold + smoothness);
    half sharpAlpha = smoothstep(minThreshold, maxThreshold, alpha);
    
    if (sharpAlpha <= 0.0) {
        return half4(0.0);
    }
    
    half3 rgb = color.rgb;
    if (alpha > 0.0) {
        rgb = rgb / alpha;
    }
    
    return half4(rgb * sharpAlpha, sharpAlpha);
}
