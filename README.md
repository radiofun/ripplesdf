# ripplesdf

A Metal `stitchable` shader that produces an animated ripple effect radiating outward from a rounded rectangle shape, defined using a signed distance function (SDF).

## What it does

The shader `outerRippleRoundedRect` computes the signed distance from each pixel to a rounded rectangle centered on a drag point. Pixels outside the shape are displaced by a sine wave whose phase and amplitude are driven by the distance field, creating concentric ripples that pulse away from the rounded rect's edges.

## How it works

1. **`sdRoundedRect`** — computes the SDF of a rounded rectangle with per-corner radii.
2. **Ripple envelope** — `smoothstep` fades the effect in at the edge and out at ~120 units distance, so ripples appear only in a band around the shape.
3. **Displacement** — each pixel is offset radially by `sin(time * 4 + distance * 0.15)` scaled by the envelope, then the layer is resampled at the displaced position.

## Parameters

| Uniform | Type | Description |
|---------|------|-------------|
| `bounds` | `float4` | Bounding box of the SwiftUI layer |
| `radii` | `float4` | Per-corner radii of the rounded rectangle |
| `radius` | `float` | Scale factor for the half-size of the rect |
| `dp` | `float2` | Drag point / origin of the shape |
| `time` | `float` | Animation time (drives ripple phase) |

## Tech Stack

- **Metal** — `stitchable` fragment shader for use with SwiftUI's `layerEffect`
- **SwiftUI Shader API** — passes `time`, `dp`, and shape parameters from Swift

## How to Use

1. Add `Metal.metal` to an Xcode project targeting iOS 17+ / macOS 14+.
2. Apply the shader from SwiftUI:
   ```swift
   someView.layerEffect(
       ShaderLibrary.outerRippleRoundedRect(
           .boundingRect,
           .float4(radii),
           .float(radius),
           .float2(dragPoint),
           .float(time)
       ),
       maxSampleOffset: CGSize(width: 16, height: 16)
   )
   ```
3. Update `time` from a `Timer` or `onReceive` loop to animate the ripples.
