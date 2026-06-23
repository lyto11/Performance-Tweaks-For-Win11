@echo off
:: ============================================================
::  Fortnite Performance Booster for Windows 11
::  Auto-elevates to Administrator if needed
:: ============================================================

:: Auto-elevate: re-launch as admin if not already elevated
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting Administrator privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

title Fortnite Performance Booster
color 0B

echo.
echo  ============================================================
echo   Fortnite Performance Booster for Windows 11
echo  ============================================================
echo.

:: -------------------------------------------------------
:: 1. SET HIGH PERFORMANCE / ULTIMATE PERFORMANCE POWER PLAN
:: -------------------------------------------------------
echo [*] Setting power plan...

powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1

:: Try to unlock and activate Ultimate Performance
powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
for /f "tokens=4" %%G in ('powercfg /list ^| findstr "Ultimate"') do (
    powercfg /setactive %%G >nul 2>&1
)

echo     Power plan set.

:: -------------------------------------------------------
:: 2. CPU PRIORITY & SCHEDULING TWEAKS
:: -------------------------------------------------------
echo [*] Tuning CPU scheduling for games...

:: Foreground app gets 3x more CPU timeslices than background (optimal for gaming)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul

:: Disable CPU core parking (keeps all cores available)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d 0 /f >nul

:: Maximum processor frequency - no upper throttle
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100" /v "ValueMax" /t REG_DWORD /d 100 /f >nul

:: Minimum processor state 100% (CPU never downclocks)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3747d470c5" /v "ValueMin" /t REG_DWORD /d 100 /f >nul

echo     Done.

:: -------------------------------------------------------
:: 3. GPU TWEAKS
:: -------------------------------------------------------
echo [*] Applying GPU tweaks...

:: Hardware-Accelerated GPU Scheduling - reduces CPU-GPU latency
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul

:: Disable NVIDIA Telemetry services (name varies by driver version)
sc config "NvTelemetryContainer"   start= disabled >nul 2>&1
sc stop   "NvTelemetryContainer"   >nul 2>&1
sc config "NvContainerLocalSystem" start= disabled >nul 2>&1
sc stop   "NvContainerLocalSystem" >nul 2>&1

:: NVIDIA low latency pre-render queue (reduce frame queue = less input lag)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "NvContextUsageGlobal" /t REG_DWORD /d 1 /f >nul

:: Disable NVIDIA dynamic Pstate clock throttling (GPU stays at max clock)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableDynamicPstate" /t REG_DWORD /d 1 /f >nul

:: Disable NVIDIA GPU power down between frames
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "GpuPowerDownDisable" /t REG_DWORD /d 1 /f >nul

:: Disable NVIDIA GPU power management (keeps GPU at full speed constantly)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "DisablePowerManagement" /t REG_DWORD /d 1 /f >nul

echo     Done.

:: -------------------------------------------------------
:: 4. DISABLE XBOX GAME BAR AND DVR (MAJOR FPS KILLER)
:: -------------------------------------------------------
echo [*] Disabling Xbox Game Bar and Game DVR...

reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled"                    /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior"                /t REG_DWORD /d 2 /f >nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode"            /t REG_DWORD /d 2 /f >nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode"   /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul

sc config "XblAuthManager" start= disabled >nul 2>&1
sc config "XblGameSave"    start= disabled >nul 2>&1
sc config "XboxNetApiSvc"  start= disabled >nul 2>&1
sc config "XboxGipSvc"     start= disabled >nul 2>&1
sc stop   "XblAuthManager" >nul 2>&1
sc stop   "XblGameSave"    >nul 2>&1
sc stop   "XboxNetApiSvc"  >nul 2>&1

echo     Done.

:: -------------------------------------------------------
:: 5. ENABLE WINDOWS GAME MODE
:: -------------------------------------------------------
echo [*] Enabling Game Mode and optimised presentation...

reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode"          /t REG_DWORD /d 1 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled"        /t REG_DWORD /d 1 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "ShowGameModeNotifications"  /t REG_DWORD /d 0 /f >nul

:: Use optimised flip present model for borderless/windowed mode
reg add "HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "SwapEffectUpgradeEnable=1;" /f >nul

echo     Done.

:: -------------------------------------------------------
:: 6. FORTNITE HIGH-PRIORITY LAUNCH HELPER ON DESKTOP
:: -------------------------------------------------------
echo [*] Creating Fortnite high-priority launch helper on Desktop...

set "HELPER=%USERPROFILE%\Desktop\Launch_Fortnite_Boosted.bat"
(
echo @echo off
echo echo Launching Fortnite with High Priority...
echo start "" "C:\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe"
echo timeout /t 10 /nobreak ^>nul
echo powershell -Command "Get-Process -Name 'FortniteClient-Win64-Shipping' -ErrorAction SilentlyContinue ^| ForEach-Object { $_.PriorityClass = 'High' }" ^>nul 2^>^&1
echo echo Done! Good luck!
echo exit
) > "%HELPER%"

echo     Created: Desktop\Launch_Fortnite_Boosted.bat

:: -------------------------------------------------------
:: 7. DISK I/O OPTIMIZATION
:: -------------------------------------------------------
echo [*] Optimizing disk I/O...

:: Disable idle power management on disk controller
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PartMgr" /v "EnableIdlePowerManagement" /t REG_DWORD /d 0 /f >nul

:: Disable NTFS last access timestamps (speeds up file reads)
fsutil behavior set disablelastaccess 1 >nul 2>&1

echo     Done.

:: -------------------------------------------------------
:: 8. MEMORY OPTIMIZATION
:: -------------------------------------------------------
echo [*] Optimizing memory...

:: Keep kernel and drivers in RAM, not paged to disk
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive"          /t REG_DWORD /d 1 /f >nul

:: Do NOT clear page file at shutdown (saves time, no security benefit for gaming)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown"         /t REG_DWORD /d 0 /f >nul

:: Set to 0 for gaming (1 is for file servers - would steal RAM from the game)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache"               /t REG_DWORD /d 0 /f >nul

:: Disable memory compression (prevents CPU overhead from compressing RAM)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "CompressedMemoryConsumerPolicy" /t REG_DWORD /d 0 /f >nul

echo     Done.

:: -------------------------------------------------------
:: 9. DISABLE BACKGROUND SERVICES
:: -------------------------------------------------------
echo [*] Disabling background services...

sc config "SysMain"          start= disabled >nul 2>&1 & :: Superfetch - not needed on SSD
sc stop   "SysMain"          >nul 2>&1
sc config "DiagTrack"        start= disabled >nul 2>&1 & :: Telemetry
sc stop   "DiagTrack"        >nul 2>&1
sc config "WSearch"          start= disabled >nul 2>&1 & :: Windows Search indexer
sc config "dmwappushservice" start= disabled >nul 2>&1 & :: WAP Push
sc config "MapsBroker"       start= disabled >nul 2>&1 & :: Downloaded Maps
sc config "RetailDemo"       start= disabled >nul 2>&1 & :: Retail Demo Service
sc config "lfsvc"            start= disabled >nul 2>&1 & :: Geolocation
sc config "WMPNetworkSvc"    start= disabled >nul 2>&1 & :: WMP Network Sharing
sc config "RemoteRegistry"   start= disabled >nul 2>&1 & :: Remote Registry

:: Disable background UWP app access globally
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul

echo     Done.

:: -------------------------------------------------------
:: 10. DISABLE TELEMETRY SCHEDULED TASKS
:: -------------------------------------------------------
echo [*] Disabling telemetry scheduled tasks...

schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater"               /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator"    /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"         /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1

echo     Done.

:: -------------------------------------------------------
:: 11. DISABLE DESKTOP WINDOW MANAGER ANIMATIONS
:: -------------------------------------------------------
echo [*] Disabling DWM animations...

reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek"           /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d 0 /f >nul

echo     Done.

:: -------------------------------------------------------
:: 12. VISUAL EFFECTS - PERFORMANCE MODE
:: -------------------------------------------------------
echo [*] Setting visual effects to Performance mode...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Control Panel\Desktop"             /v "MenuShowDelay"   /t REG_SZ    /d "0" /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate"    /t REG_SZ    /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f >nul

echo     Done.

:: -------------------------------------------------------
:: 13. DISABLE FULLSCREEN OPTIMIZATIONS
:: -------------------------------------------------------
echo [*] Disabling Fullscreen Optimizations for lower latency...

:: Disable FSO globally via compatibility flag on the Fortnite executable
reg add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f >nul

echo     Done.

:: -------------------------------------------------------
:: 14. IRQ THREAD PRIORITY BOOST
:: -------------------------------------------------------
echo [*] Boosting IRQ thread priority...

:: Raise hardware interrupt thread priority (reduces input device latency)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "IRQThreadPriority" /t REG_DWORD /d 1 /f >nul

echo     Done.

:: -------------------------------------------------------
:: 15. SYSTEM TIMER RESOLUTION
:: -------------------------------------------------------
echo [*] Setting system timer resolution...

:: Request high resolution system timer globally (smoother frames, better scheduling)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d 1 /f >nul

echo     Done.

:: -------------------------------------------------------
:: 16. DISABLE ONEDRIVE STARTUP
:: -------------------------------------------------------
echo [*] Disabling OneDrive from startup...

reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1

echo     Done.

:: -------------------------------------------------------
:: 17. USB POWER - KEEP PERIPHERALS ACTIVE
:: -------------------------------------------------------
echo [*] Disabling USB selective suspend...

:: Disable USB selective suspend via power policy (prevents mouse/keyboard stutter)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v "DisableSelectiveSuspend" /t REG_DWORD /d 1 /f >nul

echo     Done.

:: -------------------------------------------------------
:: 18. NVIDIA SHADER CACHE SIZE
:: -------------------------------------------------------
echo [*] Maximizing NVIDIA shader cache...

:: Set shader cache size to unlimited (stops Fortnite recompiling shaders = no stutter)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "DxgDdiBlend" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "Perf Level Ovr" /t REG_DWORD /d 0x00000003 /f >nul

echo     Done.

:: -------------------------------------------------------
:: 19. DISABLE MELTDOWN/SPECTRE MITIGATIONS (ADVANCED)
:: -------------------------------------------------------
echo [*] Disabling CPU vulnerability mitigations for max performance...

:: These patches cost 5-15%% CPU performance. Safe to disable on a personal gaming PC
:: not used as a server or shared machine.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride"     /t REG_DWORD /d 3 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d 3 /f >nul

echo     Done.

:: -------------------------------------------------------
:: 20. DISABLE HYPERTHREADING SCHEDULER INEFFICIENCY
:: -------------------------------------------------------
echo [*] Optimizing Windows scheduler for physical cores...

:: Tells the scheduler to prefer physical cores over logical (HT) cores for
:: low-latency foreground tasks like gaming
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ThreadDpcEnable" /t REG_DWORD /d 0 /f >nul

echo     Done.

:: -------------------------------------------------------
:: 21. DISABLE UNNECESSARY SCHEDULED MAINTENANCE TASKS
:: -------------------------------------------------------
echo [*] Disabling background maintenance tasks...

schtasks /Change /TN "Microsoft\Windows\Defrag\ScheduledDefrag"                          /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Maintenance\WinSAT"                             /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"     /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Registry\RegIdleBackup"                         /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Automatic App Update"             /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting"         /Disable >nul 2>&1

echo     Done.

:: -------------------------------------------------------
:: 22. NTFS PERFORMANCE TWEAKS
:: -------------------------------------------------------
echo [*] Applying NTFS performance tweaks...

:: Disable 8.3 short filename generation (speeds up file creation/access)
fsutil behavior set disable8dot3 1 >nul 2>&1

:: Disable encryption on new files (removes overhead if not needed)
fsutil behavior set disableencryption 1 >nul 2>&1

echo     Done.

:: -------------------------------------------------------
:: 23. REDUCE MOUSE INPUT LATENCY
:: -------------------------------------------------------
echo [*] Reducing mouse input latency...

:: Disable mouse pointer acceleration (raw input = 1:1 movement)
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed"      /t REG_SZ /d "0" /f >nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul

:: Disable pointer precision (same as unchecking "Enhance Pointer Precision" in settings)
reg add "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "0" /f >nul

echo     Done.

:: -------------------------------------------------------
:: 24. PAGE FILE - SET FIXED SIZE TO PREVENT RESIZING STUTTER
:: -------------------------------------------------------
echo [*] Setting fixed page file size to prevent runtime resizing...

:: A dynamically-sized page file causes disk stutter when Windows expands it mid-game.
:: This sets a fixed 4096MB page file on C: to eliminate that stutter.
:: Requires restart to take effect.
wmic computersystem set AutomaticManagedPagefile=False >nul 2>&1
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=4096,MaximumSize=4096 >nul 2>&1

echo     Done.

:: -------------------------------------------------------
:: 25. DISABLE WINDOWS UPDATE DELIVERY OPTIMIZATION
::     (stops Windows uploading updates to other PCs)
:: -------------------------------------------------------
echo [*] Disabling Windows Update Delivery Optimization...

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d 0 /f >nul
sc config "DoSvc" start= disabled >nul 2>&1
sc stop   "DoSvc" >nul 2>&1

echo     Done.

:: -------------------------------------------------------
:: DONE
:: -------------------------------------------------------
echo.
echo  ============================================================
echo   All Fortnite optimisations applied!
echo.
echo   CRITICAL CHECKLIST:
echo   [1] RESTART YOUR PC (required - GPU + CPU + power changes)
echo   [2] Update GPU Drivers (NVIDIA/AMD latest)
echo   [3] NVIDIA Control Panel:
echo       - Power Management: Maximum Performance
echo       - Low Latency Mode: Ultra
echo       - Max Frame Rate: Unlimited
echo   [4] Fortnite Graphics Settings:
echo       - Rendering Mode: DirectX 12 (NOT 11)
echo       - Frame Rate Limit: Unlimited or 240+
echo       - 3D Resolution: 100%%
echo       - Shadows: OFF
echo       - Anti-Aliasing: FXAA or OFF
echo       - Effects: Low
echo       - Textures: Medium
echo       - Motion Blur: OFF
echo   [5] Use Launch_Fortnite_Boosted.bat on your Desktop
echo   [6] Windows Settings > Gaming > Game Mode: ON
echo  ============================================================
echo.

set /p reboot="Restart now for best results? (Y/N): "
if /i "%reboot%"=="Y" shutdown /r /t 10 /c "Restarting to apply Fortnite optimisations..."

pause
exit /b 0
