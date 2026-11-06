# ⚡ Windows Speed & Performance Master Optimizer (Portable UI Edition)

A 100% native, zero-dependency, portable Windows 10 & 11 performance optimizer. Built using PowerShell and WPF (Windows Presentation Foundation) with a modern dark-mode GUI.

---

## 🚀 How to Run on Any Windows PC

1. Copy or extract the `windows-optimizer` folder to any Windows 10 or 11 computer (or keep it on a USB flash drive).
2. Right-click or double-click **`Launch-Optimizer.bat`**.
3. Accept the Windows User Account Control (UAC) prompt when asked for Administrator privileges.
4. The dark-themed optimizer window will open instantly.

---

## 🌟 Key Features

* **Zero Dependencies**: Runs out-of-the-box on vanilla Windows. No Python, Node.js, or external runtimes required.
* **100% Selective & Reversible**: Every single optimization can be individually applied or **reverted** back to Windows defaults with 1 click.
* **🛡️ Built-in System Restore Point**: Create a Windows restore point directly from the toolbar before tuning.
* **Real-Time System Diagnostics**: Displays live CPU, RAM usage, and available C: drive disk space.
* **One-Click Scan**: Scans the PC to detect which optimizations are already active and which are available.
* **Smart Recommendations**: One click on `Select Recommended` highlights safe, high-impact improvements while skipping items you don't need.
* **Real-Time Execution Console**: Live log output with progress indicator showing exact actions taken.
* **Instant Search & Filter**: Filter tweaks by keyword, category, or expected impact.

---

## 🛠️ Optimization Categories (35 Tweaks)

### 1. Windows & Telemetry Services
* **SysMain (SuperFetch)**: Eliminates redundant disk churn and frees 100–300 MB RAM on SSDs.
* **DiagTrack & Devices Telemetry**: Stops Windows diagnostic telemetry collection and background uploads.
* **Delivery Optimization (DoSvc)**: Stops Windows P2P background update seeding over the internet.
* **Lenovo UDC Service**: Stops Lenovo Universal Device Client telemetry scanner.
* **Microsoft Surface Service**: Disables Surface background services if running on non-Surface hardware.
* **Office Click-to-Run**: Stops permanent background Office update daemons.
* **Apple Bonjour & Samsung DeX**: Stops background mDNS and mobile connectivity services.
* **Print Spooler**: Optional toggle to close print spooler attack surface and free memory.

### 2. Scheduled Tasks & Periodic Scanners
* **Microsoft Compatibility Appraiser**: Stops the primary cause of sudden background disk/CPU spikes.
* **CEIP Consolidator**: Eliminates idle Customer Experience telemetry tasks.
* **AMD ReLive & DVR**: Disables background screen recording hooks (`StartDVR` / `AMDRSSrcExt`).
* **NVIDIA Crash Reporting**: Disables NVIDIA telemetry crash upload tasks.
* **Windows System Assessment (WinSAT)**: Prevents periodic idle hardware benchmark spikes and fan spin-ups.

### 3. Bloatware & Startup Applications
* **Microsoft Surface App**: Uninstalls redundant Surface UWP app on non-Surface PCs (saves ~185 MB RAM).
* **Windows Web Experience Pack**: Completely eliminates `WidgetService` and background WebView2 feeds.
* **Windows 11 Copilot**: Disables built-in Windows Copilot AI sidecar and taskbar shortcut.
* **Xbox Game Bar & Overlays**: Disables background game capture hooks for non-gamers.
* **Preinstalled Promo Apps**: Cleans Bing News, Bing Weather, Solitaire, and Feedback Hub.
* **Browser Ghost Mode**: Forces Chrome & Edge to fully close all helper processes upon exit.

### 4. UI & Visual Latency
* **Restore Windows 10 Classic Context Menu**: Instant full right-click menu in File Explorer without clicking "Show more options".
* **0ms Animation Latency**: Eliminates window minimize/maximize animation delays for instant snapping.
* **Disable Transparency**: Turns off GPU-intensive acrylic blur effects.
* **Local-Only Search**: Eliminates Bing web search and cloud delays from the Start Menu.
* **Explorer Responsiveness**: Disables recent files tracking history and forces file extensions.

### 5. Privacy & Security
* **Deep OS Telemetry Lockdown**: Restricts Windows Data Collection policy to Security level (`AllowTelemetry = 0`).
* **Disable Advertising ID & Timeline**: Stops user profiling and cross-device timeline tracking.

### 6. Power & Maintenance
* **High Performance Power Plan**: Enforces maximum CPU clock responsiveness without aggressive downclocking.
* **SSD NVMe TRIM**: Executes volume ReTrim to restore peak SSD read/write speeds.
* **Flush DNS Resolver**: Clears corrupted DNS cache to fix network and domain latency.
* **Windows Update Cache Cleaner**: Cleans dead installation files from `SoftwareDistribution\Download` (saves 2–10 GB).
* **RAM Working Set Flush**: Forces memory garbage collection to instantly reclaim standby process RAM.
* **Disable Hibernation (hiberfil.sys)**: Optional toggle to reclaim 8 GB to 32 GB of SSD storage equal to RAM size.

---

## 📁 Project Structure

```text
windows-optimizer/
├── Launch-Optimizer.bat      # UAC elevation & launch script
├── App.ps1                   # WPF Dark GUI application
├── README.md                 # Complete guide & documentation
└── modules/
    └── Definitions.ps1       # Modular catalog of 35 tweaks (Detect, Apply & Revert logic)
```
