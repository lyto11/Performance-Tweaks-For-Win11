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

## Usage

1. Right-click `win11-boost.bat` and select **Run as Administrator**
   (or just double-click — the script auto-elevates)
2. Type `Y` when prompted to restart
3. After reboot, follow the nvidia-control-panel-checklist.md file for NVIDIA Control Panel and Fortnite settings

## Requirements

- Windows 11
- NVIDIA GPU (AMD users: GPU-specific registry tweaks will silently skip)
- Fortnite installed at the default Epic Games path

# Tested in competitive Games

## Fortnite

- Empty Map
- Looking in the Sky
- Emoting

- Before: 650-800 fps
- After the Script: 750-850 fps
- After the NVIDIA Control Panel Tweaks: soon

## Valorant - Comming Soon

- Map
- Looking in the sky
- lowest settings

- Before: 
- After the Sript:

## The Finals - Comming Soon

- Map
- Locking in the sky
- lowest settings - RT off

- Before: 
- After the Sript:

## Counter Strike 2 - Comming Soon

- Map
- Looking in the sky
- lowest settings

- Before: 
- After the Sript:

## Call of Duty Warzone - Comming Soon

- Map
- looking in the sky
- lowest settings

- Before: 
- After the Sript:

## Apex Legends - Comming Soon

- Map
- looking in the Sky
- lowest settings

- Before: 
- After the Sript:

## Overwatch - Comming Soon

- Map
- looking in the sky
- lowest settings

- Before: 
- After the Sript:

# Tested in graphics-intensive Games

## Forza Horizon 6 - Comming Soon

- Standing still at Festival
- Highest settings possible
- No Upscaling
- No Framegeneration

- Before: 
- After the Sript:

## Rust - Comming Soon

- looking in the Sky
- No Upscaling

- Before: 
- After the Sript:

# Benchmark Programms

## 3d Mark Time Spy - Comming Soon

- Before: 
- After the Sript:

## Boundary Benchmark - Comming Soon

- 1080p
- No Upscaling

- Before: 
- After the Sript:



## Disclaimer

- This script modifies registry keys and disables system services. Some changes
(Spectre/Meltdown mitigations) reduce security in exchange for performance.
Use on a dedicated gaming PC only.
- This sript is only tested in Fortnite and can cause problems with other games.
- Other games will be tested in the future!


# Perfect Settings for best result
> Take your time and go through each step carefully.

---

## Fortnite settings for the best resault in Fortnite (More gametest Coming Soon!)

| Setting | Value |
|---------|-------|
| Window Mode | Windowed Fullscreen |
| V-Sync | Off |
| Frame Rate Limit | Your monitor's refresh rate, for example 240Hz |
| Rendering Mode | Performance |
| 3D Resolution | 100% (you can go lower but I would not recommend dropping this under 80%) |
| View Distance | Near (best performance) / Far (see items on the ground from a higher distance) |
| Textures | Low |
| Meshes | Low |
| Latency Markers | Off |
| NVIDIA Reflex Low Latency | On + Boost (recommended) / On (older GPU or low-end GPU) |
| Report Performance Stats | Disabled |

# NVIDIA Control Panel Setting

## Disclaimer

- These settings can mess with other games
- These settings can actually make your game run worse (depends which GPU you own)
- If that is the case, simply hit the **Restore** button in the respective settings section and click **Apply**
- 
## Manage 3D Settings → Global Settings

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

1. Click **Add**
2. Find or manually add and select `FortniteClient-Win64-Shipping.exe`
3. Apply all the same settings from the table above specifically for Fortnite

> Program-specific settings override global settings and ensure Fortnite always runs with these options regardless of what other games use.

---

## Display → Change Resolution

- Set your monitor to its **highest supported refresh rate** (e.g. 144Hz, 240Hz)
- Make sure it is set here **and** in Windows Display Settings

---

## Display → Adjust Desktop Colour Settings

| Setting | Value |
|---|---|
| Digital Vibrance | 70–80% |

> Higher vibrance makes enemy skins and builds easier to spot against backgrounds.

---

## Video → Adjust Video Colour Settings → Advanced

| Setting | Value |
|---|---|
| Dynamic Range | Full (0-255) |

---

## After Applying

1. Click **Apply** in the bottom right after every section
2. Launch Fortnite per Epic-Games Store or with the Launch_Fortnite_Boosted.bat created on your desktop
3. Set Fortnite in-game graphics as per the main README checklist
