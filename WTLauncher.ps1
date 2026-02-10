# ================================
# LOAD ASSEMBLIES
# ================================
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Windows.Forms.Application]::SetCompatibleTextRenderingDefault($false)

# ================================
# FORM (ICON SET EARLY)
# ================================
$form = New-Object System.Windows.Forms.Form
$form.Text = "WT Launcher"
$form.Size = New-Object System.Drawing.Size(420, 300)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.AutoScaleMode = 'Dpi'
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)

$baseDir  = [AppDomain]::CurrentDomain.BaseDirectory
$iconPath = Join-Path $baseDir "launcher.ico"
if (Test-Path $iconPath) {
    $form.Icon = New-Object System.Drawing.Icon($iconPath)
}

# ================================
# TITLE
# ================================
$title = New-Object System.Windows.Forms.Label
$title.Text = "WT Launcher"
$title.Font = New-Object System.Drawing.Font(
    "Segoe UI", 14, [System.Drawing.FontStyle]::Bold
)
$title.AutoSize = $true
$title.Location = '145,15'
[void]$form.Controls.Add($title)

# ================================
# DESCRIPTION
# ================================
$desc = New-Object System.Windows.Forms.Label
$desc.Text = "Select a tool to launch"
$desc.AutoSize = $true
$desc.Location = '145,50'
[void]$form.Controls.Add($desc)

# ================================
# GROUP BOX
# ================================
$group = New-Object System.Windows.Forms.GroupBox
$group.Text = "Available Tools"
$group.Size = '350,110'
$group.Location = '35,75'
[void]$form.Controls.Add($group)

# ================================
# TOOL BUTTONS
# ================================
$tempBtn = New-Object System.Windows.Forms.Button
$tempBtn.Text = "Temp Cleaner"
$tempBtn.Size = '130,40'
$tempBtn.Location = '25,35'
[void]$group.Controls.Add($tempBtn)

$netBtn = New-Object System.Windows.Forms.Button
$netBtn.Text = "Network Reset"
$netBtn.Size = '130,40'
$netBtn.Location = '190,35'
[void]$group.Controls.Add($netBtn)

# ================================
# FOOTER BUTTONS
# ================================
$aboutBtn = New-Object System.Windows.Forms.Button
$aboutBtn.Text = "About"
$aboutBtn.Size = '90,32'
$aboutBtn.Location = '85,210'
[void]$form.Controls.Add($aboutBtn)

$exitBtn = New-Object System.Windows.Forms.Button
$exitBtn.Text = "Exit"
$exitBtn.Size = '90,32'
$exitBtn.Location = '235,210'
[void]$form.Controls.Add($exitBtn)

# ================================
# EVENTS
# ================================
$exitBtn.Add_Click({
    $form.Close()
})

$aboutBtn.Add_Click({
    $githubUrl = "https://github.com/F3aarLeSS"

    $msg =
        "WT Launcher`n`n" +
        "Author: Navajyoti Bayan`n`n" +
        "Included tools:`n" +
        "• Windows Temp Cleaner`n" +
        "• Windows Network Reset`n`n" +
        "This launcher only starts tools when clicked.`n" +
        "No telemetry. No background services.`n`n" +
        "GitHub:`n$githubUrl"

    if ([System.Windows.Forms.MessageBox]::Show(
        $msg,
        "About",
        "OKCancel",
        "Information"
    ) -eq "OK") {
        Start-Process $githubUrl
    }
})

# ================================
# TOOL LAUNCH LOGIC (NO AUTO EXIT)
# ================================
function Launch-Tool {
    param ($ExeName, $PsName)

    $exe = Join-Path $baseDir $ExeName
    $ps1 = Join-Path $baseDir $PsName

    try {
        if (Test-Path $exe) {
            Start-Process $exe
        }
        elseif (Test-Path $ps1) {
            Start-Process powershell `
                -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$ps1`"" `
                -Verb RunAs
        }
        else {
            [System.Windows.Forms.MessageBox]::Show(
                "$ExeName / $PsName not found.",
                "Error",
                "OK",
                "Error"
            )
        }
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show(
            "Failed to launch tool.",
            "Error",
            "OK",
            "Error"
        )
    }
}

$tempBtn.Add_Click({
    Launch-Tool "WinTempCleaner.exe" "WinTempCleaner.ps1"
})

$netBtn.Add_Click({
    Launch-Tool "WinNetReset.exe" "WinNetReset.ps1"
})

# ================================
# RUN (CLEAN EXIT PATH)
# ================================
[void]$form.ShowDialog()
[Environment]::Exit(0)
