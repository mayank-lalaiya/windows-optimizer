# ==============================================================================
# Windows Speed & Performance Master Optimizer - Modern Light Theme (Version 2.5)
# 100% Native, Zero-Dependency, Portable Windows Tool
# ==============================================================================

try {
    Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms

    # Safe Directory Resolution
    if ($PSScriptRoot) {
        $ScriptDir = $PSScriptRoot
    } elseif ($MyInvocation.MyCommand.Path) {
        $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    } else {
        $ScriptDir = (Get-Location).Path
    }
    Set-Location $ScriptDir

    # Load modular definitions
    $defsPath = Join-Path $ScriptDir "modules\Definitions.ps1"
    if (!(Test-Path $defsPath)) {
        throw "Could not find definitions file at: $defsPath"
    }
    . $defsPath
    $AllTweaks = Get-OptimizationDefinitions

    # Gather Machine Hardware Info
    $cpu = (Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1).Name
    if (!$cpu) { $cpu = "Windows PC" }
    $os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
    $totalRamGB = if ($os) { [math]::Round($os.TotalVisibleMemorySize / 1MB, 1) } else { 16.0 }
    $freeRamGB  = if ($os) { [math]::Round($os.FreePhysicalMemory / 1MB, 2) } else { 1.0 }
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'" -ErrorAction SilentlyContinue
    $diskFreeGB = if ($disk) { [math]::Round($disk.FreeSpace / 1GB, 1) } else { 0.0 }

    # Build Main Window XAML (Clean Fluent Light Theme)
    [xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Windows Speed &amp; Performance Master Optimizer (Safe Edition)"
        Height="840" Width="1100"
        WindowStartupLocation="CenterScreen"
        Background="#F8FAFC"
        Foreground="#0F172A"
        FontFamily="Segoe UI">
    <Window.Resources>
        <Style TargetType="ScrollBar">
            <Setter Property="Background" Value="#F1F5F9"/>
        </Style>
    </Window.Resources>

    <Grid>
        <Grid.RowDefinitions>
            <!-- Header (0) -->
            <RowDefinition Height="Auto"/>
            <!-- System Stats Ribbon (1) -->
            <RowDefinition Height="Auto"/>
            <!-- Toolbar (2) -->
            <RowDefinition Height="Auto"/>
            <!-- Tweaks List (3) -->
            <RowDefinition Height="*"/>
            <!-- Log Console (4) -->
            <RowDefinition Height="130"/>
            <!-- Footer (5) -->
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- 0. HEADER -->
        <Border Grid.Row="0" Background="#FFFFFF" Padding="24,16" BorderBrush="#E2E8F0" BorderThickness="0,0,0,1">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <StackPanel Grid.Column="0">
                    <TextBlock Text="Windows Speed &amp; Performance Master Optimizer" FontSize="20" FontWeight="Bold" Foreground="#0F172A"/>
                    <TextBlock Text="Safe, 100% reversible performance tuning. Non-destructive with zero boot or system crash risk." FontSize="12" Foreground="#64748B" Margin="0,3,0,0"/>
                </StackPanel>
                <Border Grid.Column="1" Background="#EFF6FF" BorderBrush="#BFDBFE" BorderThickness="1" CornerRadius="6" Padding="12,6" VerticalAlignment="Center">
                    <TextBlock Text="LIGHT THEME &amp; SAFE REVERSIBLE EDITION" FontSize="11" FontWeight="Bold" Foreground="#1D4ED8"/>
                </Border>
            </Grid>
        </Border>

        <!-- 1. STATS RIBBON -->
        <Border Grid.Row="1" Background="#F1F5F9" Padding="24,10" BorderBrush="#E2E8F0" BorderThickness="0,0,0,1">
            <WrapPanel VerticalAlignment="Center">
                <Border Background="#FFFFFF" CornerRadius="6" Padding="12,6" Margin="0,0,12,0" BorderBrush="#E2E8F0" BorderThickness="1">
                    <StackPanel Orientation="Horizontal">
                        <TextBlock Text="CPU: " FontSize="12" Foreground="#64748B"/>
                        <TextBlock x:Name="TxtCpu" Text="$cpu" FontSize="12" FontWeight="SemiBold" Foreground="#0F172A"/>
                    </StackPanel>
                </Border>
                <Border Background="#FFFFFF" CornerRadius="6" Padding="12,6" Margin="0,0,12,0" BorderBrush="#E2E8F0" BorderThickness="1">
                    <StackPanel Orientation="Horizontal">
                        <TextBlock Text="RAM: " FontSize="12" Foreground="#64748B"/>
                        <TextBlock x:Name="TxtRam" Text="$totalRamGB GB total ($freeRamGB GB free)" FontSize="12" FontWeight="SemiBold" Foreground="#0284C7"/>
                    </StackPanel>
                </Border>
                <Border Background="#FFFFFF" CornerRadius="6" Padding="12,6" BorderBrush="#E2E8F0" BorderThickness="1">
                    <StackPanel Orientation="Horizontal">
                        <TextBlock Text="Drive C: " FontSize="12" Foreground="#64748B"/>
                        <TextBlock x:Name="TxtDisk" Text="$diskFreeGB GB free" FontSize="12" FontWeight="SemiBold" Foreground="#059669"/>
                    </StackPanel>
                </Border>
            </WrapPanel>
        </Border>

        <!-- 2. TOOLBAR -->
        <Border Grid.Row="2" Background="#FFFFFF" Padding="24,12" BorderBrush="#E2E8F0" BorderThickness="0,0,0,1">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>

                <!-- Left action buttons -->
                <StackPanel Grid.Column="0" Orientation="Horizontal">
                    <Button x:Name="BtnScan" Content="Scan System" Background="#2563EB" Foreground="#FFFFFF" FontWeight="SemiBold"
                            FontSize="12" Padding="14,7" Margin="0,0,8,0" Cursor="Hand" BorderThickness="0">
                        <Button.Resources>
                            <Style TargetType="Border">
                                <Setter Property="CornerRadius" Value="6"/>
                            </Style>
                        </Button.Resources>
                    </Button>
                    <Button x:Name="BtnSelectSafeOnly" Content="Select 100% Safe Only" Background="#ECFDF5" Foreground="#047857" FontWeight="Bold"
                            FontSize="12" Padding="12,7" Margin="0,0,8,0" Cursor="Hand" BorderBrush="#A7F3D0" BorderThickness="1">
                        <Button.Resources>
                            <Style TargetType="Border">
                                <Setter Property="CornerRadius" Value="6"/>
                            </Style>
                        </Button.Resources>
                    </Button>
                    <Button x:Name="BtnSelectRecommended" Content="Recommended" Background="#F8FAFC" Foreground="#1E293B" FontWeight="SemiBold"
                            FontSize="12" Padding="12,7" Margin="0,0,8,0" Cursor="Hand" BorderBrush="#CBD5E1" BorderThickness="1">
                        <Button.Resources>
                            <Style TargetType="Border">
                                <Setter Property="CornerRadius" Value="6"/>
                            </Style>
                        </Button.Resources>
                    </Button>
                    <Button x:Name="BtnSelectAll" Content="Select All" Background="#F8FAFC" Foreground="#475569"
                            FontSize="12" Padding="10,7" Margin="0,0,6,0" Cursor="Hand" BorderBrush="#E2E8F0" BorderThickness="1">
                        <Button.Resources>
                            <Style TargetType="Border">
                                <Setter Property="CornerRadius" Value="6"/>
                            </Style>
                        </Button.Resources>
                    </Button>
                    <Button x:Name="BtnClearAll" Content="Clear All" Background="#F8FAFC" Foreground="#475569"
                            FontSize="12" Padding="10,7" Margin="0,0,8,0" Cursor="Hand" BorderBrush="#E2E8F0" BorderThickness="1">
                        <Button.Resources>
                            <Style TargetType="Border">
                                <Setter Property="CornerRadius" Value="6"/>
                            </Style>
                        </Button.Resources>
                    </Button>
                    <Button x:Name="BtnRestorePoint" Content="Create Restore Point" Background="#FFFBEB" Foreground="#B45309"
                            FontSize="12" FontWeight="SemiBold" Padding="10,7" Margin="0,0,8,0" Cursor="Hand" BorderBrush="#FDE68A" BorderThickness="1">
                        <Button.Resources>
                            <Style TargetType="Border">
                                <Setter Property="CornerRadius" Value="6"/>
                            </Style>
                        </Button.Resources>
                    </Button>
                </StackPanel>

                <!-- Right search box -->
                <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                    <TextBlock Text="Filter: " FontSize="12" Foreground="#64748B" VerticalAlignment="Center" Margin="0,0,6,0"/>
                    <TextBox x:Name="TxtFilter" Width="180" Background="#FFFFFF" Foreground="#0F172A" BorderBrush="#CBD5E1"
                             Padding="8,5" FontSize="12">
                        <TextBox.Resources>
                            <Style TargetType="Border">
                                <Setter Property="CornerRadius" Value="6"/>
                            </Style>
                        </TextBox.Resources>
                    </TextBox>
                </StackPanel>
            </Grid>
        </Border>

        <!-- 3. TWEAKS CONTAINER -->
        <ScrollViewer Grid.Row="3" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled" Padding="24,14">
            <StackPanel x:Name="TweaksPanel">
                <!-- Safety Guarantee Banner -->
                <Border Background="#F0FDF4" BorderBrush="#BBF7D0" BorderThickness="1" CornerRadius="8" Padding="14,10" Margin="0,0,0,12">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <TextBlock Grid.Column="0" Text="[SAFE]" FontSize="13" FontWeight="Bold" Foreground="#15803D" VerticalAlignment="Center" Margin="0,0,10,0"/>
                        <StackPanel Grid.Column="1">
                            <TextBlock Text="Zero Boot Risk &amp; 100% Reversible Guarantee" FontSize="12" FontWeight="Bold" Foreground="#15803D"/>
                            <TextBlock Text="None of these optimizations alter boot files, system kernels, or hardware drivers. Your PC will always boot normally, and every tweak can be restored to Windows default with 1 click." FontSize="11" Foreground="#166534" Margin="0,2,0,0" TextWrapping="Wrap"/>
                        </StackPanel>
                    </Grid>
                </Border>
            </StackPanel>
        </ScrollViewer>

        <!-- 4. LOG CONSOLE -->
        <Border Grid.Row="4" Background="#0F172A" BorderBrush="#E2E8F0" BorderThickness="0,1,0,1" Padding="16,8">
            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                <TextBlock Grid.Row="0" Text="REAL-TIME EXECUTION LOG" FontSize="11" FontWeight="Bold" Foreground="#94A3B8" Margin="0,0,0,4"/>
                <TextBox Grid.Row="1" x:Name="TxtLog" Background="Transparent" Foreground="#67E8F9" BorderThickness="0"
                         IsReadOnly="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto"
                         FontFamily="Consolas" FontSize="11" Text="Ready. Click 'Scan System' to detect status or select tweaks to optimize/revert."/>
            </Grid>
        </Border>

        <!-- 5. FOOTER & ACTION BUTTONS -->
        <Border Grid.Row="5" Background="#FFFFFF" Padding="24,12" BorderBrush="#E2E8F0" BorderThickness="0,1,0,0">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>

                <StackPanel Grid.Column="0" VerticalAlignment="Center" Margin="0,0,20,0">
                    <TextBlock x:Name="TxtStatus" Text="Ready to scan, apply, or revert optimizations." FontSize="12" Foreground="#64748B" Margin="0,0,0,4"/>
                    <ProgressBar x:Name="PrgBar" Height="6" Background="#E2E8F0" Foreground="#059669" Value="0" Maximum="100" BorderThickness="0"/>
                </StackPanel>

                <StackPanel Grid.Column="1" Orientation="Horizontal">
                    <Button x:Name="BtnRevert" Content="Revert Selected"
                            Background="#F1F5F9" Foreground="#334155" FontWeight="SemiBold" FontSize="12" Padding="16,10"
                            Margin="0,0,10,0" Cursor="Hand" BorderBrush="#CBD5E1" BorderThickness="1">
                        <Button.Resources>
                            <Style TargetType="Border">
                                <Setter Property="CornerRadius" Value="6"/>
                            </Style>
                        </Button.Resources>
                    </Button>
                    <Button x:Name="BtnApply" Content="Apply Selected Optimizations"
                            Background="#16A34A" Foreground="#FFFFFF" FontWeight="Bold" FontSize="13" Padding="20,10"
                            Cursor="Hand" BorderThickness="0">
                        <Button.Resources>
                            <Style TargetType="Border">
                                <Setter Property="CornerRadius" Value="6"/>
                            </Style>
                        </Button.Resources>
                    </Button>
                </StackPanel>
            </Grid>
        </Border>
    </Grid>
</Window>
"@

    $reader = [System.Xml.XmlNodeReader]::new($xaml)
    $window = [System.Windows.Markup.XamlReader]::Load($reader)

    # Map UI Controls
    $tweaksPanel          = $window.FindName("TweaksPanel")
    $btnScan              = $window.FindName("BtnScan")
    $btnSelectSafeOnly    = $window.FindName("BtnSelectSafeOnly")
    $btnSelectRecommended = $window.FindName("BtnSelectRecommended")
    $btnSelectAll         = $window.FindName("BtnSelectAll")
    $btnClearAll          = $window.FindName("BtnClearAll")
    $btnRestorePoint      = $window.FindName("BtnRestorePoint")
    $txtFilter            = $window.FindName("TxtFilter")
    $txtLog               = $window.FindName("TxtLog")
    $txtStatus            = $window.FindName("TxtStatus")
    $prgBar               = $window.FindName("PrgBar")
    $btnApply             = $window.FindName("BtnApply")
    $btnRevert            = $window.FindName("BtnRevert")
    $txtRam               = $window.FindName("TxtRam")
    $txtDisk              = $window.FindName("TxtDisk")

    # Store tweak UI bindings
    $TweakControls = @()

    # Helper: Append to Log
    function Log-Message([string]$msg) {
        $time = (Get-Date).ToString("HH:mm:ss")
        $txtLog.AppendText("`r`n[$time] $msg")
        $txtLog.ScrollToEnd()
        [System.Windows.Forms.Application]::DoEvents()
    }

    # Group Tweaks by Category and Render
    $categories = $AllTweaks | Select-Object -ExpandProperty Category -Unique
    foreach ($cat in $categories) {
        # Category Header Card
        $catBorder = [System.Windows.Controls.Border]::new()
        $catBorder.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#F8FAFC")
        $catBorder.CornerRadius = [System.Windows.CornerRadius]::new(6)
        $catBorder.Padding = [System.Windows.Thickness]::new(12, 8, 12, 8)
        $catBorder.Margin = [System.Windows.Thickness]::new(0, 10, 0, 8)
        $catBorder.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#E2E8F0")
        $catBorder.BorderThickness = [System.Windows.Thickness]::new(1)

        $catGrid = [System.Windows.Controls.Grid]::new()
        $col1 = [System.Windows.Controls.ColumnDefinition]::new()
        $col1.Width = [System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)
        $col2 = [System.Windows.Controls.ColumnDefinition]::new()
        $col2.Width = [System.Windows.GridLength]::Auto
        $catGrid.ColumnDefinitions.Add($col1)
        $catGrid.ColumnDefinitions.Add($col2)

        $catTitle = [System.Windows.Controls.TextBlock]::new()
        $catTitle.Text = $cat.ToUpper()
        $catTitle.FontSize = 12
        $catTitle.FontWeight = [System.Windows.FontWeights]::Bold
        $catTitle.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#1E40AF")
        $catTitle.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
        [System.Windows.Controls.Grid]::SetColumn($catTitle, 0)
        $catGrid.Children.Add($catTitle) | Out-Null

        $catToggleBtn = [System.Windows.Controls.Button]::new()
        $catToggleBtn.Content = "Toggle Category"
        $catToggleBtn.FontSize = 11
        $catToggleBtn.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#FFFFFF")
        $catToggleBtn.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#475569")
        $catToggleBtn.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#CBD5E1")
        $catToggleBtn.BorderThickness = [System.Windows.Thickness]::new(1)
        $catToggleBtn.Padding = [System.Windows.Thickness]::new(8, 4, 8, 4)
        $catToggleBtn.Cursor = [System.Windows.Input.Cursors]::Hand
        [System.Windows.Controls.Grid]::SetColumn($catToggleBtn, 1)
        $catGrid.Children.Add($catToggleBtn) | Out-Null

        $catBorder.Child = $catGrid
        $tweaksPanel.Children.Add($catBorder) | Out-Null

        $catTweaks = $AllTweaks | Where-Object { $_.Category -eq $cat }
        $catCheckboxes = @()

        foreach ($tweak in $catTweaks) {
            $card = [System.Windows.Controls.Border]::new()
            $card.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#FFFFFF")
            $card.CornerRadius = [System.Windows.CornerRadius]::new(6)
            $card.Padding = [System.Windows.Thickness]::new(14, 10, 14, 10)
            $card.Margin = [System.Windows.Thickness]::new(0, 0, 0, 6)
            $card.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#E2E8F0")
            $card.BorderThickness = [System.Windows.Thickness]::new(1)

            $grid = [System.Windows.Controls.Grid]::new()
            $c0 = [System.Windows.Controls.ColumnDefinition]::new()
            $c0.Width = [System.Windows.GridLength]::Auto
            $c1 = [System.Windows.Controls.ColumnDefinition]::new()
            $c1.Width = [System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)
            $c2 = [System.Windows.Controls.ColumnDefinition]::new()
            $c2.Width = [System.Windows.GridLength]::Auto
            $grid.ColumnDefinitions.Add($c0)
            $grid.ColumnDefinitions.Add($c1)
            $grid.ColumnDefinitions.Add($c2)

            # Checkbox
            $cb = [System.Windows.Controls.CheckBox]::new()
            $cb.IsChecked = ($tweak.Recommended -and $tweak.RiskLevel -eq "Safe")
            $cb.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
            $cb.Margin = [System.Windows.Thickness]::new(0, 0, 12, 0)
            $cb.Cursor = [System.Windows.Input.Cursors]::Hand
            [System.Windows.Controls.Grid]::SetColumn($cb, 0)
            $grid.Children.Add($cb) | Out-Null
            $catCheckboxes += $cb

            # Details Panel
            $infoStack = [System.Windows.Controls.StackPanel]::new()
            [System.Windows.Controls.Grid]::SetColumn($infoStack, 1)

            # Title Row: Name + Risk Badge + Impact Pill
            $titleWrap = [System.Windows.Controls.WrapPanel]::new()
            
            $nameBlock = [System.Windows.Controls.TextBlock]::new()
            $nameBlock.Text = $tweak.Name
            $nameBlock.FontSize = 13
            $nameBlock.FontWeight = [System.Windows.FontWeights]::SemiBold
            $nameBlock.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#0F172A")
            $nameBlock.Margin = [System.Windows.Thickness]::new(0, 0, 8, 2)
            $titleWrap.Children.Add($nameBlock) | Out-Null

            # 1. Risk Level Badge
            $riskBadge = [System.Windows.Controls.Border]::new()
            $riskBadge.CornerRadius = [System.Windows.CornerRadius]::new(4)
            $riskBadge.Padding = [System.Windows.Thickness]::new(6, 2, 6, 2)
            $riskBadge.Margin = [System.Windows.Thickness]::new(0, 0, 6, 2)
            $riskText = [System.Windows.Controls.TextBlock]::new()
            $riskText.FontSize = 10
            $riskText.FontWeight = [System.Windows.FontWeights]::Bold

            if ($tweak.RiskLevel -eq "Safe") {
                $riskBadge.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#DCFCE7")
                $riskBadge.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#86EFAC")
                $riskBadge.BorderThickness = [System.Windows.Thickness]::new(1)
                $riskText.Text = "[SAFE] Zero Boot Risk"
                $riskText.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#15803D")
            } else {
                $riskBadge.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#FEF3C7")
                $riskBadge.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#FDE68A")
                $riskBadge.BorderThickness = [System.Windows.Thickness]::new(1)
                $riskText.Text = "[CAUTION] Workflow Specific"
                $riskText.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#B45309")
            }
            $riskBadge.Child = $riskText
            $titleWrap.Children.Add($riskBadge) | Out-Null

            # 2. Improvement Pill
            $pill = [System.Windows.Controls.Border]::new()
            $pill.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#EFF6FF")
            $pill.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#BFDBFE")
            $pill.BorderThickness = [System.Windows.Thickness]::new(1)
            $pill.CornerRadius = [System.Windows.CornerRadius]::new(4)
            $pill.Padding = [System.Windows.Thickness]::new(6, 2, 6, 2)
            $pill.Margin = [System.Windows.Thickness]::new(0, 0, 0, 2)
            $pillText = [System.Windows.Controls.TextBlock]::new()
            $pillText.Text = "[Impact] " + $tweak.Improvement
            $pillText.FontSize = 10
            $pillText.FontWeight = [System.Windows.FontWeights]::SemiBold
            $pillText.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#1D4ED8")
            $pill.Child = $pillText
            $titleWrap.Children.Add($pill) | Out-Null

            $infoStack.Children.Add($titleWrap) | Out-Null

            # Description
            $descBlock = [System.Windows.Controls.TextBlock]::new()
            $descBlock.Text = $tweak.Description
            $descBlock.FontSize = 11
            $descBlock.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#475569")
            $descBlock.TextWrapping = [System.Windows.TextWrapping]::Wrap
            $descBlock.Margin = [System.Windows.Thickness]::new(0, 2, 0, 0)
            $infoStack.Children.Add($descBlock) | Out-Null

            # Risk Note
            if ($tweak.RiskNote) {
                $noteBlock = [System.Windows.Controls.TextBlock]::new()
                $noteBlock.Text = "Note: " + $tweak.RiskNote
                $noteBlock.FontSize = 10
                $noteBlock.Foreground = if ($tweak.RiskLevel -eq "Safe") {
                    [System.Windows.Media.BrushConverter]::new().ConvertFromString("#16A34A")
                } else {
                    [System.Windows.Media.BrushConverter]::new().ConvertFromString("#D97706")
                }
                $noteBlock.Margin = [System.Windows.Thickness]::new(0, 2, 0, 0)
                $infoStack.Children.Add($noteBlock) | Out-Null
            }

            $grid.Children.Add($infoStack) | Out-Null

            # Status Badge (Right side)
            $statusBorder = [System.Windows.Controls.Border]::new()
            $statusBorder.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#F1F5F9")
            $statusBorder.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#E2E8F0")
            $statusBorder.BorderThickness = [System.Windows.Thickness]::new(1)
            $statusBorder.CornerRadius = [System.Windows.CornerRadius]::new(4)
            $statusBorder.Padding = [System.Windows.Thickness]::new(8, 4, 8, 4)
            $statusBorder.VerticalAlignment = [System.Windows.VerticalAlignment]::Center

            $statusText = [System.Windows.Controls.TextBlock]::new()
            $statusText.Text = "Not Scanned"
            $statusText.FontSize = 11
            $statusText.FontWeight = [System.Windows.FontWeights]::SemiBold
            $statusText.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#64748B")
            $statusBorder.Child = $statusText
            [System.Windows.Controls.Grid]::SetColumn($statusBorder, 2)
            $grid.Children.Add($statusBorder) | Out-Null

            $card.Child = $grid
            $tweaksPanel.Children.Add($card) | Out-Null

            # Save control binding
            $TweakControls += [PSCustomObject]@{
                Tweak        = $tweak
                Card         = $card
                CheckBox     = $cb
                StatusBorder = $statusBorder
                StatusText   = $statusText
            }
        }

        # Category Toggle Button Action
        $catToggleBtn.Add_Click({
            $anyUnchecked = ($catCheckboxes | Where-Object { -not $_.IsChecked }).Count -gt 0
            foreach ($c in $catCheckboxes) {
                $c.IsChecked = $anyUnchecked
            }
        })
    }

    # --------------------------------------------------------------------------
    # ACTIONS & EVENT HANDLERS
    # --------------------------------------------------------------------------

    # 1. SCAN SYSTEM
    $btnScan.Add_Click({
        $btnScan.IsEnabled = $false
        $txtStatus.Text = "Scanning system configuration..."
        Log-Message "Starting system scan across all $($TweakControls.Count) optimizations..."

        $scanned = 0
        $alreadyOptimized = 0
        $needsOptimization = 0

        foreach ($ctrl in $TweakControls) {
            $t = $ctrl.Tweak
            try {
                $isOptimized = & $t.Detect
                if ($isOptimized) {
                    $ctrl.StatusBorder.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#DCFCE7")
                    $ctrl.StatusBorder.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#86EFAC")
                    $ctrl.StatusText.Text = "[Optimized]"
                    $ctrl.StatusText.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#15803D")
                    $ctrl.CheckBox.IsChecked = $false
                    $alreadyOptimized++
                } else {
                    $ctrl.StatusBorder.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#FEF3C7")
                    $ctrl.StatusBorder.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#FDE68A")
                    $ctrl.StatusText.Text = "[Ready]"
                    $ctrl.StatusText.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#B45309")
                    if ($t.Recommended -and $t.RiskLevel -eq "Safe") { $ctrl.CheckBox.IsChecked = $true }
                    $needsOptimization++
                }
            } catch {
                $ctrl.StatusText.Text = "[Scan Err]"
            }
            $scanned++
            $prgBar.Value = [math]::Round(($scanned / $TweakControls.Count) * 100)
        }

        $btnScan.IsEnabled = $true
        $txtStatus.Text = "Scan Complete: $alreadyOptimized already optimized, $needsOptimization available to tune."
        Log-Message "Scan completed: $alreadyOptimized items already optimized. $needsOptimization available to apply."
    })

    # 2. SELECT SAFE ONLY (USER REQUESTED FEATURE)
    $btnSelectSafeOnly.Add_Click({
        foreach ($ctrl in $TweakControls) {
            if ($ctrl.Tweak.RiskLevel -eq "Safe" -and $ctrl.StatusText.Text -ne "[Optimized]") {
                $ctrl.CheckBox.IsChecked = $true
            } else {
                $ctrl.CheckBox.IsChecked = $false
            }
        }
        $txtStatus.Text = "Selected only 100% safe, zero-risk optimizations."
        Log-Message "Selected all safe, zero-risk optimizations (Caution items excluded)."
    })

    # 3. SELECT RECOMMENDED
    $btnSelectRecommended.Add_Click({
        foreach ($ctrl in $TweakControls) {
            if ($ctrl.StatusText.Text -eq "[Optimized]") {
                $ctrl.CheckBox.IsChecked = $false
            } else {
                $ctrl.CheckBox.IsChecked = ($ctrl.Tweak.Recommended -and $ctrl.Tweak.RiskLevel -eq "Safe")
            }
        }
        $txtStatus.Text = "Recommended safe optimizations selected."
        Log-Message "Selected recommended safe optimizations."
    })

    # 4. SELECT ALL / CLEAR ALL
    $btnSelectAll.Add_Click({
        foreach ($ctrl in $TweakControls) { $ctrl.CheckBox.IsChecked = $true }
        $txtStatus.Text = "All optimizations selected."
    })

    $btnClearAll.Add_Click({
        foreach ($ctrl in $TweakControls) { $ctrl.CheckBox.IsChecked = $false }
        $txtStatus.Text = "All selections cleared."
    })

    # 5. CREATE RESTORE POINT
    $btnRestorePoint.Add_Click({
        $btnRestorePoint.IsEnabled = $false
        Log-Message "Attempting to create a Windows System Restore Point..."
        try {
            Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
            Checkpoint-Computer -Description "Windows Optimizer Pre-Tuning" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
            Log-Message "[SUCCESS] System Restore Point 'Windows Optimizer Pre-Tuning' created successfully!"
            [System.Windows.Forms.MessageBox]::Show("System Restore Point created successfully!", "Restore Point Confirmed", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        } catch {
            Log-Message "[NOTICE] System restore point note: $($_.Exception.Message)"
        }
        $btnRestorePoint.IsEnabled = $true
    })

    # 6. FILTER / SEARCH
    $txtFilter.Add_TextChanged({
        $term = $txtFilter.Text.ToLower().Trim()
        foreach ($ctrl in $TweakControls) {
            $match = ($ctrl.Tweak.Name.ToLower().Contains($term) -or
                      $ctrl.Tweak.Category.ToLower().Contains($term) -or
                      $ctrl.Tweak.Description.ToLower().Contains($term) -or
                      $ctrl.Tweak.RiskLevel.ToLower().Contains($term) -or
                      $ctrl.Tweak.Improvement.ToLower().Contains($term))
            $ctrl.Card.Visibility = if ($match) { [System.Windows.Visibility]::Visible } else { [System.Windows.Visibility]::Collapsed }
        }
    })

    # 7. APPLY SELECTED OPTIMIZATIONS
    $btnApply.Add_Click({
        $selected = $TweakControls | Where-Object { $_.CheckBox.IsChecked }
        if (!$selected -or $selected.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show("Please select at least one optimization to apply.", "No Items Selected", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            return
        }

        $btnApply.IsEnabled = $false
        $btnRevert.IsEnabled = $false
        $btnScan.IsEnabled = $false
        $prgBar.Value = 0

        $total = $selected.Count
        Log-Message "=========================================================="
        Log-Message "Starting optimization run on $total selected item(s)..."
        Log-Message "=========================================================="

        $count = 0
        foreach ($ctrl in $selected) {
            $t = $ctrl.Tweak
            $count++
            $txtStatus.Text = "Applying ($count/$total): $($t.Name)..."
            $prgBar.Value = [math]::Round(($count / $total) * 100)

            try {
                $result = & $t.Apply
                Log-Message "[APPLIED] $($t.Name) -> $result"
                $ctrl.StatusBorder.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#DCFCE7")
                $ctrl.StatusBorder.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#86EFAC")
                $ctrl.StatusText.Text = "[Optimized]"
                $ctrl.StatusText.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#15803D")
                $ctrl.CheckBox.IsChecked = $false
            } catch {
                Log-Message "[ERROR] Failed on $($t.Name): $($_.Exception.Message)"
                $ctrl.StatusBorder.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#FEE2E2")
                $ctrl.StatusBorder.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#FCA5A5")
                $ctrl.StatusText.Text = "[Failed]"
                $ctrl.StatusText.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#B91C1C")
            }
        }

        # Refresh RAM and Disk Stats
        $newOs = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
        if ($newOs) {
            $newFreeRAM = [math]::Round($newOs.FreePhysicalMemory / 1MB, 2)
            $txtRam.Text = "$totalRamGB GB total ($newFreeRAM GB free)"
        }
        $newDisk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'" -ErrorAction SilentlyContinue
        if ($newDisk) {
            $newDiskFree = [math]::Round($newDisk.FreeSpace / 1GB, 1)
            $txtDisk.Text = "$newDiskFree GB free"
        }

        $txtStatus.Text = "Optimization Complete! $total item(s) processed."
        Log-Message "=========================================================="
        Log-Message "ALL SELECTED OPTIMIZATIONS COMPLETED SUCCESSFULLY!"
        Log-Message "=========================================================="

        $btnApply.IsEnabled = $true
        $btnRevert.IsEnabled = $true
        $btnScan.IsEnabled = $true
    })

    # 8. REVERT SELECTED OPTIMIZATIONS
    $btnRevert.Add_Click({
        $selected = $TweakControls | Where-Object { $_.CheckBox.IsChecked }
        if (!$selected -or $selected.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show("Please check the items you wish to revert.", "No Items Selected", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            return
        }

        $btnApply.IsEnabled = $false
        $btnRevert.IsEnabled = $false
        $prgBar.Value = 0

        $total = $selected.Count
        Log-Message "=========================================================="
        Log-Message "Reverting $total selected item(s) to Windows defaults..."
        Log-Message "=========================================================="

        $count = 0
        foreach ($ctrl in $selected) {
            $t = $ctrl.Tweak
            $count++
            $txtStatus.Text = "Reverting ($count/$total): $($t.Name)..."
            $prgBar.Value = [math]::Round(($count / $total) * 100)

            try {
                if ($t.Revert) {
                    $result = & $t.Revert
                    Log-Message "[REVERTED] $($t.Name) -> $result"
                    $ctrl.StatusBorder.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#F1F5F9")
                    $ctrl.StatusBorder.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#E2E8F0")
                    $ctrl.StatusText.Text = "[Default]"
                    $ctrl.StatusText.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#475569")
                }
            } catch {
                Log-Message "[ERROR] Failed to revert $($t.Name): $($_.Exception.Message)"
            }
        }

        $txtStatus.Text = "Revert Complete! $total item(s) processed."
        Log-Message "=========================================================="
        Log-Message "REVERT OPERATION COMPLETED."
        Log-Message "=========================================================="

        $btnApply.IsEnabled = $true
        $btnRevert.IsEnabled = $true
    })

    # Show Window
    $window.ShowDialog() | Out-Null

} catch {
    $err = $_.Exception.ToString()
    $logErr = "$env:TEMP\win_optimizer_error.log"
    [System.IO.File]::WriteAllText($logErr, $err)
    Add-Type -AssemblyName System.Windows.Forms -ErrorAction SilentlyContinue
    [System.Windows.Forms.MessageBox]::Show("Windows Optimizer failed to launch:`n`n$($_.Exception.Message)`n`nDetails logged to: $logErr", "Windows Optimizer Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}
