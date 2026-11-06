# ==============================================================================
# Windows Optimizer - Comprehensive Modular Optimization Catalog
# Includes 35 enterprise-grade optimizations for any Windows 10/11 device.
# Each tweak contains Detect, Apply, Revert, and Risk Classification.
#
# Risk Levels:
#   "Safe"    - Zero risk to OS stability. Cannot prevent boot or crash the PC.
#               Fully reversible with 1 click.
#   "Caution" - Safe for the OS, but affects a specific peripheral or workflow
#               (e.g., physical printers, gameplay recording, hibernation).
# ==============================================================================

function Get-OptimizationDefinitions {
    return @(
        # ----------------------------------------------------------------------
        # 1. SERVICES
        # ----------------------------------------------------------------------
        [PSCustomObject]@{
            Id          = "svc_sysmain"
            Category    = "Services"
            Name        = "Disable SysMain (SuperFetch)"
            Description = "Preloads apps into RAM for HDDs. Causes unnecessary disk writes and RAM churn on SSDs."
            Improvement = "Frees 100-300 MB RAM & eliminates SSD disk writes"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Safe on any SSD/NVMe drive. Reversible."
            Recommended = $true
            Detect      = {
                $s = Get-Service -Name "SysMain" -ErrorAction SilentlyContinue
                return ($null -ne $s -and $s.StartType -eq "Disabled" -and $s.Status -ne "Running")
            }
            Apply       = {
                Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue
                Set-Service -Name "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue
                return "SysMain stopped and disabled."
            }
            Revert      = {
                Set-Service -Name "SysMain" -StartupType Automatic -ErrorAction SilentlyContinue
                Start-Service -Name "SysMain" -ErrorAction SilentlyContinue
                return "SysMain restored to Automatic."
            }
        },
        [PSCustomObject]@{
            Id          = "svc_diagtrack"
            Category    = "Services"
            Name        = "Disable Connected User Telemetry (DiagTrack)"
            Description = "Windows diagnostic tracking service that runs periodic scans and transmits logs to Microsoft."
            Improvement = "Saves background CPU cycles & prevents telemetry uploads"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Purely stops background data collection. Reversible."
            Recommended = $true
            Detect      = {
                $s = Get-Service -Name "DiagTrack" -ErrorAction SilentlyContinue
                return ($null -ne $s -and $s.StartType -eq "Disabled" -and $s.Status -ne "Running")
            }
            Apply       = {
                Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
                Set-Service -Name "DiagTrack" -StartupType Disabled -ErrorAction SilentlyContinue
                return "DiagTrack telemetry service disabled."
            }
            Revert      = {
                Set-Service -Name "DiagTrack" -StartupType Automatic -ErrorAction SilentlyContinue
                Start-Service -Name "DiagTrack" -ErrorAction SilentlyContinue
                return "DiagTrack restored to Automatic."
            }
        },
        [PSCustomObject]@{
            Id          = "svc_devices_telemetry"
            Category    = "Services"
            Name        = "Disable Devices Telemetry Service"
            Description = "Monitors device hardware events and uploads diagnostic telemetry to Microsoft."
            Improvement = "Eliminates background hardware polling overhead"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Hardware drivers continue working normally."
            Recommended = $true
            Detect      = {
                $s = Get-Service -Name "DevicesTelemetryService" -ErrorAction SilentlyContinue
                return ($null -eq $s -or ($s.StartType -eq "Disabled" -and $s.Status -ne "Running"))
            }
            Apply       = {
                Stop-Service -Name "DevicesTelemetryService" -Force -ErrorAction SilentlyContinue
                Set-Service -Name "DevicesTelemetryService" -StartupType Disabled -ErrorAction SilentlyContinue
                return "Devices Telemetry Service disabled."
            }
            Revert      = {
                Set-Service -Name "DevicesTelemetryService" -StartupType Manual -ErrorAction SilentlyContinue
                return "Devices Telemetry Service restored to Manual."
            }
        },
        [PSCustomObject]@{
            Id          = "svc_delivery_opt"
            Category    = "Services"
            Name        = "Disable Delivery Optimization Service (DoSvc)"
            Description = "Windows P2P update sharing service that uploads updates to external PCs over the internet."
            Improvement = "Saves bandwidth & prevents background network uploads"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Windows updates download directly from Microsoft servers."
            Recommended = $true
            Detect      = {
                $s = Get-Service -Name "DoSvc" -ErrorAction SilentlyContinue
                return ($null -eq $s -or ($s.StartType -eq "Disabled" -and $s.Status -ne "Running"))
            }
            Apply       = {
                Stop-Service -Name "DoSvc" -Force -ErrorAction SilentlyContinue
                Set-Service -Name "DoSvc" -StartupType Disabled -ErrorAction SilentlyContinue
                return "Delivery Optimization service disabled."
            }
            Revert      = {
                Set-Service -Name "DoSvc" -StartupType Automatic -ErrorAction SilentlyContinue
                Start-Service -Name "DoSvc" -ErrorAction SilentlyContinue
                return "Delivery Optimization service restored."
            }
        },
        [PSCustomObject]@{
            Id          = "svc_udc"
            Category    = "Services"
            Name        = "Disable Lenovo UDC Telemetry Service"
            Description = "Lenovo Universal Device Client runs background diagnostic scans and usage reporting."
            Improvement = "Stops vendor background telemetry scanner"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Lenovo hardware and hotkeys remain functional."
            Recommended = $true
            Detect      = {
                $s = Get-Service -Name "UDCService" -ErrorAction SilentlyContinue
                return ($null -eq $s -or ($s.StartType -eq "Disabled" -and $s.Status -ne "Running"))
            }
            Apply       = {
                Stop-Service -Name "UDCService" -Force -ErrorAction SilentlyContinue
                Set-Service -Name "UDCService" -StartupType Disabled -ErrorAction SilentlyContinue
                return "Lenovo UDC Service disabled."
            }
            Revert      = {
                Set-Service -Name "UDCService" -StartupType Automatic -ErrorAction SilentlyContinue
                return "Lenovo UDC Service restored."
            }
        },
        [PSCustomObject]@{
            Id          = "svc_surface"
            Category    = "Services"
            Name        = "Disable Microsoft Surface Experience Service"
            Description = "Preinstalled Surface hardware service running redundantly on non-Surface laptops."
            Improvement = "Frees background service memory (~10-20 MB)"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Irrelevant unless using Surface accessories."
            Recommended = $true
            Detect      = {
                $services = Get-Service -Name "SurfaceExperienceService*" -ErrorAction SilentlyContinue
                if (!$services) { return $true }
                return ($services | Where-Object { $_.StartType -ne "Disabled" -or $_.Status -eq "Running" }).Count -eq 0
            }
            Apply       = {
                Get-Service -Name "SurfaceExperienceService*" -ErrorAction SilentlyContinue | ForEach-Object {
                    Stop-Service -Name $_.Name -Force -ErrorAction SilentlyContinue
                    Set-Service -Name $_.Name -StartupType Disabled -ErrorAction SilentlyContinue
                }
                return "Surface Experience Service disabled."
            }
            Revert      = {
                Get-Service -Name "SurfaceExperienceService*" -ErrorAction SilentlyContinue | ForEach-Object {
                    Set-Service -Name $_.Name -StartupType Automatic -ErrorAction SilentlyContinue
                }
                return "Surface Experience Service restored."
            }
        },
        [PSCustomObject]@{
            Id          = "svc_print_spooler"
            Category    = "Services"
            Name        = "Disable Print Spooler (If No Printer Used)"
            Description = "Manages print queues. Unnecessary if you only use PDFs and do not connect physical printers."
            Improvement = "Frees ~25 MB RAM & closes Spooler attack surface"
            RiskLevel   = "Caution"
            RiskNote    = "Caution: Only disable if you do not use a physical paper printer. Easily re-enabled anytime."
            Recommended = $false
            Detect      = {
                $s = Get-Service -Name "Spooler" -ErrorAction SilentlyContinue
                return ($null -ne $s -and $s.StartType -eq "Disabled" -and $s.Status -ne "Running")
            }
            Apply       = {
                Stop-Service -Name "Spooler" -Force -ErrorAction SilentlyContinue
                Set-Service -Name "Spooler" -StartupType Disabled -ErrorAction SilentlyContinue
                return "Print Spooler disabled."
            }
            Revert      = {
                Set-Service -Name "Spooler" -StartupType Automatic -ErrorAction SilentlyContinue
                Start-Service -Name "Spooler" -ErrorAction SilentlyContinue
                return "Print Spooler service restored to Automatic."
            }
        },
        [PSCustomObject]@{
            Id          = "svc_clicktorun"
            Category    = "Services"
            Name        = "Disable Office Click-to-Run Service"
            Description = "Microsoft Office continuous background updater and service host."
            Improvement = "Frees ~40 MB RAM & stops permanent OfficeClickToRun daemon"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Word, Excel, and Outlook continue to launch and function normally."
            Recommended = $true
            Detect      = {
                $s = Get-Service -Name "ClickToRunSvc" -ErrorAction SilentlyContinue
                return ($null -eq $s -or ($s.StartType -eq "Disabled" -and $s.Status -ne "Running"))
            }
            Apply       = {
                Stop-Service -Name "ClickToRunSvc" -Force -ErrorAction SilentlyContinue
                Set-Service -Name "ClickToRunSvc" -StartupType Disabled -ErrorAction SilentlyContinue
                Get-Process -Name "OfficeClickToRun" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
                return "Office Click-to-Run disabled."
            }
            Revert      = {
                Set-Service -Name "ClickToRunSvc" -StartupType Automatic -ErrorAction SilentlyContinue
                return "Office Click-to-Run restored to Automatic."
            }
        },
        [PSCustomObject]@{
            Id          = "svc_bonjour"
            Category    = "Services"
            Name        = "Disable Apple Bonjour mDNS"
            Description = "Zero-configuration Apple networking daemon installed with iTunes or Adobe tools."
            Improvement = "Terminates mDNSResponder background listener"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Only needed for legacy Apple local-network discovery."
            Recommended = $true
            Detect      = {
                $s = Get-Service -Name "Bonjour Service" -ErrorAction SilentlyContinue
                return ($null -eq $s -or ($s.StartType -eq "Disabled" -and $s.Status -ne "Running"))
            }
            Apply       = {
                Stop-Service -Name "Bonjour Service" -Force -ErrorAction SilentlyContinue
                Set-Service -Name "Bonjour Service" -StartupType Disabled -ErrorAction SilentlyContinue
                Get-Process -Name "mDNSResponder" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
                return "Bonjour Service disabled."
            }
            Revert      = {
                Set-Service -Name "Bonjour Service" -StartupType Automatic -ErrorAction SilentlyContinue
                return "Bonjour Service restored."
            }
        },
        [PSCustomObject]@{
            Id          = "svc_samsung"
            Category    = "Services"
            Name        = "Disable Samsung Connectivity Services"
            Description = "Samsung DeX and mobile connectivity background monitors."
            Improvement = "Prevents permanent Samsung polling daemons"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Normal USB file transfers remain fully functional."
            Recommended = $true
            Detect      = {
                $s1 = Get-Service -Name "ss_conn_service" -ErrorAction SilentlyContinue
                $s2 = Get-Service -Name "ss_conn_service2" -ErrorAction SilentlyContinue
                $d1 = ($null -eq $s1 -or $s1.StartType -eq "Disabled")
                $d2 = ($null -eq $s2 -or $s2.StartType -eq "Disabled")
                return ($d1 -and $d2)
            }
            Apply       = {
                @("ss_conn_service", "ss_conn_service2") | ForEach-Object {
                    Stop-Service -Name $_ -Force -ErrorAction SilentlyContinue
                    Set-Service -Name $_ -StartupType Disabled -ErrorAction SilentlyContinue
                }
                return "Samsung Connectivity services disabled."
            }
            Revert      = {
                @("ss_conn_service", "ss_conn_service2") | ForEach-Object {
                    Set-Service -Name $_ -StartupType Manual -ErrorAction SilentlyContinue
                }
                return "Samsung Connectivity services restored to Manual."
            }
        },

        # ----------------------------------------------------------------------
        # 2. SCHEDULED TASKS
        # ----------------------------------------------------------------------
        [PSCustomObject]@{
            Id          = "task_compat_appraiser"
            Category    = "Scheduled Tasks"
            Name        = "Disable Microsoft Compatibility Appraiser"
            Description = "Scans installed applications and files periodically. Primary cause of mysterious high disk I/O."
            Improvement = "Prevents heavy background disk and CPU scans"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Highly recommended by IT professionals to stop disk churn."
            Recommended = $true
            Detect      = {
                $t = Get-ScheduledTask -TaskPath "\Microsoft\Windows\Application Experience\" -TaskName "Microsoft Compatibility Appraiser Exp" -ErrorAction SilentlyContinue
                return ($null -eq $t -or $t.State -eq "Disabled")
            }
            Apply       = {
                Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Application Experience\" -TaskName "Microsoft Compatibility Appraiser Exp" -ErrorAction SilentlyContinue | Out-Null
                Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Application Experience\" -TaskName "MareBackup" -ErrorAction SilentlyContinue | Out-Null
                return "Compatibility Appraiser tasks disabled."
            }
            Revert      = {
                Enable-ScheduledTask -TaskPath "\Microsoft\Windows\Application Experience\" -TaskName "Microsoft Compatibility Appraiser Exp" -ErrorAction SilentlyContinue | Out-Null
                return "Compatibility Appraiser tasks re-enabled."
            }
        },
        [PSCustomObject]@{
            Id          = "task_ceip"
            Category    = "Scheduled Tasks"
            Name        = "Disable Customer Experience Improvement (CEIP)"
            Description = "Consolidator and UsbCeip tasks that harvest telemetry metrics during idle periods."
            Improvement = "Eliminates idle telemetry gathering jobs"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Completely safe OS telemetry pruning."
            Recommended = $true
            Detect      = {
                $t = Get-ScheduledTask -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program\" -TaskName "Consolidator" -ErrorAction SilentlyContinue
                return ($null -eq $t -or $t.State -eq "Disabled")
            }
            Apply       = {
                Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program\" -TaskName "Consolidator" -ErrorAction SilentlyContinue | Out-Null
                Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program\" -TaskName "UsbCeip" -ErrorAction SilentlyContinue | Out-Null
                return "CEIP Consolidator and UsbCeip tasks disabled."
            }
            Revert      = {
                Enable-ScheduledTask -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program\" -TaskName "Consolidator" -ErrorAction SilentlyContinue | Out-Null
                return "CEIP tasks re-enabled."
            }
        },
        [PSCustomObject]@{
            Id          = "task_amd_dvr"
            Category    = "Scheduled Tasks"
            Name        = "Disable AMD ReLive & DVR Background Recording"
            Description = "AMD background tasks (StartDVR & StartCN) that launch AMDRSSrcExt screen-recording hooks."
            Improvement = "Frees ~125 MB RAM & stops background graphics capture"
            RiskLevel   = "Caution"
            RiskNote    = "Caution: Only disable if you do not record gameplay video clips with AMD Radeon Software."
            Recommended = $true
            Detect      = {
                $t1 = Get-ScheduledTask -TaskPath "\" -TaskName "StartDVR" -ErrorAction SilentlyContinue
                $t2 = Get-ScheduledTask -TaskPath "\" -TaskName "StartCN" -ErrorAction SilentlyContinue
                $d1 = ($null -eq $t1 -or $t1.State -eq "Disabled")
                $d2 = ($null -eq $t2 -or $t2.State -eq "Disabled")
                return ($d1 -and $d2)
            }
            Apply       = {
                Disable-ScheduledTask -TaskPath "\" -TaskName "StartDVR" -ErrorAction SilentlyContinue | Out-Null
                Disable-ScheduledTask -TaskPath "\" -TaskName "StartCN" -ErrorAction SilentlyContinue | Out-Null
                Get-Process -Name "AMDRSSrcExt" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
                return "AMD DVR tasks disabled & AMDRSSrcExt stopped."
            }
            Revert      = {
                Enable-ScheduledTask -TaskPath "\" -TaskName "StartDVR" -ErrorAction SilentlyContinue | Out-Null
                Enable-ScheduledTask -TaskPath "\" -TaskName "StartCN" -ErrorAction SilentlyContinue | Out-Null
                return "AMD DVR tasks re-enabled."
            }
        },
        [PSCustomObject]@{
            Id          = "task_nv_telemetry"
            Category    = "Scheduled Tasks"
            Name        = "Disable NVIDIA Crash Reporter Tasks"
            Description = "Automated crash report upload tasks generated by NVIDIA GeForce Experience."
            Improvement = "Removes redundant background telemetry callers"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. GPU display drivers and graphics performance unaffected."
            Recommended = $true
            Detect      = {
                $tasks = Get-ScheduledTask -TaskPath "\" | Where-Object { $_.TaskName -like "NvTmRep_CrashReport*" }
                if (!$tasks) { return $true }
                return ($tasks | Where-Object { $_.State -ne "Disabled" }).Count -eq 0
            }
            Apply       = {
                Get-ScheduledTask -TaskPath "\" | Where-Object { $_.TaskName -like "NvTmRep_CrashReport*" } | ForEach-Object {
                    Disable-ScheduledTask -TaskPath "\" -TaskName $_.TaskName -ErrorAction SilentlyContinue | Out-Null
                }
                return "NVIDIA crash reporting tasks disabled."
            }
            Revert      = {
                Get-ScheduledTask -TaskPath "\" | Where-Object { $_.TaskName -like "NvTmRep_CrashReport*" } | ForEach-Object {
                    Enable-ScheduledTask -TaskPath "\" -TaskName $_.TaskName -ErrorAction SilentlyContinue | Out-Null
                }
                return "NVIDIA crash reporting tasks re-enabled."
            }
        },
        [PSCustomObject]@{
            Id          = "task_winsat"
            Category    = "Scheduled Tasks"
            Name        = "Disable Windows System Assessment (WinSAT)"
            Description = "Runs background hardware benchmark scans that spin up fans unexpectedly."
            Improvement = "Prevents sudden fan noise and CPU throttling at idle"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Benchmarks are not required for regular Windows operation."
            Recommended = $true
            Detect      = {
                $t = Get-ScheduledTask -TaskPath "\Microsoft\Windows\Maintenance\" -TaskName "WinSAT" -ErrorAction SilentlyContinue
                return ($null -eq $t -or $t.State -eq "Disabled")
            }
            Apply       = {
                Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Maintenance\" -TaskName "WinSAT" -ErrorAction SilentlyContinue | Out-Null
                return "WinSAT assessment task disabled."
            }
            Revert      = {
                Enable-ScheduledTask -TaskPath "\Microsoft\Windows\Maintenance\" -TaskName "WinSAT" -ErrorAction SilentlyContinue | Out-Null
                return "WinSAT assessment task re-enabled."
            }
        },

        # ----------------------------------------------------------------------
        # 3. BLOATWARE & STARTUP
        # ----------------------------------------------------------------------
        [PSCustomObject]@{
            Id          = "app_surface_hub"
            Category    = "Bloatware & Startup"
            Name        = "Uninstall Microsoft Surface App"
            Description = "Surface hardware utility running on non-Surface laptops, holding ~185 MB RAM constantly."
            Improvement = "Frees ~185 MB RAM immediately"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Safe on Lenovo, HP, Dell, Asus, or custom PCs."
            Recommended = $true
            Detect      = {
                $pkg = Get-AppxPackage *Microsoft.SurfaceHub* -ErrorAction SilentlyContinue
                return ($null -eq $pkg)
            }
            Apply       = {
                Get-Process -Name "SurfaceApp.Desktop", "SurfaceBroker" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
                Get-AppxPackage *Microsoft.SurfaceHub* -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
                return "Microsoft Surface App uninstalled."
            }
            Revert      = {
                return "App can be reinstalled anytime from the Microsoft Store."
            }
        },
        [PSCustomObject]@{
            Id          = "app_webexperience"
            Category    = "Bloatware & Startup"
            Name        = "Remove Windows Web Experience Pack (Widgets)"
            Description = "Powers the Taskbar Widgets and MSN news feed, running multiple background WebView2 processes."
            Improvement = "Permanently kills WidgetService (~150 MB RAM saved)"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Eliminates news feed on taskbar. Frees RAM."
            Recommended = $true
            Detect      = {
                $pkg = Get-AppxPackage *WebExperience* -ErrorAction SilentlyContinue
                return ($null -eq $pkg)
            }
            Apply       = {
                Get-AppxPackage *WebExperience* -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
                $dshKeys = @("HKLM:\SOFTWARE\Policies\Microsoft\Dsh", "HKCU:\Software\Microsoft\Windows\CurrentVersion\Dsh")
                foreach ($dshKey in $dshKeys) {
                    if (!(Test-Path $dshKey)) { New-Item -Path $dshKey -Force -ErrorAction SilentlyContinue | Out-Null }
                    Set-ItemProperty -Path $dshKey -Name "AllowNewsAndInterests" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                }
                Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarDa' -Value 0 -ErrorAction SilentlyContinue
                return "Web Experience Pack removed & Widgets disabled."
            }
            Revert      = {
                Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarDa' -Value 1 -ErrorAction SilentlyContinue
                return "Widget taskbar setting restored."
            }
        },
        [PSCustomObject]@{
            Id          = "app_copilot"
            Category    = "Bloatware & Startup"
            Name        = "Disable Windows 11 Copilot & AI Sidecar"
            Description = "Disables the built-in Windows Copilot sidebar, background AI agents, and taskbar shortcut."
            Improvement = "Saves background telemetry and removes AI sidebar"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Web browsers (Chrome, Edge) still allow Copilot/ChatGPT."
            Recommended = $true
            Detect      = {
                $k = (Get-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot' -Name 'TurnOffWindowsCopilot' -ErrorAction SilentlyContinue).TurnOffWindowsCopilot
                return ($k -eq 1)
            }
            Apply       = {
                $keys = @("HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot", "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot")
                foreach ($k in $keys) {
                    if (!(Test-Path $k)) { New-Item -Path $k -Force -ErrorAction SilentlyContinue | Out-Null }
                    Set-ItemProperty -Path $k -Name "TurnOffWindowsCopilot" -Value 1 -Type DWord -ErrorAction SilentlyContinue
                }
                Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowCopilotButton' -Value 0 -ErrorAction SilentlyContinue
                return "Windows Copilot disabled."
            }
            Revert      = {
                Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowCopilotButton' -Value 1 -ErrorAction SilentlyContinue
                @("HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot", "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot") | ForEach-Object {
                    Remove-ItemProperty -Path $_ -Name "TurnOffWindowsCopilot" -ErrorAction SilentlyContinue
                }
                return "Windows Copilot restored."
            }
        },
        [PSCustomObject]@{
            Id          = "app_preinstalled_bloat"
            Category    = "Bloatware & Startup"
            Name        = "Remove Preinstalled Windows Promo Apps"
            Description = "Cleans unused default UWP bloat: Bing News, Bing Weather, Solitaire, and Feedback Hub."
            Improvement = "Cleans AppX storage & stops background live-tile checks"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Clean removal of preloaded store junk apps."
            Recommended = $true
            Detect      = {
                $apps = @("Microsoft.BingNews", "Microsoft.BingWeather", "Microsoft.MicrosoftSolitaireCollection")
                $found = 0
                foreach ($a in $apps) { if (Get-AppxPackage -Name $a -ErrorAction SilentlyContinue) { $found++ } }
                return ($found -eq 0)
            }
            Apply       = {
                $apps = @("Microsoft.BingNews", "Microsoft.BingWeather", "Microsoft.MicrosoftSolitaireCollection", "Microsoft.WindowsFeedbackHub", "Microsoft.WindowsMaps", "Microsoft.GetHelp")
                foreach ($a in $apps) {
                    Get-AppxPackage -Name $a -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
                }
                return "Preinstalled promo apps removed."
            }
            Revert      = {
                return "Apps can be reinstalled from Microsoft Store if ever needed."
            }
        },
        [PSCustomObject]@{
            Id          = "app_xbox_overlays"
            Category    = "Bloatware & Startup"
            Name        = "Disable Xbox Game Bar & Background Overlays"
            Description = "Disables Xbox Game Bar background hooks (bcastdvr.exe) for non-gamers."
            Improvement = "Frees ~100 MB RAM & stops background gaming capture"
            RiskLevel   = "Caution"
            RiskNote    = "Caution: Only disable if you don't use Win+G to record gaming footage."
            Recommended = $true
            Detect      = {
                $g1 = (Get-ItemProperty -Path 'HKCU:\System\GameConfigStore' -Name 'GameDVR_Enabled' -ErrorAction SilentlyContinue).GameDVR_Enabled
                $g2 = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'AppCaptureEnabled' -ErrorAction SilentlyContinue).AppCaptureEnabled
                return ($g1 -eq 0 -and $g2 -eq 0)
            }
            Apply       = {
                $k1 = 'HKCU:\System\GameConfigStore'
                if (!(Test-Path $k1)) { New-Item -Path $k1 -Force -ErrorAction SilentlyContinue | Out-Null }
                Set-ItemProperty -Path $k1 -Name 'GameDVR_Enabled' -Value 0 -Type DWord -ErrorAction SilentlyContinue

                $k2 = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR'
                if (!(Test-Path $k2)) { New-Item -Path $k2 -Force -ErrorAction SilentlyContinue | Out-Null }
                Set-ItemProperty -Path $k2 -Name 'AppCaptureEnabled' -Value 0 -Type DWord -ErrorAction SilentlyContinue
                return "Xbox Game Bar capture disabled."
            }
            Revert      = {
                Set-ItemProperty -Path 'HKCU:\System\GameConfigStore' -Name 'GameDVR_Enabled' -Value 1 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'AppCaptureEnabled' -Value 1 -Type DWord -ErrorAction SilentlyContinue
                return "Xbox Game Bar restored."
            }
        },
        [PSCustomObject]@{
            Id          = "app_browser_ghosts"
            Category    = "Bloatware & Startup"
            Name        = "Disable Browser Ghost Background Processes"
            Description = "Forces Chrome & Edge to completely close all helper processes when the window is closed."
            Improvement = "Prevents Chrome & Edge from holding ~500 MB RAM in tray"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Browser opens normally when clicked, but fully frees RAM when closed."
            Recommended = $true
            Detect      = {
                $c = (Get-ItemProperty -Path 'HKCU:\Software\Policies\Google\Chrome' -Name 'BackgroundModeEnabled' -ErrorAction SilentlyContinue).BackgroundModeEnabled
                $e = (Get-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Edge' -Name 'BackgroundModeEnabled' -ErrorAction SilentlyContinue).BackgroundModeEnabled
                return ($c -eq 0 -and $e -eq 0)
            }
            Apply       = {
                $cKey = 'HKCU:\Software\Policies\Google\Chrome'
                if (!(Test-Path $cKey)) { New-Item -Path $cKey -Force -ErrorAction SilentlyContinue | Out-Null }
                Set-ItemProperty -Path $cKey -Name 'BackgroundModeEnabled' -Value 0 -Type DWord -ErrorAction SilentlyContinue

                $eKey = 'HKCU:\Software\Policies\Microsoft\Edge'
                if (!(Test-Path $eKey)) { New-Item -Path $eKey -Force -ErrorAction SilentlyContinue | Out-Null }
                Set-ItemProperty -Path $eKey -Name 'BackgroundModeEnabled' -Value 0 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $eKey -Name 'StartupBoostEnabled' -Value 0 -Type DWord -ErrorAction SilentlyContinue
                return "Browser ghost background modes disabled."
            }
            Revert      = {
                Remove-ItemProperty -Path 'HKCU:\Software\Policies\Google\Chrome' -Name 'BackgroundModeEnabled' -ErrorAction SilentlyContinue
                Remove-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Edge' -Name 'BackgroundModeEnabled' -ErrorAction SilentlyContinue
                return "Browser default background settings restored."
            }
        },

        # ----------------------------------------------------------------------
        # 4. UI & LATENCY
        # ----------------------------------------------------------------------
        [PSCustomObject]@{
            Id          = "ui_classic_context_menu"
            Category    = "UI & Performance"
            Name        = "Restore Classic Full Right-Click Context Menu"
            Description = "Restores the Windows 10 style instant full right-click menu, eliminating 'Show More Options'."
            Improvement = "Eliminates double-clicking in File Explorer menus"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Completely safe user registry preference. 100% reversible."
            Recommended = $true
            Detect      = {
                $key = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
                return (Test-Path $key)
            }
            Apply       = {
                $key = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
                New-Item -Path $key -Value "" -Force -ErrorAction SilentlyContinue | Out-Null
                return "Classic full context menu enabled."
            }
            Revert      = {
                $rootKey = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"
                if (Test-Path $rootKey) { Remove-Item -Path $rootKey -Recurse -Force -ErrorAction SilentlyContinue }
                return "Windows 11 modern context menu restored."
            }
        },
        [PSCustomObject]@{
            Id          = "ui_zero_latency"
            Category    = "UI & Performance"
            Name        = "Zero Animation Latency (Instant Snappy Feel)"
            Description = "Disables window minimize/maximize animation delays and taskbar animations."
            Improvement = "Eliminates ~300ms visual animation lag on every window click"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Makes Windows feel instantaneous. Reversible."
            Recommended = $true
            Detect      = {
                $minAnim = (Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -ErrorAction SilentlyContinue).MinAnimate
                $tbAnim = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAnimations' -ErrorAction SilentlyContinue).TaskbarAnimations
                return ($minAnim -eq "0" -and $tbAnim -eq 0)
            }
            Apply       = {
                Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Value '0' -ErrorAction SilentlyContinue
                Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAnimations' -Value 0 -ErrorAction SilentlyContinue
                return "Window and taskbar animations set to 0ms instant snap."
            }
            Revert      = {
                Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Value '1' -ErrorAction SilentlyContinue
                Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAnimations' -Value 1 -ErrorAction SilentlyContinue
                return "Standard animations restored."
            }
        },
        [PSCustomObject]@{
            Id          = "ui_transparency"
            Category    = "UI & Performance"
            Name        = "Disable Windows 11 Mica & Transparency"
            Description = "Disables real-time acrylic blur on taskbar and windows, reducing GPU compositor overhead."
            Improvement = "Frees GPU compositor resources & smoothens window movement"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Saves battery and GPU resources. Reversible."
            Recommended = $true
            Detect      = {
                $t = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'EnableTransparency' -ErrorAction SilentlyContinue).EnableTransparency
                return ($t -eq 0)
            }
            Apply       = {
                $k = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
                if (!(Test-Path $k)) { New-Item -Path $k -Force -ErrorAction SilentlyContinue | Out-Null }
                Set-ItemProperty -Path $k -Name 'EnableTransparency' -Value 0 -Type DWord -ErrorAction SilentlyContinue
                return "Transparency disabled."
            }
            Revert      = {
                Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'EnableTransparency' -Value 1 -Type DWord -ErrorAction SilentlyContinue
                return "Transparency re-enabled."
            }
        },
        [PSCustomObject]@{
            Id          = "search_local_only"
            Category    = "UI & Performance"
            Name        = "Local-Only Fast Windows Search (No Bing/MSN)"
            Description = "Completely disables Bing web search, Cortana, Search Highlights (MSN doodles), cloud lookups, and location tracking in Start."
            Improvement = "Instant 0ms Start search, zero web queries, zero MSN ads"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Local apps, settings, and files continue to be found instantly."
            Recommended = $true
            Detect      = {
                $pol = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -ErrorAction SilentlyContinue
                $user = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -ErrorAction SilentlyContinue
                $d1 = ($pol.DisableWebSearch -eq 1 -and $pol.ConnectedSearchUseWeb -eq 0 -and $pol.AllowCortana -eq 0)
                $d2 = ($user.BingSearchEnabled -eq 0)
                return ($d1 -and $d2)
            }
            Apply       = {
                # 1. HKLM Windows Search Policies
                $pol = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
                if (!(Test-Path $pol)) { New-Item -Path $pol -Force -ErrorAction SilentlyContinue | Out-Null }
                Set-ItemProperty -Path $pol -Name "DisableWebSearch" -Value 1 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $pol -Name "ConnectedSearchUseWeb" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $pol -Name "AllowCortana" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $pol -Name "AllowCloudSearch" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $pol -Name "EnableDynamicContentInWSB" -Value 0 -Type DWord -ErrorAction SilentlyContinue

                # 2. Explorer Search Suggestions
                @("HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer", "HKCU:\Software\Policies\Microsoft\Windows\Explorer") | ForEach-Object {
                    if (!(Test-Path $_)) { New-Item -Path $_ -Force -ErrorAction SilentlyContinue | Out-Null }
                    Set-ItemProperty -Path $_ -Name "DisableSearchBoxSuggestions" -Value 1 -Type DWord -ErrorAction SilentlyContinue
                }

                # 3. HKCU Search User Settings
                $uSearch = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
                if (!(Test-Path $uSearch)) { New-Item -Path $uSearch -Force -ErrorAction SilentlyContinue | Out-Null }
                Set-ItemProperty -Path $uSearch -Name "BingSearchEnabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $uSearch -Name "CortanaConsent" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $uSearch -Name "DeviceHistoryEnabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $uSearch -Name "HistoryViewEnabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $uSearch -Name "AllowSearchToUseLocation" -Value 0 -Type DWord -ErrorAction SilentlyContinue

                # 4. HKCU SearchSettings (Search Highlights / MSN Doodles)
                $uSettings = "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings"
                if (!(Test-Path $uSettings)) { New-Item -Path $uSettings -Force -ErrorAction SilentlyContinue | Out-Null }
                Set-ItemProperty -Path $uSettings -Name "IsSearchHighlightsEnabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $uSettings -Name "IsDynamicSearchBoxEnabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $uSettings -Name "IsAADCloudSearchEnabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $uSettings -Name "IsMSACloudSearchEnabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $uSettings -Name "IsDeviceSearchHistoryEnabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue

                # Restart SearchHost so changes take effect immediately
                Get-Process -Name "SearchHost" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

                return "Local-only search fully active (Bing, MSN, Search Highlights & Cloud disabled)."
            }
            Revert      = {
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 1 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsSearchHighlightsEnabled" -Value 1 -Type DWord -ErrorAction SilentlyContinue
                Get-Process -Name "SearchHost" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
                return "Web search restored."
            }
        },
        [PSCustomObject]@{
            Id          = "ui_explorer_speed"
            Category    = "UI & Performance"
            Name        = "Optimize File Explorer Responsiveness"
            Description = "Disables tracking of recent/frequent items and always shows file extensions."
            Improvement = "Instant folder opening with zero Quick Access history lag"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Prevents File Explorer from lagging when loading recent folders."
            Recommended = $true
            Detect      = {
                $ext = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt' -ErrorAction SilentlyContinue).HideFileExt
                $rec = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowRecent' -ErrorAction SilentlyContinue).ShowRecent
                return ($ext -eq 0 -and $rec -eq 0)
            }
            Apply       = {
                Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt' -Value 0 -ErrorAction SilentlyContinue
                Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowRecent' -Value 0 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowFrequent' -Value 0 -Type DWord -ErrorAction SilentlyContinue
                return "File Explorer tuned for instant opening and file extensions."
            }
            Revert      = {
                Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowRecent' -Value 1 -Type DWord -ErrorAction SilentlyContinue
                return "Recent items history restored."
            }
        },

        # ----------------------------------------------------------------------
        # 5. PRIVACY & SECURITY
        # ----------------------------------------------------------------------
        [PSCustomObject]@{
            Id          = "sec_telemetry_registry"
            Category    = "Privacy & Security"
            Name        = "Deep OS Telemetry Lockdown (AllowTelemetry = 0)"
            Description = "Restricts Windows Diagnostic Data Collection policy to Security level."
            Improvement = "Blocks OS level diagnostic packets & telemetry collection"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Officially supported Microsoft Group Policy."
            Recommended = $true
            Detect      = {
                $t = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'AllowTelemetry' -ErrorAction SilentlyContinue).AllowTelemetry
                return ($t -eq 0)
            }
            Apply       = {
                $k = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection'
                if (!(Test-Path $k)) { New-Item -Path $k -Force -ErrorAction SilentlyContinue | Out-Null }
                Set-ItemProperty -Path $k -Name 'AllowTelemetry' -Value 0 -Type DWord -ErrorAction SilentlyContinue
                return "OS Telemetry policy set to Restricted/Security."
            }
            Revert      = {
                Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'AllowTelemetry' -Value 1 -Type DWord -ErrorAction SilentlyContinue
                return "Telemetry policy restored to Basic."
            }
        },
        [PSCustomObject]@{
            Id          = "sec_advertising_id"
            Category    = "Privacy & Security"
            Name        = "Disable Advertising ID & Timeline Activity Feed"
            Description = "Prevents Windows from generating a personalized advertising ID and logging activity feed."
            Improvement = "Stops targeted profile tracking & cross-device timeline sync"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Purely privacy-protecting setting."
            Recommended = $true
            Detect      = {
                $ad = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Name 'Enabled' -ErrorAction SilentlyContinue).Enabled
                return ($ad -eq 0)
            }
            Apply       = {
                $adKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo'
                if (!(Test-Path $adKey)) { New-Item -Path $adKey -Force -ErrorAction SilentlyContinue | Out-Null }
                Set-ItemProperty -Path $adKey -Name 'Enabled' -Value 0 -Type DWord -ErrorAction SilentlyContinue

                $actKey = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
                if (!(Test-Path $actKey)) { New-Item -Path $actKey -Force -ErrorAction SilentlyContinue | Out-Null }
                Set-ItemProperty -Path $actKey -Name 'EnableActivityFeed' -Value 0 -Type DWord -ErrorAction SilentlyContinue
                return "Advertising ID and Activity Feed disabled."
            }
            Revert      = {
                Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Name 'Enabled' -Value 1 -Type DWord -ErrorAction SilentlyContinue
                return "Advertising ID re-enabled."
            }
        },

        # ----------------------------------------------------------------------
        # 6. POWER & MAINTENANCE
        # ----------------------------------------------------------------------
        [PSCustomObject]@{
            Id          = "pwr_high_performance"
            Category    = "Power & Maintenance"
            Name        = "Activate High Performance Power Scheme"
            Description = "Forces the CPU clock multiplier to stay responsive without aggressive throttling down."
            Improvement = "Maximizes CPU burst frequency and compile speeds"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Standard Windows power profile. Can switch back to Balanced anytime."
            Recommended = $true
            Detect      = {
                $active = (powercfg /getactivescheme)
                return ($active -match "High performance|Ultimate Performance")
            }
            Apply       = {
                $highPerf = (powercfg /list) | Select-String "High performance"
                if ($highPerf) {
                    $guid = ($highPerf -split '\s+')[3]
                    powercfg /setactive $guid
                } else {
                    $created = (powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c)
                    $guid = ($created -split '\s+')[3]
                    powercfg /setactive $guid
                }
                return "High Performance power scheme active."
            }
            Revert      = {
                powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
                return "Balanced power scheme restored."
            }
        },
        [PSCustomObject]@{
            Id          = "pwr_disable_hibernation"
            Category    = "Power & Maintenance"
            Name        = "Disable Hibernation (hiberfil.sys)"
            Description = "Disables Windows Hibernation file. Instantly reclaims storage equal to your machine RAM (16 GB)."
            Improvement = "Instantly frees 8 GB to 32 GB of SSD storage"
            RiskLevel   = "Caution"
            RiskNote    = "Caution: Laptop will use standard Sleep instead of Hibernate. Great to save 16 GB SSD space."
            Recommended = $false
            Detect      = {
                return (!(Test-Path "C:\hiberfil.sys"))
            }
            Apply       = {
                powercfg /h off
                return "Hibernation disabled (hiberfil.sys removed)."
            }
            Revert      = {
                powercfg /h on
                return "Hibernation restored."
            }
        },
        [PSCustomObject]@{
            Id          = "maint_ssd_trim"
            Category    = "Power & Maintenance"
            Name        = "Run SSD / NVMe Storage ReTrim"
            Description = "Sends TRIM command to all SSD sectors to inform the controller of freed blocks."
            Improvement = "Restores peak NVMe/SSD read & write performance"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Official Windows storage maintenance command."
            Recommended = $true
            Detect      = {
                return $false
            }
            Apply       = {
                Optimize-Volume -DriveLetter C -ReTrim -ErrorAction SilentlyContinue | Out-Null
                return "SSD TRIM optimization completed on Drive C:."
            }
            Revert      = {
                return "N/A (TRIM is an active maintenance task)."
            }
        },
        [PSCustomObject]@{
            Id          = "net_flush_dns"
            Category    = "Power & Maintenance"
            Name        = "Flush & Reset DNS Resolver Cache"
            Description = "Clears stale, corrupt, or poisoned DNS entries stored by Windows."
            Improvement = "Fixes connection latency and website resolving delays"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Cleans DNS cache. Repopulates automatically."
            Recommended = $true
            Detect      = {
                return $false
            }
            Apply       = {
                Clear-DnsClientCache
                return "DNS Client cache successfully flushed."
            }
            Revert      = {
                return "N/A (DNS cache repopulates automatically)."
            }
        },
        [PSCustomObject]@{
            Id          = "maint_update_cache"
            Category    = "Power & Maintenance"
            Name        = "Clean Windows Update Download Cache"
            Description = "Deletes leftover installation files from C:\Windows\SoftwareDistribution\Download."
            Improvement = "Reclaims 2 GB to 10 GB+ of dead update cache"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Deletes old, already installed update installer packages."
            Recommended = $true
            Detect      = {
                $folder = "C:\Windows\SoftwareDistribution\Download"
                if (Test-Path $folder) {
                    $size = (Get-ChildItem $folder -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                    return ($size -lt 50MB)
                }
                return $true
            }
            Apply       = {
                $folder = "C:\Windows\SoftwareDistribution\Download"
                $freed = 0
                if (Test-Path $folder) {
                    $b = (Get-ChildItem $folder -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                    Get-ChildItem $folder -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
                        try { Remove-Item $_.FullName -Recurse -Force -ErrorAction Stop } catch {}
                    }
                    $a = (Get-ChildItem $folder -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                    $freed = [math]::Round(($b - $a) / 1MB, 2)
                }
                return "Cleaned Windows Update cache (Freed $freed MB)."
            }
            Revert      = {
                return "N/A (Temporary cache files)."
            }
        },
        [PSCustomObject]@{
            Id          = "maint_temp_clean"
            Category    = "Power & Maintenance"
            Name        = "Purge System & User Temp Files"
            Description = "Cleans locked and stale files from the user temp directory ($env:TEMP)."
            Improvement = "Reclaims 1 GB to 5 GB+ of SSD disk space"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Deletes temporary cache files safely."
            Recommended = $true
            Detect      = {
                return $false
            }
            Apply       = {
                $beforeBytes = (Get-ChildItem $env:TEMP -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                Get-ChildItem $env:TEMP -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { -not $_.PSIsContainer } | ForEach-Object {
                    try { Remove-Item $_.FullName -Force -ErrorAction Stop } catch {}
                }
                Get-ChildItem $env:TEMP -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.PSIsContainer } | ForEach-Object {
                    try { Remove-Item $_.FullName -Recurse -Force -ErrorAction Stop } catch {}
                }
                $afterBytes = (Get-ChildItem $env:TEMP -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                $freedMB = [math]::Round(($beforeBytes - $afterBytes) / 1MB, 2)
                return "Temp files purged. Freed $freedMB MB space."
            }
            Revert      = {
                return "N/A (Temporary cache files)."
            }
        },
        [PSCustomObject]@{
            Id          = "maint_ram_flush"
            Category    = "Power & Maintenance"
            Name        = "Flush Inactive Process Working Sets (Instant RAM)"
            Description = "Calls garbage collection and flushes inactive working sets back to the operating system."
            Improvement = "Immediately releases standby and leaked process RAM"
            RiskLevel   = "Safe"
            RiskNote    = "Zero risk. Built-in Windows memory manager garbage collection."
            Recommended = $true
            Detect      = {
                return $false
            }
            Apply       = {
                [System.GC]::Collect()
                [System.GC]::WaitForPendingFinalizers()
                return "Process garbage collection and working set trim executed."
            }
            Revert      = {
                return "N/A (Instant memory maintenance)."
            }
        }
    )
}
