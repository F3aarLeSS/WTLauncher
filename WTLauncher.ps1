# ================================
# LOAD ASSEMBLIES
# ================================
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Windows.Forms.Application]::SetCompatibleTextRenderingDefault($false)

# ================================
# BASE DIRECTORY (EXE-SAFE)
# ================================
$baseDir = [IO.Path]::GetDirectoryName(
    [Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
)

# ================================
# FORM
# ================================
$form = New-Object System.Windows.Forms.Form
$form.Text = "WT Launcher"
$form.Size = New-Object System.Drawing.Size(420, 300)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)

# ICON
$iconFile = "$baseDir\launcher.ico"
if ([IO.File]::Exists($iconFile)) {
    $form.Icon = New-Object System.Drawing.Icon($iconFile)
}

# ================================
# TITLE
# ================================
$title = New-Object System.Windows.Forms.Label
$title.Text = "WT Launcher"
$title.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(145, 15)
$form.Controls.Add($title)

$desc = New-Object System.Windows.Forms.Label
$desc.Text = "Select a tool to launch"
$desc.AutoSize = $true
$desc.Location = New-Object System.Drawing.Point(145, 50)
$form.Controls.Add($desc)

# ================================
# GROUP BOX
# ================================
$group = New-Object System.Windows.Forms.GroupBox
$group.Text = "Available Tools"
$group.Size = New-Object System.Drawing.Size(350, 110)
$group.Location = New-Object System.Drawing.Point(35, 75)
$form.Controls.Add($group)

# ================================
# BUTTONS
# ================================
$tempBtn = New-Object System.Windows.Forms.Button
$tempBtn.Text = "Temp Cleaner"
$tempBtn.Size = New-Object System.Drawing.Size(130, 40)
$tempBtn.Location = New-Object System.Drawing.Point(25, 35)
$group.Controls.Add($tempBtn)

$netBtn = New-Object System.Windows.Forms.Button
$netBtn.Text = "Network Reset"
$netBtn.Size = New-Object System.Drawing.Size(130, 40)
$netBtn.Location = New-Object System.Drawing.Point(190, 35)
$group.Controls.Add($netBtn)

$aboutBtn = New-Object System.Windows.Forms.Button
$aboutBtn.Text = "About"
$aboutBtn.Size = New-Object System.Drawing.Size(90, 32)
$aboutBtn.Location = New-Object System.Drawing.Point(85, 210)
$form.Controls.Add($aboutBtn)

$exitBtn = New-Object System.Windows.Forms.Button
$exitBtn.Text = "Exit"
$exitBtn.Size = New-Object System.Drawing.Size(90, 32)
$exitBtn.Location = New-Object System.Drawing.Point(235, 210)
$form.Controls.Add($exitBtn)

# ================================
# EVENTS
# ================================
$exitBtn.Add_Click({
    $form.Close()
})

$aboutBtn.Add_Click({
    [System.Windows.Forms.MessageBox]::Show(
        "WT Launcher v1.0`n`n" +
        "Author: Navajyoti Bayan`n`n" +
        "This launcher starts local tools only.`n" +
        "Tools are loaded from the 'tools' folder.`n`n" +
        "No telemetry. No background services.",
        "About",
        "OK",
        "Information"
    )
})

# ================================
# TOOL LAUNCH (NO AUTO EXIT)
# ================================
function Launch-Tool {
    param (
        [string]$ExeName,
        [string]$PsName
    )

    $toolExe = "$baseDir\tools\$ExeName"
    $toolPs1 = "$baseDir\tools\$PsName"

    if ([IO.File]::Exists($toolExe)) {
        Start-Process $toolExe
        return
    }

    if ([IO.File]::Exists($toolPs1)) {
        Start-Process powershell `
            -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$toolPs1`"" `
            -Verb RunAs
        return
    }

    [System.Windows.Forms.MessageBox]::Show(
        "Required tool files not found.`n`n" +
        "Expected location:`n$baseDir\tools",
        "Missing Files",
        "OK",
        "Error"
    )
}

$tempBtn.Add_Click({
    Launch-Tool "WinTempCleaner.exe" "WinTempCleaner.ps1"
})

$netBtn.Add_Click({
    Launch-Tool "WinNetReset.exe" "WinNetReset.ps1"
})

# ================================
# RUN (NO FORCED EXIT)
# ================================
[void]$form.ShowDialog()
