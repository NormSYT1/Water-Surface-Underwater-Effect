# Environment - Stylized Water & Lakeside Nature System

A complete, lightweight, and artist-friendly environment package for Unity. Features an advanced stylized water system, seamless underwater post-processing, animated ground caustics, a lakeside cottage model with high-quality PBR textures, layered terrain, and an interactive demonstration scene.

Designed for optimal performance on Desktop, Console, and Mobile platforms using the **Built-in Render Pipeline** (Unity 2021.3 LTS through Unity 6+).

---

## ✨ Features

### 🌊 Stylized Water System
- **Dual-Normal Animated Waves:** Intersecting wave normals with configurable flow speed and direction.
- **Dynamic Shoreline Foam:** Automatic depth-based foam generation with noise modulation against terrain and shoreline geometry.
- **Depth & Color Gradient:** Independent shallow and deep water color controls with Fresnel falloff.
- **3 Ready-to-Use Material Presets:**
  - `SurfaceWater.mat`: Balanced forest pond / inland lake.
  - `TropicalLagoon.mat`: Sparkling turquoise Caribbean water with crisp white foam.
  - `MurkyRiver.mat`: Dense mossy green river with frothy organic flow.
- **All-in-One Prefab (`CompleteWaterSystem.prefab`):** Drop a single prefab into any scene to instantly get the surface, shoreline foam, underwater post-process trigger, and caustics projector working together.

### 🤿 Underwater Immersion & Caustics
- **Native Post-Processing Stack v2:** Includes a tuned `UnderwaterPostProcessProfile` featuring Color Grading (oceanic cyan shift), Depth of Field, Vignette, Bloom, and subtle Grain.
- **Automatic Camera Transition:** Trigger volume smoothly fades effects in when the camera submerges and fades them out upon surfacing.
- **Drawn Caustics Projector:** Orthographic projector displaying animated sunlight caustics onto the lakebed, terrain, and submerged objects with automatic depth attenuation. Surface-masked to never project above water level.

### 🔊 Dynamic Audio & VFX
- **Adaptive Audio Immersion (`WaterAudioController.cs`):** Seamless crossfade between surface ambient shore laps and deep underwater resonance. Includes automatic `AudioLowPassFilter` muffling on submergence (smooth lerp from 22 kHz down to 650 Hz) and entrance/exit splash SFX.
- **Water VFX (`WaterInteractionManager.cs`):**
  - `WaterSplashEffect.prefab`: High-speed impact burst with vertical droplet spouts and expanding surface foam ripple rings.
  - `UnderwaterBubblesEffect.prefab`: Ambient floating, luminous underwater micro-bubbles and particulate dust.

### ⚓ Physics & Buoyancy (`WaterBuoyancy.cs`)
- Multi-point Archimedes buoyant force simulation.
- Natural rocking and tilting aligned with water surface levels.
- Hydrodynamic linear and angular drag when submerged.
- Easily attachable to any GameObject with a `Rigidbody` (boats, crates, barrels, debris) for instant realistic water physics.

### 🏡 Lakeside Architecture & Nature
- **Cottage Prefab (`House.prefab`):** Detailed architectural model featuring horizontal running-bond brickwork, carved limestone cornice molding, rustic timber trims, solid wood plank door, and reflective exterior glass.
- **PBR Materials & Normal Maps:** High-resolution Albedo, calculated Normal maps, and Ambient Occlusion (AO) maps for rich 3D surface depth.
- **Multi-Layer Terrain:** Pre-configured Terrain Layers for Grass, Forest Dirt, and Mountain Rock with dedicated albedo and normal textures.

### 🎮 Demo Scene & Exploration Camera
- **Demo Scene (`Demo.unity`):** Fully sculpted basin terrain, lakeside cottages, caustics, and water audio.
- **Free-Fly Camera (`DemoCameraController.cs`):** Smooth exploration controller with dual support for both the **New Input System** (`com.unity.inputsystem`) and **Legacy Input**.

---

## 📋 Requirements & Setup

- **Unity Version:** Unity 2021.3 LTS or newer (Fully verified on Unity 6).
- **Render Pipeline:** Built-in Render Pipeline.
- **Dependencies:** 
  - `com.unity.postprocessing` (Post Processing Stack v2 - available via Unity Package Manager).
  - `com.unity.inputsystem` (Optional: for New Input System camera controls; legacy fallback is automatically included).

---

## 📁 Package Structure

```
Assets/Environment/
├── House/
│   ├── House.fbx                      # 3D Cottage model with clean hierarchy
│   ├── House.prefab                   # Pre-configured cottage prefab (standardized transforms)
│   ├── Materials/                     # PBR materials (Brick, Slate Roof, Cornice, Door, Glass, etc.)
│   └── Textures/                      # High-res Albedo, Normal, and Ambient Occlusion textures
├── OriginalWater/
│   ├── Audio/                         # Ambient surface loops, underwater loops, splash SFX
│   ├── Materials/                     # Water presets (Surface, Tropical, Murky, Caustics, Particles)
│   ├── Meshes/                        # High-density round pond surface mesh
│   ├── Prefabs/                       # CompleteWaterSystem, SurfaceWater, Splash & Bubble VFX
│   ├── Profiles/                      # Tuned Underwater Post-Processing profile
│   ├── Scenes/
│   │   └── Demo.unity                 # Complete interactive demo environment
│   ├── Scripts/                       # Camera, water flow, audio, buoyancy, and interaction scripts
│   ├── Shaders/                       # Surface FX water shader and caustics projector shader
│   ├── Terrain/                       # Demo terrain data asset
│   └── Textures/                      # Wave normal maps and particle FX textures
├── TerrainLayers/                     # Grass, Dirt, and Rock terrain layers
└── TerrainTextures/                   # Landscape diffuse and normal textures
```

---

## 🚀 Quick Start Guide

### 1. Adding Water to Your Scene
1. Drag `Assets/Environment/OriginalWater/Prefabs/CompleteWaterSystem.prefab` into your scene.
2. Position the root object at your desired water surface height (Y axis).
3. Scale the root or adjust the `SurfaceWater` child to match your lake/pond dimensions.

### 2. Camera Setup for Underwater Effects
1. Select your `Main Camera`.
2. Add a `PostProcessLayer` component (if not already present).
3. In `PostProcessLayer`, set **Volume Layer** to include `WaterEffect` (Layer 6).
4. *(Optional)* Add `DemoCameraController` to fly around and test the water.

### 3. Floating Objects with Buoyancy
1. Select any prop with a `Collider` and add a `Rigidbody` component.
2. Add the `WaterBuoyancy` component (`Add Component -> Original Water -> Water Buoyancy`).
3. Press Play — the object will automatically float, rock with the water, and experience hydrodynamic drag.

---

## ⚙️ Water Shader Customization

Select any water material (`SurfaceWater.mat`, `TropicalLagoon.mat`, etc.) in the Inspector to customize:

| Property | Description |
| :--- | :--- |
| **Base Color** | Shallow water surface tint and transparency. |
| **Deep Color** | Deep water body tint seen at depth and glancing angles. |
| **Normal Strength** | Intensity of wave refraction and surface ripples. |
| **Fresnel Power** | Falloff curve between shallow and deep colors. |
| **Smoothness** | Specular highlight sharpness and sun reflection intensity. |
| **Foam Color** | Tint and opacity of shoreline contact foam. |
| **Foam Distance** | Proximity to shore geometry before foam appears. |
| **Foam Noise Factor** | Organic distortion and breakup of the foam contour. |
| **Foam Speed** | Oscillation frequency of shoreline waves. |

---

## 🎮 Demo Scene Controls

Open and play `Assets/Environment/OriginalWater/Scenes/Demo.unity`:
- **W, A, S, D:** Move forward, backward, left, right.
- **Right Mouse Button (Hold):** Look around.
- **Space / E:** Ascend / Fly up.
- **Left Shift / Q:** Descend / Fly down.
- **Left Shift (Hold while moving):** Sprint / boost flight speed.

Fly straight into the lake to experience the seamless underwater audio filter, visual color grading, and dancing sun caustics on the lakebed!

---

## 🛠️ Support & Asset Store Standards

- **Asset Store Validation:** All prefabs strictly follow root transform standards (Position `0,0,0`, Rotation `0,0,0`, Scale `1,1,1`).
- **Code Standards:** All C# scripts are safely encapsulated in the `OriginalWater` namespace.

**Version:** 1.2.0
