<a href="https://git.io/typing-svg"><img src="https://readme-typing-svg.demolab.com?font=Fira+Code&duration=1&pause=1000&width=435&lines=Performance-Tweaks-For-Win11" alt="Typing SVG" /></a>

______________________________________________________________________________________________________________________________________________


Windows 11 batch script to maximize Fortnite FPS. Tweaks power plan, GPU, CPU scheduling, memory, and disables background services/telemetry. Auto-elevates to admin. Creates a high-priority launch shortcut. Run once, restart, play.

______________________________________________________________________________________________________________________________________________

<a href="https://git.io/typing-svg"><img src="https://readme-typing-svg.demolab.com?font=Fira+Code&duration=1&pause=1000&width=435&lines=Performance-Booster-for-Windows-11" alt="Typing SVG" /></a>

A batch script that automatically applies system-level tweaks to maximize FPS and minimize input latency. Run once as Administrator, restart, and play.

______________________________________________________________________________________________________________________________________________

<a href="https://git.io/typing-svg"><img src="https://readme-typing-svg.demolab.com?font=Fira+Code&duration=1&pause=1000&width=435&lines=What-it-does" alt="Typing SVG" /></a>

- Activates Ultimate Performance power plan (unlocks it if not already available)
- Disables CPU core parking and forces minimum 100% processor state
- Enables Hardware-Accelerated GPU Scheduling (HAGS)
- Disables NVIDIA dynamic Pstate throttling and GPU power management
- Kills Xbox Game Bar, Game DVR, and all Xbox services
- Enables Windows Game Mode with optimised flip present model
- Disables Meltdown/Spectre CPU mitigations (5-15% CPU gain)
- Tunes Windows scheduler to prefer physical cores over HT cores
- Disables memory compression and keeps kernel in non-paged RAM
- Locks page file to fixed 4096MB to prevent mid-game resize stutter
- Disables NTFS last-access timestamps and 8.3 filename generation
- Removes mouse acceleration for raw 1:1 input
- Disables 15+ background services (telemetry, Superfetch, WAP Push, etc.)
- Disables background maintenance scheduled tasks
- Disables Windows Update Delivery Optimization (stops upload relay)
- Applies fullscreen optimisation disable flag to the Fortnite executable
- Creates a Launch_Fortnite_Boosted.bat on your Desktop for High Priority launch

<a href="https://git.io/typing-svg"><img src="https://readme-typing-svg.demolab.com?font=Fira+Code&duration=1&pause=1000&width=435&lines=Usage" alt="Typing SVG" /></a>
______________________________________________________________________________________________________________________________________________

1. Right-click `win11-boost.bat` and select **Run as Administrator**
   (or just double-click — the script auto-elevates)
2. Type `Y` when prompted to restart
3. After reboot, follow the nvidia-control-panel-checklist.md file for NVIDIA Control Panel and Fortnite settings

<a href="https://git.io/typing-svg"><img src="https://readme-typing-svg.demolab.com?font=Fira+Code&duration=1&pause=1000&width=435&lines=Requirements" alt="Typing SVG" /></a>

______________________________________________________________________________________________________________________________________________

- Windows 11
- NVIDIA GPU (AMD users: GPU-specific registry tweaks will silently skip)
- Fortnite installed at the default Epic Games path

______________________________________________________________________________________________________________________________________________


______________________________________________________________________________________________________________________________________________

<a href="https://git.io/typing-svg"><img src="https://readme-typing-svg.demolab.com?size=35&duration=1&pause=10000&color=F74A18&width=435&lines=Disclaimer" alt="Typing SVG" /></a>

- This script modifies registry keys and disables system services. Some changes
(Spectre/Meltdown mitigations) reduce security in exchange for performance.
Use on a dedicated gaming PC only.
- This sript is only tested in Fortnite and can cause problems with other games.
- Other games will be tested in the future!

______________________________________________________________________________________________________________________________________________

<a href="https://git.io/typing-svg"><img src="https://readme-typing-svg.demolab.com?font=Fira+Code&duration=1&pause=1000&width=435&lines=NVIDIA-Control-Panel-Settings" alt="Typing SVG" /></a>
______________________________________________________________________________________________________________________________________________
<a href="https://git.io/typing-svg"><img src="https://readme-typing-svg.demolab.com?size=35&duration=1&pause=10000&color=F74A18&width=435&lines=Disclaimer" alt="Typing SVG" /></a>

- These settings can mess with other games
- These settings can actually make your game run worse (depends which GPU you own)
- If that is the case, simply hit the **Restore** button in the respective settings section and click **Apply**

## Manage 3D Settings → Global Settings

______________________________________________________________________________________________________________________________________________

| Setting | Value |
|---|---|
| Image Sharpening | Off |
| Ambient Occlusion | Off |
| Anisotropic Filtering | Off |
| Antialiasing - FXAA | Off |
| Antialiasing - Gamma Correction | Off |
| Antialiasing - Mode | Off |
| Antialiasing - Transparency | Off |
| Background Max Frame Rate | Off |
| Low Latency Mode | Ultra (Use On for lowend pcs) |
| Max Frame Rate | Off (Unlimited) |
| Power Management Mode | Prefer Maximum Performance |
| Shader Cache Size | Unlimited |
| Texture Filtering - Quality | High Performance |
| Texture Filtering - Trilinear Optimization | Off |
| Triple Buffering | Off |
| Vertical Sync | Off |
| Virtual Reality Pre-Rendered Frames | 1 |

---

## Manage 3D Settings → Program Settings (Optional)

______________________________________________________________________________________________________________________________________________

1. Click **Add**
2. Find or manually add and select `FortniteClient-Win64-Shipping.exe`
3. Apply all the same settings from the table above specifically for Fortnite

> Program-specific settings override global settings and ensure Fortnite always runs with these options regardless of what other games use.

---

## Display → Change Resolution

______________________________________________________________________________________________________________________________________________

- Set your monitor to its **highest supported refresh rate** (e.g. 144Hz, 240Hz)
- Make sure it is set here **and** in Windows Display Settings

---

## Display → Adjust Desktop Colour Settings

______________________________________________________________________________________________________________________________________________

| Setting | Value |
|---|---|
| Digital Vibrance | 70–80% |

> Higher vibrance makes enemy skins and builds easier to spot against backgrounds.

______________________________________________________________________________________________________________________________________________
## Video → Adjust Video Colour Settings → Advanced

| Setting | Value |
|---|---|
| Dynamic Range | Full (0-255) |

______________________________________________________________________________________________________________________________________________

## After Applying

______________________________________________________________________________________________________________________________________________

1. Click **Apply** in the bottom right after every section
2. Launch Fortnite per Epic-Games Store or with the Launch_Fortnite_Boosted.bat created on your desktop
3. Set Fortnite in-game graphics as per the main README checklist







# 🎮 NVIDIA Control Panel – Beste Einstellungen nach Serie

---

## GTX-Serie

| Einstellung | Wert |
|---|---|
| Bildschärfung (NIS) | Ein – Schärfe: 50%, Körnung: 17% |
| Umgebungsokklusion | Aus |
| Anisotrope Filterung | 8x |
| Anti-Aliasing – FXAA | Aus |
| Anti-Aliasing – Gamma-Korrektur | Ein |
| Anti-Aliasing – Modus | Anwendungsgesteuert |
| Anti-Aliasing – Transparenz | Aus |
| Multi-Frame Sampled AA (MFAA) | Ein |
| DSR – Faktoren | Aus |
| Low Latency Mode | Ultra |
| Energieverwaltungsmodus | Maximale Leistung bevorzugen |
| Max. Framerate | Monitor-Hz − 3 |
| Shader-Cache-Größe | 10 GB |
| Texturfilterung – Qualität | Hohe Performance |
| Texturfilterung – Anisotrope Optimierung | Ein |
| Texturfilterung – Trilineare Optimierung | Ein |
| Texturfilterung – Negativer LOD-Bias | Fixieren (Clamp) |
| Vertikale Synchronisation (VSync) | Aus |
| Vorgerenderte Frames | 1 |
| Dreifachpufferung | Aus |

---

## RTX 20-Serie

| Einstellung | Wert |
|---|---|
| Bildschärfung | Aus |
| Umgebungsokklusion | Performance |
| Anisotrope Filterung | 16x |
| Anti-Aliasing – FXAA | Aus |
| Anti-Aliasing – Gamma-Korrektur | Ein |
| Anti-Aliasing – Modus | Anwendungsgesteuert |
| Anti-Aliasing – Transparenz | Aus |
| Multi-Frame Sampled AA (MFAA) | Aus |
| DSR – Faktoren | DLDSR 2.25x (nur bei GPU-Auslastung unter 80%) |
| RTX Video Super Resolution | Aus (nicht unterstützt) |
| Low Latency Mode | Ultra |
| Energieverwaltungsmodus | Maximale Leistung bevorzugen |
| Max. Framerate | Monitor-Hz − 3 |
| Shader-Cache-Größe | Unbegrenzt |
| Texturfilterung – Qualität | Qualität |
| Texturfilterung – Anisotrope Optimierung | Ein |
| Texturfilterung – Trilineare Optimierung | Ein |
| Texturfilterung – Negativer LOD-Bias | Fixieren (Clamp) |
| Vertikale Synchronisation (VSync) | Aus |
| Vorgerenderte Frames | 1 |
| Dreifachpufferung | Aus |

> DLSS im NVIDIA App: **Preset K** verwenden – Preset L ist auf der 20-Serie zu langsam (kein FP8).

---

## RTX 30-Serie

| Einstellung | Wert |
|---|---|
| Bildschärfung | Aus |
| Umgebungsokklusion | Performance |
| Anisotrope Filterung | 16x |
| Anti-Aliasing – FXAA | Aus |
| Anti-Aliasing – Gamma-Korrektur | Ein |
| Anti-Aliasing – Modus | Anwendungsgesteuert |
| Anti-Aliasing – Transparenz | Aus |
| Multi-Frame Sampled AA (MFAA) | Aus |
| DSR – Faktoren | DLDSR 2.25x (nur bei GPU-Auslastung unter 80%) |
| RTX Video Super Resolution | Ein |
| Low Latency Mode | Ultra |
| Energieverwaltungsmodus | Maximale Leistung bevorzugen |
| Max. Framerate | Monitor-Hz − 3 |
| Shader-Cache-Größe | Unbegrenzt |
| Texturfilterung – Qualität | Qualität |
| Texturfilterung – Anisotrope Optimierung | Ein |
| Texturfilterung – Trilineare Optimierung | Ein |
| Texturfilterung – Negativer LOD-Bias | Fixieren (Clamp) |
| Vertikale Synchronisation (VSync) | Aus |
| Vorgerenderte Frames | 1 |
| Dreifachpufferung | Aus |

> DLSS im NVIDIA App: **Preset K** verwenden – Preset L ist auf der 30-Serie 15–25% langsamer (kein natives FP8).

---

## RTX 40-Serie

| Einstellung | Wert |
|---|---|
| Bildschärfung | Aus |
| Umgebungsokklusion | Qualität |
| Anisotrope Filterung | Anwendungsgesteuert |
| Anti-Aliasing – FXAA | Aus |
| Anti-Aliasing – Gamma-Korrektur | Ein |
| Anti-Aliasing – Modus | Anwendungsgesteuert |
| Anti-Aliasing – Transparenz | Aus |
| Multi-Frame Sampled AA (MFAA) | Aus |
| DSR – Faktoren | DLDSR 2.25x (bei Headroom in älteren Spielen) |
| RTX Video Super Resolution | Ein |
| NVIDIA Smooth Motion | Ein |
| Low Latency Mode | Ultra |
| Energieverwaltungsmodus | Maximale Leistung bevorzugen |
| Max. Framerate | Monitor-Hz − 3 |
| Shader-Cache-Größe | Unbegrenzt |
| Texturfilterung – Qualität | Hohe Qualität |
| Texturfilterung – Anisotrope Optimierung | Ein |
| Texturfilterung – Trilineare Optimierung | Ein |
| Texturfilterung – Negativer LOD-Bias | Fixieren (Clamp) |
| Vertikale Synchronisation (VSync) | Ein (mit G-Sync als Absicherung) |
| Vorgerenderte Frames | 1 |
| Dreifachpufferung | Aus |

> DLSS im NVIDIA App: **Preset L** verwenden (FP8 vorhanden). Frame Generation + Reflex immer gemeinsam aktivieren.

---

## RTX 50-Serie

| Einstellung | Wert |
|---|---|
| Bildschärfung | Aus |
| Umgebungsokklusion | Qualität |
| Anisotrope Filterung | Anwendungsgesteuert |
| Anti-Aliasing – FXAA | Aus |
| Anti-Aliasing – Gamma-Korrektur | Ein |
| Anti-Aliasing – Modus | Anwendungsgesteuert |
| Anti-Aliasing – Transparenz | Aus |
| Multi-Frame Sampled AA (MFAA) | Aus |
| DSR – Faktoren | DLDSR 2.25x (bei Headroom) |
| RTX Video Super Resolution | Ein |
| NVIDIA Smooth Motion | Ein |
| Low Latency Mode | Ultra (Standard) / On (bei Dynamic MFG) |
| Energieverwaltungsmodus | Maximale Leistung bevorzugen |
| Max. Framerate | Monitor-Hz − 3 (Standard) / Aus (bei Dynamic MFG) |
| Shader-Cache-Größe | Unbegrenzt |
| Texturfilterung – Qualität | Hohe Qualität |
| Texturfilterung – Anisotrope Optimierung | Ein |
| Texturfilterung – Trilineare Optimierung | Ein |
| Texturfilterung – Negativer LOD-Bias | Fixieren (Clamp) |
| Vertikale Synchronisation (VSync) | Ein (Standard) / Aus (bei Dynamic MFG) |
| Vorgerenderte Frames | 1 |
| Dreifachpufferung | Aus |

> DLSS im NVIDIA App: **Preset L** verwenden. ⚠️ Dynamic Multi Frame Generation ist **nicht kompatibel** mit Frame Rate Cap und VSync – beides auf Aus stellen wenn Dynamic MFG aktiv ist.
