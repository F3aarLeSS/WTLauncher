# Windows Tools Launcher (WTLauncher)

A simple launcher application for Windows maintenance utilities.

This launcher provides a clean interface to run:
- Windows Temp Cleaner
- Windows Network Reset

---

## ✨ What This Launcher Does

- Launches local maintenance tools
- Does NOT perform any system changes itself
- Does NOT modify files, registry, or network
- No telemetry
- No background services

---

## ⚠️ Important Security Notice

This launcher is built using **PowerShell** and packaged as an EXE.

Some antivirus software may flag the EXE as suspicious due to heuristic detection.
This is a **false positive**.

The launcher itself:
- ❌ Does not clean files
- ❌ Does not reset network
- ❌ Does not run in background

It only launches other tools **when the user clicks a button**.

---

## ▶ Usage

### Option 1: Run EXE
1. Right-click `WTLauncher.exe`
2. Select **Run as administrator** (only if launched tools require it)

### Option 2: Run PowerShell Script (Direct)

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
irm https://raw.githubusercontent.com/F3aarLeSS/WindowsToolsLauncher/main/WinToolsLauncher.ps1 | iex
