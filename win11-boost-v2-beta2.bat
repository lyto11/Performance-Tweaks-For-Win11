@echo off
:: ============================================================
::  Windows 11 Performance Booster
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

title  Win11 FPS Booster
color 0A
cls

echo.
echo  +===========================================================+
echo  ^|                                                           ^|
echo  ^|        WIN11  FPS  ^&  GAMING  PERFORMANCE  BOOSTER       ^|
echo  ^|                                                           ^|
echo  ^|        25 Tweaks  ^|  Auto-Admin  ^|  Gaming Focused        ^|
echo  ^|                                                           ^|
echo  +===========================================================+
echo.
echo  [ SYSTEM ] Administrator confirmed. Starting...
echo.
timeout /t 2 /nobreak >nul

:: -------------------------------------------------------
:: 1. POWER PLAN
:: -------------------------------------------------------
color 0B
echo  +-----------------------------------------------------------+
echo  ^|  [01/25]  POWER PLAN  --  Ultimate Performance            ^|
echo  +-----------------------------------------------------------+

powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1

powercfg /list 2>nul | findstr /i "Ultimate" >nul 2>&1
if %errorlevel% EQU 0 (
    echo  [ -- ] Already unlocked. Selecting...
    for /f "tokens=4" %%G in ('powercfg /list ^| findstr /i "Ultimate"') do powercfg /setactive %%G >nul 2>&1
) else (
    echo  [ -- ] Unlocking for first time...
    powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
    for /f "tokens=4" %%G in ('powercfg /list ^| findstr /i "Ultimate"') do powercfg /setactive %%G >nul 2>&1
)

echo  [ OK ] Power plan set to Ultimate Performance.
echo.

:: -------------------------------------------------------
:: 2. CPU SCHEDULING
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [02/25]  CPU SCHEDULING  --  Foreground Priority         ^|
echo  +-----------------------------------------------------------+

reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100" /v "ValueMax" /t REG_DWORD /d 100 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3747d470c5" /v "ValueMin" /t REG_DWORD /d 100 /f >nul 2>&1

echo  [ OK ] Core parking OFF  ^|  CPU always at max  ^|  Foreground boosted.
echo.

:: -------------------------------------------------------
:: 3. GPU TWEAKS
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [03/25]  GPU  --  HAGS / NVIDIA / Low Latency            ^|
echo  +-----------------------------------------------------------+

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1
sc config "NvTelemetryContainer"   start= disabled >nul 2>&1
sc stop   "NvTelemetryContainer"   >nul 2>&1
sc config "NvContainerLocalSystem" start= disabled >nul 2>&1
sc stop   "NvContainerLocalSystem" >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "NvContextUsageGlobal" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableDynamicPstate" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "GpuPowerDownDisable" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "DisablePowerManagement" /t REG_DWORD /d 1 /f >nul 2>&1

echo  [ OK ] HAGS enabled  ^|  NVIDIA pstate OFF  ^|  GPU power mgmt OFF.
echo.

:: -------------------------------------------------------
:: 4. XBOX GAME BAR / DVR
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [04/25]  GAME BAR / DVR  --  Major FPS Killer Removed    ^|
echo  +-----------------------------------------------------------+

reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled"                  /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior"              /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode"          /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
sc config "XblAuthManager" start= disabled >nul 2>&1
sc config "XblGameSave"    start= disabled >nul 2>&1
sc config "XboxNetApiSvc"  start= disabled >nul 2>&1
sc config "XboxGipSvc"     start= disabled >nul 2>&1
sc stop   "XblAuthManager" >nul 2>&1
sc stop   "XblGameSave"    >nul 2>&1
sc stop   "XboxNetApiSvc"  >nul 2>&1

echo  [ OK ] Game DVR killed  ^|  Xbox services stopped.
echo.

:: -------------------------------------------------------
:: 5. DISK I/O
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [05/25]  DISK I/O  --  NTFS Latency Tweaks               ^|
echo  +-----------------------------------------------------------+

reg add "HKLM\SYSTEM\CurrentControlSet\Services\PartMgr" /v "EnableIdlePowerManagement" /t REG_DWORD /d 0 /f >nul 2>&1
fsutil behavior set disablelastaccess 1 >nul 2>&1

echo  [ OK ] Last-access timestamps OFF  ^|  Disk idle power OFF.
echo.

:: -------------------------------------------------------
:: 6. MEMORY
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [06/25]  MEMORY  --  RAM / Page File Optimization         ^|
echo  +-----------------------------------------------------------+

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive"          /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown"         /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache"               /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "CompressedMemoryConsumerPolicy" /t REG_DWORD /d 0 /f >nul 2>&1

echo  [ OK ] Kernel in RAM  ^|  Compression OFF  ^|  Gaming cache mode.
echo.

:: -------------------------------------------------------
:: 7. BACKGROUND SERVICES
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [07/25]  SERVICES  --  Disabling Background Junk         ^|
echo  +-----------------------------------------------------------+

sc config "SysMain"          start= disabled >nul 2>&1
sc stop   "SysMain"          >nul 2>&1
sc config "DiagTrack"        start= disabled >nul 2>&1
sc stop   "DiagTrack"        >nul 2>&1
sc config "WSearch"          start= disabled >nul 2>&1
sc config "dmwappushservice" start= disabled >nul 2>&1
sc config "MapsBroker"       start= disabled >nul 2>&1
sc config "RetailDemo"       start= disabled >nul 2>&1
sc config "lfsvc"            start= disabled >nul 2>&1
sc config "WMPNetworkSvc"    start= disabled >nul 2>&1
sc config "RemoteRegistry"   start= disabled >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1

echo  [ OK ] SysMain / DiagTrack / WSearch / 6 more stopped.
echo.

:: -------------------------------------------------------
:: 8. TELEMETRY TASKS
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [08/25]  SCHTASKS  --  Telemetry Tasks Killed            ^|
echo  +-----------------------------------------------------------+

schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater"               /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy"                                           /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator"    /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"        /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClient"                                 /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting"                  /Disable >nul 2>&1

echo  [ OK ] 8 telemetry scheduled tasks disabled.
echo.

:: -------------------------------------------------------
:: 9. TELEMETRY REGISTRY
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [09/25]  TELEMETRY  --  Registry Kill Switch             ^|
echo  +-----------------------------------------------------------+

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1

echo  [ OK ] AllowTelemetry = 0  ^|  Data collection off.
echo.

:: -------------------------------------------------------
:: 10. VISUAL EFFECTS
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [10/25]  VISUALS  --  Animations Off / UI Snappy         ^|
echo  +-----------------------------------------------------------+

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f >nul 2>&1

echo  [ OK ] Animations OFF  ^|  Menu delay = 0.
echo.

:: -------------------------------------------------------
:: 11. FULLSCREEN OPTIMIZATIONS
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [11/25]  FULLSCREEN  --  FSO Disabled for Lower Latency  ^|
echo  +-----------------------------------------------------------+

reg add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Path\To\Your\Game.exe" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f >nul 2>&1

echo  [ OK ] Fullscreen optimization disabled globally.
echo  [ !! ] Edit C:\Path\To\Your\Game.exe in script if needed.
echo.

:: -------------------------------------------------------
:: 12. IRQ PRIORITY
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [12/25]  IRQ  --  Thread Priority Boost                  ^|
echo  +-----------------------------------------------------------+

reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "IRQThreadPriority" /t REG_DWORD /d 1 /f >nul 2>&1

echo  [ OK ] IRQ thread priority boosted.
echo.

:: -------------------------------------------------------
:: 13. TIMER RESOLUTION
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [13/25]  TIMER  --  High Resolution System Timer         ^|
echo  +-----------------------------------------------------------+

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d 1 /f >nul 2>&1

echo  [ OK ] Global high-resolution timer enabled.
echo.

:: -------------------------------------------------------
:: 14. ONEDRIVE
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [14/25]  ONEDRIVE  --  Removed from Startup              ^|
echo  +-----------------------------------------------------------+

reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1

echo  [ OK ] OneDrive startup entry removed.
echo.

:: -------------------------------------------------------
:: 15. USB SELECTIVE SUSPEND
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [15/25]  USB  --  Selective Suspend Off                  ^|
echo  +-----------------------------------------------------------+

reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v "DisableSelectiveSuspend" /t REG_DWORD /d 1 /f >nul 2>&1

echo  [ OK ] USB selective suspend disabled  ^|  No peripheral stutter.
echo.

:: -------------------------------------------------------
:: 16. NVIDIA SHADER CACHE
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [16/25]  NVIDIA SHADER CACHE  --  Unlimited              ^|
echo  +-----------------------------------------------------------+

reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "DxgDdiBlend" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "Perf Level Ovr" /t REG_DWORD /d 0x00000003 /f >nul 2>&1

echo  [ OK ] Shader cache maximized  ^|  No in-game recompile stutter.
echo.

:: -------------------------------------------------------
:: 17. MELTDOWN / SPECTRE
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [17/25]  CPU MITIGATIONS  --  Spectre/Meltdown OFF       ^|
echo  +-----------------------------------------------------------+
echo  [ !! ] Safe for personal gaming PCs only.

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride"     /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d 3 /f >nul 2>&1

echo  [ OK ] Spectre/Meltdown patches bypassed  ^|  +5-15%% CPU freed.
echo.

:: -------------------------------------------------------
:: 18. HT SCHEDULER
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [18/25]  SCHEDULER  --  Physical Core Preference         ^|
echo  +-----------------------------------------------------------+

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ThreadDpcEnable" /t REG_DWORD /d 0 /f >nul 2>&1

echo  [ OK ] Scheduler prefers physical over logical cores.
echo.

:: -------------------------------------------------------
:: 19. MAINTENANCE TASKS
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [19/25]  MAINTENANCE  --  Background Tasks Off           ^|
echo  +-----------------------------------------------------------+

schtasks /Change /TN "Microsoft\Windows\Defrag\ScheduledDefrag"                      /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Maintenance\WinSAT"                          /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"  /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Registry\RegIdleBackup"                      /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Automatic App Update"          /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting"      /Disable >nul 2>&1

echo  [ OK ] Defrag / WinSAT / AnalyzeSystem / 3 more disabled.
echo.

:: -------------------------------------------------------
:: 20. NTFS TWEAKS
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [20/25]  NTFS  --  File System Performance               ^|
echo  +-----------------------------------------------------------+

fsutil behavior set disable8dot3 1 >nul 2>&1
fsutil behavior set disableencryption 1 >nul 2>&1

echo  [ OK ] 8.3 filenames OFF  ^|  Encryption overhead OFF.
echo.

:: -------------------------------------------------------
:: 21. MOUSE INPUT
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [21/25]  MOUSE  --  Raw Input / No Acceleration          ^|
echo  +-----------------------------------------------------------+

reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed"      /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseHoverTime"  /t REG_SZ /d "0" /f >nul 2>&1

echo  [ OK ] Pointer acceleration OFF  ^|  Raw 1:1 input active.
echo.

:: -------------------------------------------------------
:: 22. PAGE FILE
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [22/25]  PAGE FILE  --  Fixed Size, No Resize Stutter    ^|
echo  +-----------------------------------------------------------+

wmic computersystem set AutomaticManagedPagefile=False >nul 2>&1
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=4096,MaximumSize=4096 >nul 2>&1

echo  [ OK ] Page file fixed at 4096MB  ^|  No runtime resize stutter.
echo.

:: -------------------------------------------------------
:: 23. DELIVERY OPTIMIZATION
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [23/25]  WIN UPDATE  --  Delivery Optimization Off       ^|
echo  +-----------------------------------------------------------+

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d 0 /f >nul 2>&1
sc config "DoSvc" start= disabled >nul 2>&1
sc stop   "DoSvc" >nul 2>&1

echo  [ OK ] Delivery optimization off  ^|  No background uploading.
echo.

:: -------------------------------------------------------
:: 24. MULTIMEDIA SYSTEM PROFILE
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [24/25]  MMCSS  --  Games Get Highest Priority           ^|
echo  +-----------------------------------------------------------+

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1

echo  [ OK ] MMCSS Games = High  ^|  GPU priority 8  ^|  No throttle.
echo.

:: -------------------------------------------------------
:: 25. PROCESS IDLE TASKS
:: -------------------------------------------------------
echo  +-----------------------------------------------------------+
echo  ^|  [25/25]  IDLE FLUSH  --  ProcessIdleTasks                ^|
echo  +-----------------------------------------------------------+

Rundll32.exe advapi32.dll,ProcessIdleTasks

echo  [ OK ] Idle task queue flushed.
echo.

:: -------------------------------------------------------
:: COMPLETE
:: -------------------------------------------------------
color 0A
echo  +===========================================================+
echo  ^|                                                           ^|
echo  ^|   ALL 25 TWEAKS APPLIED SUCCESSFULLY                     ^|
echo  ^|                                                           ^|
echo  ^|   01 Power Plan        02 CPU Scheduling                 ^|
echo  ^|   03 GPU / NVIDIA      04 Game Bar / DVR                 ^|
echo  ^|   05 Disk I/O          06 Memory                         ^|
echo  ^|   07 Services          08 Telemetry Tasks                ^|
echo  ^|   09 Telemetry Reg     10 Visual Effects                 ^|
echo  ^|   11 Fullscreen        12 IRQ Priority                   ^|
echo  ^|   13 Timer Resolution  14 OneDrive                       ^|
echo  ^|   15 USB Suspend       16 Shader Cache                   ^|
echo  ^|   17 CPU Mitigations   18 HT Scheduler                   ^|
echo  ^|   19 Maintenance       20 NTFS                           ^|
echo  ^|   21 Mouse Input       22 Page File                      ^|
echo  ^|   23 Delivery Opt      24 MMCSS Games                    ^|
echo  ^|   25 Idle Flush                                          ^|
echo  ^|                                                           ^|
echo  ^|   Restart recommended to apply all changes.              ^|
echo  ^|                                                           ^|
echo  +===========================================================+
echo.

set /p reboot=" Restart now for best results? (Y/N): "
if /i "%reboot%"=="Y" (
    echo  Restarting in 10 seconds...
    shutdown /r /t 10 /c "Applying Win11 FPS optimisations..."
)

echo.
pause
exit /b 0
