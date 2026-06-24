<a href="https://git.io/typing-svg"><img src="https://readme-typing-svg.demolab.com/demo/?size=35&duration=1&pause=10000&color=F74A18&lines=Performance-Tweaks-For-Win11" alt="Typing SVG" /></a>

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

<a href="https://git.io/typing-svg"><img src="https://readme-typing-svg.demolab.com?size=35&duration=1&pause=10000&color=F74A18&width=435&lines=Disclaimer" alt="Typing SVG" /></a>

- This script modifies registry keys and disables system services. Some changes
(Spectre/Meltdown mitigations) reduce security in exchange for performance.
Use on a dedicated gaming PC only.
- This sript is only tested in Fortnite and can cause problems with other games.
- Other games will be tested in the future!


<a href="https://git.io/typing-svg"><img src="https://readme-typing-svg.demolab.com?font=Fira+Code&duration=1&pause=1000&width=435&lines=After-applying" alt="Typing SVG" /></a>

1. Click **Apply** in the bottom right after every section
2. Launch Fortnite per Epic-Games Store or with the Launch_Fortnite_Boosted.bat created on your desktop
3. Set Fortnite in-game graphics as per the main README checklist
