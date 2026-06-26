@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

:: Enable color support
for /f "tokens=*" %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

:: Enable virtual terminal processing for ANSI colors
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1

:: Set console properties
mode con lines=35 cols=140
title Comprehensive Windows Optimizer

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

:: Define color codes
call :SetColors

:MainMenu
cls
echo.
echo  ============================================================
echo  %CUSTOM%          Comprehensive Windows Optimizer%WHITE%
echo  %CUSTOM%      Privacy, Security & Performance Tweaks%WHITE%
echo  ============================================================
echo.
echo  [1] Run All Optimizations
echo  [E] Exit
echo.
set /p "choice=Select option: "

if "%choice%"=="1" goto :RunAllOptimizations
if /i "%choice%"=="E" exit /b
goto :MainMenu

:RunAllOptimizations
cls
echo.

:: ──────────────────────────────────────────────────────────────────────
::  POWER PLAN SETTINGS
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Setting power plan to Ultimate Performance...

powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1

powercfg /list 2>nul | findstr /i "Ultimate" >nul 2>&1
if %errorlevel% EQU 0 (
    echo [ -- ] Already unlocked. Selecting...
    for /f "tokens=4" %%G in ('powercfg /list ^| findstr /i "Ultimate"') do powercfg /setactive %%G >nul 2>&1
) else (
    echo [ -- ] Unlocking for first time...
    powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
    for /f "tokens=4" %%G in ('powercfg /list ^| findstr /i "Ultimate"') do powercfg /setactive %%G >nul 2>&1
)

echo [OK] Power plan set to Ultimate Performance.

:: ──────────────────────────────────────────────────────────────────────
::  CPU PRIORITY & SCHEDULING
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Tuning CPU scheduling for performance...

:: Foreground app gets 3x more CPU timeslices than background
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul

:: Disable CPU core parking (keeps all cores available)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d 0 /f >nul

:: Maximum processor frequency - no upper throttle
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100" /v "ValueMax" /t REG_DWORD /d 100 /f >nul

:: Minimum processor state 100% (CPU never downclocks)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3747d470c5" /v "ValueMin" /t REG_DWORD /d 100 /f >nul

:: Additional CPU power settings
powercfg -attributes SUB_PROCESSOR -ATTRIB_HID >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1

:: CPU handling improvements
bcdedit /set interruptaffinitypolicy 3 >nul 2>&1
bcdedit /set maxprocstate 100 >nul 2>&1

echo [OK] CPU scheduling optimized.

:: ──────────────────────────────────────────────────────────────────────
::  GPU OPTIMIZATIONS
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Applying GPU tweaks...

:: Hardware-Accelerated GPU Scheduling
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul

:: NVIDIA specific tweaks
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "NvContextUsageGlobal" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableDynamicPstate" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "GpuPowerDownDisable" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "DisablePowerManagement" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v RmGpsPsEnablePerCpuCoreDpc /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v RmGpsPsEnablePerCpuCoreDpc /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v RmGpsPsEnablePerCpuCoreDpc /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\NVAPI" /v RmGpsPsEnablePerCpuCoreDpc /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v RmGpsPsEnablePerCpuCoreDpc /t REG_DWORD /d 1 /f >nul

:: GPU priority and TDR settings
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLevel" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TiledResources" /t REG_DWORD /d 1 /f >nul

echo [OK] GPU tweaks applied.

:: ──────────────────────────────────────────────────────────────────────
::  DISABLE XBOX GAME BAR & DVR
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Disabling Xbox Game Bar and Game DVR...

reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f >nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\GameBar" /v ShowStartupPanel /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\GameBar" /v GamePanelStartupTipIndex /t REG_DWORD /d 3 /f >nul
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 0 /f >nul

sc config "XblAuthManager" start= disabled >nul 2>&1
sc config "XblGameSave" start= disabled >nul 2>&1
sc config "XboxNetApiSvc" start= disabled >nul 2>&1
sc config "XboxGipSvc" start= disabled >nul 2>&1
sc stop "XblAuthManager" >nul 2>&1
sc stop "XblGameSave" >nul 2>&1
sc stop "XboxNetApiSvc" >nul 2>&1

schtasks /end /tn "\Microsoft\XblGameSave\XblGameSaveTask" >nul 2>&1
schtasks /change /tn "\Microsoft\XblGameSave\XblGameSaveTask" /disable >nul 2>&1
schtasks /end /tn "\Microsoft\XblGameSave\XblGameSaveTaskLogon" >nul 2>&1
schtasks /change /tn "\Microsoft\XblGameSave\XblGameSaveTaskLogon" /disable >nul 2>&1

echo [OK] Xbox Game Bar and DVR disabled.

:: ──────────────────────────────────────────────────────────────────────
::  DISABLE TELEMETRY
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Disabling Windows Telemetry...

:: Registry tweaks
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v DoNotShowFeedbackNotifications /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v ContentDeliveryAllowed /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v OemPreInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEverEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338387Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353698Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v PeriodInNanoSeconds /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableTailoredExperiencesWithDiagnosticData /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowToGetHelp /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v EnableFeeds /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v HideSCAMeetNow /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable telemetry scheduled tasks
schtasks /End /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /F >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /F >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Application Experience\MareBackup" /F >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\MareBackup" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Application Experience\StartupAppTask" /F >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Application Experience\PcaPatchDbTask" /F >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\PcaPatchDbTask" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Autochk\Proxy" /F >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /F >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /F >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" /disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /F >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Feedback\Siuf\DmClient" /F >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClient" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" /F >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /F >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /disable >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyMonitor" >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyMonitor" /disable >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyRefresh" >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyRefresh" /disable >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyUpload" >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyUpload" /disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Maps\MapsUpdateTask" /F >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Maps\MapsUpdateTask" /Disable >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Maintenance\WinSAT" >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Maintenance\WinSAT" /disable >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Application Experience\AitAgent" >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\AitAgent" /disable >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Windows Error Reporting\QueueReporting" >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Windows Error Reporting\QueueReporting" /disable >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /disable >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\DiskFootprint\Diagnostics" >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\DiskFootprint\Diagnostics" /disable >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\PI\Sqm-Tasks" >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\PI\Sqm-Tasks" /disable >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\NetTrace\GatherNetworkInfo" >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\NetTrace\GatherNetworkInfo" /disable >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\AppID\SmartScreenSpecific" >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\AppID\SmartScreenSpecific" /disable >nul 2>&1

:: PowerShell telemetry disable (removed due to permission issues)

echo [OK] Telemetry disabled.

:: ──────────────────────────────────────────────────────────────────────
::  DISABLE BACKGROUND SERVICES
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Disabling unnecessary background services...

sc config "SysMain" start= disabled >nul 2>&1
sc stop "SysMain" >nul 2>&1
sc config "DiagTrack" start= disabled >nul 2>&1
sc stop "DiagTrack" >nul 2>&1
sc config "WSearch" start= disabled >nul 2>&1
sc config "dmwappushservice" start= disabled >nul 2>&1
sc config "MapsBroker" start= disabled >nul 2>&1
sc config "RetailDemo" start= disabled >nul 2>&1
sc config "lfsvc" start= disabled >nul 2>&1
sc config "WMPNetworkSvc" start= disabled >nul 2>&1
sc config "RemoteRegistry" start= disabled >nul 2>&1
sc config "HomeGroupListener" start= demand >nul 2>&1
sc config "HomeGroupProvider" start= demand >nul 2>&1

:: Disable background UWP app access globally
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul

echo [OK] Background services disabled.

:: ──────────────────────────────────────────────────────────────────────
::  DISABLE OFFICE TELEMETRY
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Disabling Microsoft Office Telemetry...

reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Outlook\Options\Mail" /v "EnableLogging" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\Mail" /v "EnableLogging" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Outlook\Options\Calendar" /v "EnableCalendarLogging" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\Calendar" /v "EnableCalendarLogging" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Word\Options" /v "EnableLogging" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Word\Options" /v "EnableLogging" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\15.0\OSM" /v "EnableLogging" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\16.0\OSM" /v "EnableLogging" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\15.0\OSM" /v "EnableUpload" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\16.0\OSM" /v "EnableUpload" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v "VerboseLogging" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\ClientTelemetry" /v "VerboseLogging" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Common" /v "QMEnable" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common" /v "QMEnable" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Common\Feedback" /v "Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\Feedback" /v "Enabled" /t REG_DWORD /d 0 /f >nul

schtasks /end /tn "\Microsoft\Office\OfficeTelemetryAgentFallBack2016" >nul 2>&1
schtasks /change /tn "\Microsoft\Office\OfficeTelemetryAgentFallBack2016" /disable >nul 2>&1
schtasks /end /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn2016" >nul 2>&1
schtasks /change /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn2016" /disable >nul 2>&1
schtasks /end /tn "\Microsoft\Office\OfficeTelemetryAgentFallBack" >nul 2>&1
schtasks /change /tn "\Microsoft\Office\OfficeTelemetryAgentFallBack" /disable >nul 2>&1
schtasks /end /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn" >nul 2>&1
schtasks /change /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn" /disable >nul 2>&1

echo [OK] Office Telemetry disabled.

:: ──────────────────────────────────────────────────────────────────────
::  PRIVACY & SECURITY TWEAKS
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Applying privacy and security tweaks...

:: Disable Location Tracking
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /t REG_SZ /d Deny /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v SensorPermissionState /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v Status /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\Maps" /v AutoUpdateEnabled /t REG_DWORD /d 0 /f >nul

:: Disable SMBv1 (Security Risk)
powershell -Command "Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart" >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "SMB1" /t REG_DWORD /d 0 /f >nul

:: Disable Memory Integrity (as requested)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v HVCIMATRequired /t REG_DWORD /d 0 /f >nul
bcdedit /set hypervisorsettings Off >nul 2>&1
bcdedit /set hypervisorlaunchtype Off >nul 2>&1

:: Disable Copilot
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowCopilotButton /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\Shell\Copilot" /v IsCopilotAvailable /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\Shell\Copilot" /v CopilotDisabledReason /t REG_SZ /d IsEnabledForGeographicRegionFailed /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsCopilot" /v AllowCopilotRuntime /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\Shell\Copilot\BingChat" /v IsUserEligible /t REG_DWORD /d 0 /f >nul
powershell -Command "Get-AppxPackage -AllUsers *Copilot* | Remove-AppxPackage -AllUsers" >nul 2>&1
powershell -Command "Get-AppxProvisionedPackage -Online | Where-Object PackageName -like '*Copilot*' | Remove-AppxProvisionedPackage -Online" >nul 2>&1
dism /online /remove-package /package-name:Microsoft.Windows.Copilot >nul 2>&1

:: Disable Recall
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v DisableAIDataAnalysis /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v AllowRecallEnablement /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v VerifiedAndReputablePolicyState /t REG_DWORD /d 0 /f >nul
dism /Online /Disable-Feature /FeatureName:Recall /Quiet /NoRestart >nul 2>&1

:: Disable App History
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v UploadUserActivities /t REG_DWORD /d 0 /f >nul

:: Disable Bing Searches
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f >nul

:: Disable Consumer Features
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f >nul

:: Disable AutoUpdate (driver updates only)
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Update" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v PreventDeviceMetadataFromNetwork /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v SearchOrderConfig /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v DontSearchWindowsUpdate /t REG_DWORD /d 1 /f >nul

:: Disable OneDrive
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "if (Test-Path $env:OneDrive) { Remove-Item -Recurse -Force -ErrorAction SilentlyContinue \"$env:localappdata\Microsoft\OneDrive\"; Remove-Item -Recurse -Force -ErrorAction SilentlyContinue \"$env:localappdata\OneDrive\"; Remove-Item -Recurse -Force -ErrorAction SilentlyContinue \"$env:programdata\Microsoft OneDrive\"; Remove-Item -Recurse -Force -ErrorAction SilentlyContinue \"$env:systemdrive\OneDriveTemp\"; reg delete \"HKEY_CURRENT_USER\Software\Microsoft\OneDrive\" -f; reg delete \"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run\" /v OneDrive /f; Remove-Item -Force -ErrorAction SilentlyContinue \"$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk\"; Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' -ea SilentlyContinue | Unregister-ScheduledTask -Confirm:$false }" >nul 2>&1

:: Debloat Edge
reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v CreateDesktopShortcutDefault /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v PersonalizationReportingEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v ShowRecommendationsEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v HideFirstRunExperience /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v UserFeedbackAllowed /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v ConfigureDoNotTrack /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v AlternateErrorPagesEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v EdgeCollectionsEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v EdgeShoppingAssistantEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v MicrosoftEdgeInsiderPromotionEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v ShowMicrosoftRewards /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v WebWidgetAllowed /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v DiagnosticData /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v EdgeAssetDeliveryServiceEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v CryptoWalletEnabled /t REG_DWORD /d 0 /f >nul

:: Debloat Brave
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v BraveRewardsDisabled /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v BraveWalletDisabled /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v BraveVPNDisabled /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v BraveAIChatEnabled /t REG_DWORD /d 0 /f >nul

:: Remove Bloatware
dism /Online /Remove-ProvisionedAppxPackage /PackageName:MicrosoftCorporationII.QuickAssist >nul 2>&1
dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsFeedbackHub >nul 2>&1
dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Copilot >nul 2>&1
dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.BingWeather >nul 2>&1
dism /Online /Remove-ProvisionedAppxPackage /PackageName:MicrosoftCorporationII.MicrosoftFamily >nul 2>&1
dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftOfficeHub >nul 2>&1
dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.BingSearch >nul 2>&1
dism /Online /Remove-ProvisionedAppxPackage /PackageName:Clipchamp.Clipchamp >nul 2>&1
dism /Online /Remove-ProvisionedAppxPackage /PackageName:MSTeams >nul 2>&1
dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Todos >nul 2>&1
dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftStickyNotes >nul 2>&1
dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.BingNews >nul 2>&1
dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.OutlookForWindows >nul 2>&1
dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsAlarms >nul 2>&1
dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftSolitaireCollection >nul 2>&1

:: Disable Hibernation
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Power" /v HibernateEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v ShowHibernateOption /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabledDefault" /t REG_DWORD /d 0 /f >nul
powercfg.exe /hibernate off >nul 2>&1

:: Disable Fullscreen Optimizations
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f >nul

:: Disable Explorer Auto Discovery
powershell -NoProfile -ExecutionPolicy Bypass -Command "$bags = 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags'; $bagMRU = 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU'; Remove-Item -Path $bags -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item -Path $bagMRU -Recurse -Force -ErrorAction SilentlyContinue; $allFolders = 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell'; if (!(Test-Path $allFolders)) {New-Item -Path $allFolders -Force | Out-Null}; New-ItemProperty -Path $allFolders -Name 'FolderType' -Value 'NotSpecified' -PropertyType String -Force | Out-Null" >nul 2>&1

:: Disable WPBT Execution
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v DisableWpbtExecution /t REG_DWORD /d 1 /f >nul

:: Disable Teredo
netsh interface teredo set state disabled >nul 2>&1

:: Disable Windows Tasks
schtasks /End /TN "Microsoft\Windows\Maintenance\WinSAT" >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Maintenance\WinSAT" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Defrag\ScheduledDefrag" >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Defrag\ScheduledDefrag" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\UpdateOrchestrator\Reboot" >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\Reboot" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\UpdateOrchestrator\USO_UxBroker_ReadyToReboot" >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\USO_UxBroker_ReadyToReboot" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\UpdateOrchestrator\USO_UxBroker_Update" >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\USO_UxBroker_Update" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Autochk\Proxy" >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\DiskFootprint\Diagnostics" >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\DiskFootprint\Diagnostics" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Superfetch\SysMain" >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Superfetch\SysMain" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Edge\EdgeUpdate" >nul 2>&1
schtasks /Change /TN "Microsoft\Edge\EdgeUpdate" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\WindowsUpdate\AutomaticAppUpdate" >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\AutomaticAppUpdate" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\TabletPC\TabletPCEventFilter" >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\TabletPC\TabletPCEventFilter" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Diagnosis\OnlineCrashDump" >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Diagnosis\OnlineCrashDump" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Windows Compatibility\AblibLogger" >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Compatibility\AblibLogger" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Windows Error Reporting\ErrorReporting" >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\ErrorReporting" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Diagnostics\Scheduled" >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Diagnostics\Scheduled" /Disable >nul 2>&1
schtasks /End /TN "Microsoft\Windows\Search\GatherUserDiaries" >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Search\GatherUserDiaries" /Disable >nul 2>&1

echo [OK] Privacy and security tweaks applied.

:: ──────────────────────────────────────────────────────────────────────
::  DISK I/O OPTIMIZATION
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Optimizing disk I/O...

:: Disable idle power management on disk controller
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PartMgr" /v "EnableIdlePowerManagement" /t REG_DWORD /d 0 /f >nul

:: Disable NTFS last access timestamps
fsutil behavior set disablelastaccess 1 >nul 2>&1

:: Disable 8.3 short filename generation
fsutil behavior set disable8dot3 1 >nul 2>&1

:: Disable encryption on new files
fsutil behavior set disableencryption 1 >nul 2>&1

echo [OK] Disk I/O optimized.

:: ──────────────────────────────────────────────────────────────────────
::  MEMORY OPTIMIZATION
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Optimizing memory...

:: Keep kernel and drivers in RAM
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul

:: Do NOT clear page file at shutdown
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d 0 /f >nul

:: Set to 0 for gaming
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul

:: Disable memory compression
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "CompressedMemoryConsumerPolicy" /t REG_DWORD /d 0 /f >nul
powershell -Command "Disable-MMAgent -mc" >nul 2>&1
bcdedit /set hypervisorlaunchtype off >nul 2>&1

:: Additional memory tweaks
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettings /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v NonPagedPoolQuota /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v NonPagedPoolSize /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v SessionViewSize /t REG_DWORD /d 192 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v SystemPages /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v SecondLevelDataCache /t REG_DWORD /d 3072 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v SessionPoolSize /t REG_DWORD /d 192 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v PagedPoolSize /t REG_DWORD /d 192 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v PagedPoolQuota /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v PhysicalAddressExtension /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v IoPageLockLimit /t REG_DWORD /d 1048576 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v PoolUsageMaximum /t REG_DWORD /d 96 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 3 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f >nul
fsutil behavior set memory usage 2 >nul 2>&1

echo [OK] Memory optimized.

:: ──────────────────────────────────────────────────────────────────────
::  NETWORK OPTIMIZATIONS
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Optimizing network settings...

:: TCP Optimizations
reg add "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v "explorer.exe" /t REG_DWORD /d 16 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v "iexplorer.exe" /t REG_DWORD /d 16 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER" /v "explorer.exe" /t REG_DWORD /d 16 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER" /v "iexplorer.exe" /t REG_DWORD /d 16 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d 5 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d 4 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d 7 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d 65534 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d 48 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d 100 /f >nul

netsh int tcp set supplemental internet congestionprovider=ctcp >nul 2>&1
PowerShell.exe Set-NetTCPSetting -SettingName internet -AutoTuningLevelLocal normal >nul 2>&1
PowerShell.exe Set-NetOffloadGlobalSetting -ReceiveSideScaling enabled >nul 2>&1
PowerShell.exe Set-NetTCPSetting -SettingName internet -EcnCapability disabled >nul 2>&1
PowerShell.exe Set-NetOffloadGlobalSetting -Chimney disabled >nul 2>&1
PowerShell.exe Set-NetTCPSetting -SettingName internet -Timestamps disabled >nul 2>&1
PowerShell.exe Set-NetTCPSetting -SettingName internet -MaxSynRetransmissions 2 >nul 2>&1
PowerShell.exe Set-NetTCPSetting -SettingName internet -NonSackRttResiliency disabled >nul 2>&1
PowerShell.exe Set-NetTCPSetting -SettingName internet -InitialRto 2000 >nul 2>&1
PowerShell.exe Set-NetTCPSetting -SettingName internet -MinRto 300 >nul 2>&1

:: LAN/SMB Optimizations
reg add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v autodisconnect /t REG_DWORD /d 0xFFFFFFFF /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v Size /t REG_DWORD /d 3 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v EnableOplocks /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v IRPStackSize /t REG_DWORD /d 32 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v SharingViolationDelay /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v SharingViolationRetries /t REG_DWORD /d 0 /f >nul

:: Prefer IPv4
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 32 /f >nul

echo [OK] Network optimized.

:: ──────────────────────────────────────────────────────────────────────
::  LATENCY OPTIMIZATIONS
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Applying latency optimizations...

bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set useplatformtick yes >nul 2>&1
bcdedit /set tscsyncpolicy enhanced >nul 2>&1
bcdedit /set x2apicpolicy enable >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NoLazyMode /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v AlwaysOn /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Low Latency" /v "Latency Sensitive" /t REG_SZ /d True /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Latency Sensitive" /t REG_SZ /d True /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Latency Sensitive" /t REG_SZ /d True /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "Latency Sensitive" /t REG_SZ /d True /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d True /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Window Manager" /v "Latency Sensitive" /t REG_SZ /d True /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v Latency /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v HighPerformance /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v ExitLatency /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v ExitLatencyCheckEnabled /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v LowLatency /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v HighestPerformance /t REG_DWORD /d 1 /f >nul

echo [OK] Latency optimizations applied.

:: ──────────────────────────────────────────────────────────────────────
::  CPU THREAD & PRIORITY TWEAKS
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Applying CPU thread and priority tweaks...

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v IoPriority /t REG_DWORD /d 3 /f >nul

reg add "HKLM\SYSTEM\CurrentControlSet\Services\usbxhci\Parameters" /v ThreadPriority /t REG_DWORD /d 31 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBHUB3\Parameters" /v ThreadPriority /t REG_DWORD /d 31 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v ThreadPriority /t REG_DWORD /d 31 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters" /v ThreadPriority /t REG_DWORD /d 31 /f >nul

reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v IRQThreadPriority /t REG_DWORD /d 1 /f >nul

echo [OK] CPU thread and priority tweaks applied.

:: ──────────────────────────────────────────────────────────────────────
::  VISUAL EFFECTS & UI OPTIMIZATIONS
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Optimizing visual effects and UI...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul
:: DXGKrnl tweaks removed due to permission issues
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableBlurBehind" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "ColorPrevalence" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ExtendedUIHoverTime" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenOverlayEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableAutomaticRestartSignOn /t REG_DWORD /d 1 /f >nul

:: Taskbar End Task
powershell -NoProfile -ExecutionPolicy Bypass -Command "$path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings'; $name = 'TaskbarEndTask'; $value = 1; if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }; New-ItemProperty -Path $path -Name $name -PropertyType DWord -Value $value -Force | Out-Null" >nul 2>&1

echo [OK] Visual effects and UI optimized.

:: ──────────────────────────────────────────────────────────────────────
::  EXPLORER OPTIMIZATIONS
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Optimizing Windows Explorer...

reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete" /v "AutoSuggest" /t REG_SZ /d "no" /f >nul
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d 0 /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "DirectoryCacheLifetime" /t REG_DWORD /d 0 /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "FileNotFoundCacheLifetime" /t REG_DWORD /d 0 /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "DormantFileLimit" /t REG_DWORD /d 0 /f >nul
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f >nul

echo [OK] Explorer optimized.

:: ──────────────────────────────────────────────────────────────────────
::  KEYBOARD & MOUSE OPTIMIZATIONS
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Optimizing keyboard and mouse...

reg add "HKU\.DEFAULT\Control Panel\Mouse" /v ActiveWindowTracking /t REG_DWORD /d 0 /f >nul
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetMouseDragOutWidth /t REG_SZ /d 20 /f >nul
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetMouseSideMoveWidth /t REG_SZ /d 50 /f >nul
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetMouseWidth /t REG_SZ /d 1 /f >nul
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetPenDragOutWidth /t REG_SZ /d 30 /f >nul
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetPenSideMoveWidth /t REG_SZ /d 50 /f >nul
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetPenWidth /t REG_SZ /d 30 /f >nul
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DoubleClickHeight /t REG_SZ /d 4 /f >nul
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DoubleClickSpeed /t REG_SZ /d 500 /f >nul
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DoubleClickWidth /t REG_SZ /d 4 /f >nul
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v MouseSensitivity /t REG_SZ /d 10 /f >nul
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f >nul
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f >nul
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f >nul
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v SnapToDefaultButton /t REG_SZ /d 0 /f >nul
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v SwapMouseButtons /t REG_SZ /d 0 /f >nul

reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v KeyboardDataQueueSize /t REG_DWORD /d 32 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v MouseDataQueueSize /t REG_DWORD /d 32 /f >nul

echo [OK] Keyboard and mouse optimized.

:: ──────────────────────────────────────────────────────────────────────
::  SHUTDOWN & SYSTEM OPTIMIZATIONS
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Optimizing shutdown and system settings...

reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "2000" /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LowMemoryUsageTimeout" /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 5000 /f >nul
reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 4000 /f >nul
reg add "HKCU\Control Panel\Desktop" /v AutoEndTasks /t REG_SZ /d 1 /f >nul
reg add "HKCU\Control Panel\Desktop" /v LowLevelHooksTimeout /t REG_DWORD /d 0x1000 /f >nul
reg add "HKCU\Control Panel\Desktop" /v WaitToKillServiceTimeout /t REG_DWORD /d 0x2000 /f >nul

:: Disable Fast Startup
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f >nul

echo [OK] Shutdown and system optimized.

:: ──────────────────────────────────────────────────────────────────────
::  MULTIMEDIA SYSTEM PROFILE TWEAKS
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Optimizing multimedia system profile...

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Affinity" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Background Only" /t REG_SZ /d "True" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Clock Rate" /t REG_DWORD /d 10000 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Priority" /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "Medium" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "SFIO Priority" /t REG_SZ /d "Normal" /f >nul

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Capture" /v "Affinity" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Capture" /v "Background Only" /t REG_SZ /d "True" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Capture" /v "Clock Rate" /t REG_DWORD /d 10000 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Capture" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Capture" /v "Priority" /t REG_DWORD /d 5 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Capture" /v "Scheduling Category" /t REG_SZ /d "Medium" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Capture" /v "SFIO Priority" /t REG_SZ /d "Normal" /f >nul

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Affinity" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Background Only" /t REG_SZ /d "True" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "BackgroundPriority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Clock Rate" /t REG_DWORD /d 10000 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "SFIO Priority" /t REG_SZ /d "Normal" /f >nul

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Distribution" /v "Affinity" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Distribution" /v "Background Only" /t REG_SZ /d "True" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Distribution" /v "Clock Rate" /t REG_DWORD /d 10000 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Distribution" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Distribution" /v "Priority" /t REG_DWORD /d 4 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Distribution" /v "Scheduling Category" /t REG_SZ /d "Medium" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Distribution" /v "SFIO Priority" /t REG_SZ /d "Normal" /f >nul

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t REG_DWORD /d 10000 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Playback" /v "Affinity" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Playback" /v "Background Only" /t REG_SZ /d "False" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Playback" /v "BackgroundPriority" /t REG_DWORD /d 4 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Playback" /v "Clock Rate" /t REG_DWORD /d 10000 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Playback" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Playback" /v "Priority" /t REG_DWORD /d 3 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Playback" /v "Scheduling Category" /t REG_SZ /d "Medium" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Playback" /v "SFIO Priority" /t REG_SZ /d "Normal" /f >nul

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "Affinity" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "Background Only" /t REG_SZ /d "False" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "Clock Rate" /t REG_DWORD /d 10000 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "Priority" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "SFIO Priority" /t REG_SZ /d "Normal" /f >nul

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Window Manager" /v "Affinity" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Window Manager" /v "Background Only" /t REG_SZ /d "True" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Window Manager" /v "Clock Rate" /t REG_DWORD /d 10000 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Window Manager" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Window Manager" /v "Priority" /t REG_DWORD /d 5 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Window Manager" /v "Scheduling Category" /t REG_SZ /d "Medium" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Window Manager" /v "SFIO Priority" /t REG_SZ /d "Normal" /f >nul

echo [OK] Multimedia system profile optimized.

:: ──────────────────────────────────────────────────────────────────────
::  SYSTEM TIMER & ADDITIONAL TWEAKS
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Applying additional system tweaks...

:: Request high resolution system timer globally
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d 1 /f >nul

:: Disable USB selective suspend
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v "DisableSelectiveSuspend" /t REG_DWORD /d 1 /f >nul

:: Set NVIDIA shader cache to unlimited
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "DxgDdiBlend" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "Perf Level Ovr" /t REG_DWORD /d 0x00000003 /f >nul

:: Disable Meltdown/Spectre mitigations for performance
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d 3 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d 3 /f >nul

:: Optimize Windows scheduler for physical cores
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ThreadDpcEnable" /t REG_DWORD /d 0 /f >nul

:: Disable unnecessary maintenance tasks
schtasks /Change /TN "Microsoft\Windows\Defrag\ScheduledDefrag" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Registry\RegIdleBackup" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Automatic App Update" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable >nul 2>&1

:: Disable Windows Update Delivery Optimization
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d 0 /f >nul
sc config "DoSvc" start= disabled >nul 2>&1
sc stop "DoSvc" >nul 2>&1

:: Process idle tasks
Rundll32.exe advapi32.dll,ProcessIdleTasks >nul 2>&1

:: Disable delete notification (TRIM enabled)
fsutil behavior set disabledeletenotify 0 >nul 2>&1

echo [OK] Additional system tweaks applied.

:: ──────────────────────────────────────────────────────────────────────
::  CPU POWER SETTINGS (ADDITIONAL)
:: ──────────────────────────────────────────────────────────────────────
echo %CUSTOM%[*]%WHITE% Applying additional CPU power settings...

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\943c8cb6-6f93-4227-ad87-e9a3feec08d1" /v "Attributes" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e" /v "ACSettingIndex" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e" /v "DCSettingIndex" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009\DefaultPowerSchemeValues\8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" /v "ACSettingIndex" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e" /v "ACSettingIndex" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e" /v "DCSettingIndex" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb\DefaultPowerSchemeValues\8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" /v "ACSettingIndex" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d 0 /f >nul

echo [OK] Additional CPU power settings applied.

:: ──────────────────────────────────────────────────────────────────────
::  COMPLETE
:: ──────────────────────────────────────────────────────────────────────
echo.
echo  ============================================================
echo              All optimizations applied successfully!
echo  ============================================================
echo.
echo Changes applied:
echo   - Privacy & Security tweaks
echo   - Performance optimizations (CPU, GPU, Memory, Network)
echo   - Telemetry and data collection disabled
echo   - Bloatware removal
echo   - UI and visual effects optimized
echo   - Latency and input optimizations
echo.
echo WARNING: Some changes require a restart to take effect.
echo.
set /p reboot="Restart now? (Y/N): "
if /i "%reboot%"=="Y" shutdown /r /t 10 /c "Restarting to apply Windows optimizations..."

pause
exit /b 0

:SetColors
set "BLACK=%ESC%[30m"
set "RED=%ESC%[31m"
set "GREEN=%ESC%[32m"
set "YELLOW=%ESC%[33m"
set "BLUE=%ESC%[34m"
set "MAGENTA=%ESC%[35m"
set "CYAN=%ESC%[36m"
set "WHITE=%ESC%[37m"
set "BRIGHT_BLACK=%ESC%[90m"
set "BRIGHT_RED=%ESC%[91m"
set "BRIGHT_GREEN=%ESC%[92m"
set "BRIGHT_YELLOW=%ESC%[93m"
set "BRIGHT_BLUE=%ESC%[94m"
set "BRIGHT_MAGENTA=%ESC%[95m"
set "BRIGHT_CYAN=%ESC%[96m"
set "BRIGHT_WHITE=%ESC%[97m"
set "CUSTOM=%ESC%[38;2;85;24;111m"
goto :eof
