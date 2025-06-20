float sdRoundedRect(float2 pos, float2 halfSize, float4 cornerRadius) {
    cornerRadius.xy = (pos.x > 0.0) ? cornerRadius.xy : cornerRadius.zw;
    cornerRadius.x  = (pos.y > 0.0) ? cornerRadius.x  : cornerRadius.y;
    float2 q = abs(pos) - halfSize + cornerRadius.x;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - cornerRadius.x;
}


[[ stitchable ]]
half4 outerRippleRoundedRect(float2 pos,
                             SwiftUI::Layer layer,
                             float4 bounds,
                             float4 radii,
                             float radius,
                             float2 dp,
                             float time)
{
    float2 size = float2(bounds.z, bounds.w);
    float2 p    = pos - size * 0.5;
    float2 dragOffset = dp - size * 0.5;      
    float2 pr   = p - dragOffset;            
    float  d    = sdRoundedRect(pr, size * radius, radii);

    // ---- smooth ripple outside ----------------------------------------------
    float edge  = smoothstep(0.0, 4.0, d);             // fade‑in just past the edge
    float fade  = 1.0 - smoothstep(60.0, 120.0, d);    // fade‑out far away
    float amp   = edge * fade;                         // overall envelope
    float ripple = sin(time * 4.0 + d * 0.15) * amp;
    float2 off   = normalize(pr + 0.001) * ripple * 8.0;

    half4 col = layer.sample(pos + off);
    return col;
}
