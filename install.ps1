# ╔══════════════════════════════════════════════════════════════════╗
# ║  rn-expo-skill — React Native + Expo App Builder Skill          ║
# ║  PowerShell Installer (Windows / cross-platform pwsh)           ║
# ║                                                                  ║
# ║  One-liner (PowerShell):                                         ║
# ║  irm https://raw.githubusercontent.com/YOUR_USER/               ║
# ║    rn-expo-skill/main/install.ps1 | iex                         ║
# ╚══════════════════════════════════════════════════════════════════╝
#
# USAGE:
#   .\install.ps1                    # auto-detect IDE
#   .\install.ps1 -Platform cursor
#   .\install.ps1 -Platform windsurf
#   .\install.ps1 -Platform claude
#   .\install.ps1 -Platform claude-global
#   .\install.ps1 -Platform copilot
#   .\install.ps1 -Platform continue
#   .\install.ps1 -Platform zed
#   .\install.ps1 -Platform codex
#   .\install.ps1 -Platform plain
#   .\install.ps1 -All              # install for ALL detected IDEs
#   .\install.ps1 -List             # show all options

param(
    [string]$Platform = "",
    [switch]$All,
    [switch]$List,
    [switch]$Help
)

# ─── CONFIG ────────────────────────────────────────────────────────
$SkillName    = "react-native-expo-app-builder"
$SkillVersion = "1.0.0"
$GithubRaw    = "https://raw.githubusercontent.com/YOUR_GITHUB_USER/rn-expo-skill/main/skill/SKILL.md"
$Cwd          = (Get-Location).Path
$HomeDir      = $env:USERPROFILE

# ─── COLORS ────────────────────────────────────────────────────────
function Write-Ok    { param($m) Write-Host "✅ $m" -ForegroundColor Green }
function Write-Info  { param($m) Write-Host "ℹ  $m" -ForegroundColor Cyan }
function Write-Warn  { param($m) Write-Host "⚠  $m" -ForegroundColor Yellow }
function Write-Fail  { param($m) Write-Host "✖  $m" -ForegroundColor Red; exit 1 }
function Write-Step  { param($m) Write-Host "→  $m" -ForegroundColor Blue }
function Write-Dim   { param($m) Write-Host "   $m" -ForegroundColor DarkGray }
function Write-Head  { param($m) Write-Host "`n$m`n" -ForegroundColor Magenta }

# ─── BANNER ────────────────────────────────────────────────────────
function Show-Banner {
    Write-Host @"

╔══════════════════════════════════════════════════════╗
║   ⚡  React Native + Expo App Builder  —  Skill v$SkillVersion  ║
╚══════════════════════════════════════════════════════╝

"@ -ForegroundColor Magenta
}

# ─── SKILL CONTENT ─────────────────────────────────────────────────
$SkillContent = ""

function Get-SkillContent {
    # 1. Try local bundled file
    $local = Join-Path (Split-Path $MyInvocation.ScriptName) "skill\SKILL.md"
    if (Test-Path $local) {
        $script:SkillContent = Get-Content $local -Raw
        Write-Ok "Skill loaded from package."
        return
    }

    # 2. Try local single-file in CWD
    $localSingle = Join-Path $Cwd "react-native-expo-app-builder-SINGLE-FILE.md"
    if (Test-Path $localSingle) {
        $script:SkillContent = Get-Content $localSingle -Raw
        Write-Ok "Skill loaded from local file."
        return
    }

    # 3. Fetch from GitHub
    Write-Step "Fetching skill from GitHub..."
    try {
        $response = Invoke-WebRequest -Uri $GithubRaw -UseBasicParsing -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            $script:SkillContent = $response.Content
            Write-Ok "Skill fetched from GitHub."
            return
        }
    } catch {
        Write-Warn "GitHub fetch failed — using embedded minimal version."
    }

    # 4. Embedded fallback
    $script:SkillContent = Get-EmbeddedSkill
    Write-Warn "Using embedded minimal version."
}

function Get-EmbeddedSkill {
    return @"
---
name: react-native-expo-app-builder
description: >
  End-to-end blueprint for building production-ready React Native + Expo apps.
  Covers all 9 phases: Setup, Architecture, Design System, App Shell,
  Navigation, Firebase Auth, Payments (IAP/Stripe/Razorpay/UPI),
  Onboarding, and Production Build.
version: $SkillVersion
---

# React Native + Expo — 9-Phase Build System

## Phase 1 Setup
npx create-expo-app@latest MyApp --template blank-typescript
npx expo install expo-router react-native-reanimated react-native-gesture-handler
npm install zustand @tanstack/react-query nativewind firebase
eas init && eas build:configure

## Phase 2 Architecture
Stack: Zustand + TanStack Query + NativeWind + Expo Router + TypeScript strict

## Phase 3 Design
Mascot (Figma/Stitch) → Color tokens (light/dark) → Component library

## Phase 4 App Shell
Header: Logo | Notifications | Settings
Settings: Account, Preferences, Support, Legal, Store, Delete Account
Legal: Privacy Policy, Terms, EULA, Cookie Policy (all URLs must be live)

## Phase 5 Navigation
Expo Router file-based · Custom Reanimated tab bar · Lottie animations

## Phase 6 Auth
Firebase: Email · Google · Apple Sign-In (MANDATORY iOS)
Secure: expo-secure-store · Full account deletion cascade

## Phase 7 Payments
iOS: RevenueCat + Apple IAP (digital goods MUST use IAP)
Android: Stripe · Razorpay + UPI (India)

## Phase 8 Onboarding
Splash → Slides → Permissions → Auth gate
AsyncStorage: '@onboarding_complete_v1'

## Phase 9 Production
eas build --profile production --platform ios --auto-submit
eas build --profile production --platform android --auto-submit

## Golden Rules
- Apple Sign-In mandatory if ANY social login exists
- Delete Account must work end-to-end
- All legal URLs live before submission
- Demo credentials in Review Notes
- expo-secure-store for sensitive data, NEVER AsyncStorage
"@
}

# ─── DETECT ────────────────────────────────────────────────────────
function Get-DetectedIDEs {
    $detected = @()
    if ((Test-Path "$Cwd\.cursor") -or (Test-Path "$Cwd\.cursorrules"))                              { $detected += "cursor" }
    if ((Test-Path "$Cwd\.windsurf") -or (Test-Path "$Cwd\.windsurfrules"))                          { $detected += "windsurf" }
    if ((Test-Path "$Cwd\.claude") -or (Get-Command claude -ErrorAction SilentlyContinue))            { $detected += "claude" }
    if ((Test-Path "$Cwd\.github") -or (Test-Path "$Cwd\.github\copilot-instructions.md"))           { $detected += "copilot" }
    if (Test-Path "$Cwd\.continue")                                                                   { $detected += "continue" }
    if (Test-Path "$Cwd\.zed")                                                                        { $detected += "zed" }
    if (Get-Command codex -ErrorAction SilentlyContinue)                                              { $detected += "codex" }
    return $detected
}

# ─── INSTALLERS ────────────────────────────────────────────────────
function Install-ForPlatform {
    param([string]$Plat)

    switch ($Plat) {
        "cursor" {
            $dir  = "$Cwd\.cursor\rules"
            $dest = "$dir\$SkillName.mdc"
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
            $header = "---`ndescription: React Native + Expo App Builder — 9-phase production skill`nglobs: [`"**/*.tsx`", `"**/*.ts`", `"app.json`"]`nalwaysApply: false`n---`n`n"
            Set-Content -Path $dest -Value ($header + $SkillContent)
            Write-Ok "Cursor → $dest"
            Write-Dim "Restart Cursor or Ctrl+Shift+P → Reload Window"
        }
        "windsurf" {
            $dir  = "$Cwd\.windsurf\rules"
            $dest = "$dir\$SkillName.md"
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
            Set-Content -Path $dest -Value $SkillContent
            Write-Ok "Windsurf → $dest"
            Write-Dim "Restart Windsurf to activate"
        }
        "claude" {
            $dir  = "$Cwd\.claude\skills\$SkillName"
            $dest = "$dir\SKILL.md"
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
            Set-Content -Path $dest -Value $SkillContent
            Write-Ok "Claude Code (project) → $dest"
            Write-Dim "Active when Claude Code is opened in this directory"
        }
        "claude-global" {
            $dir  = "$HomeDir\.claude\skills\$SkillName"
            $dest = "$dir\SKILL.md"
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
            Set-Content -Path $dest -Value $SkillContent
            Write-Ok "Claude Code (global) → $dest"
            Write-Dim "Active in ALL Claude Code projects on this machine"
        }
        "copilot" {
            $dir  = "$Cwd\.github"
            $dest = "$dir\copilot-instructions.md"
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
            $marker    = "<!-- rn-expo-skill:start -->"
            $endMarker = "<!-- rn-expo-skill:end -->"
            $block     = "$marker`n$SkillContent`n$endMarker"
            if ((Test-Path $dest) -and (Get-Content $dest -Raw) -match [regex]::Escape($marker)) {
                $existing = Get-Content $dest -Raw
                $existing = $existing -replace "(?s)$([regex]::Escape($marker)).*?$([regex]::Escape($endMarker))", $block
                Set-Content -Path $dest -Value $existing
                Write-Warn "Updated existing Copilot instructions."
            } else {
                Add-Content -Path $dest -Value "`n`n$block"
            }
            Write-Ok "Copilot → $dest"
            Write-Dim "Commit .github\copilot-instructions.md to your repo"
        }
        "continue" {
            $dir  = "$Cwd\.continue\rules"
            $dest = "$dir\$SkillName.md"
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
            Set-Content -Path $dest -Value $SkillContent
            Write-Ok "Continue.dev → $dest"
            Write-Dim "Reload: Ctrl+Shift+P → Continue: Reload"
        }
        "zed" {
            $dir  = "$Cwd\.zed"
            $dest = "$dir\$SkillName.md"
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
            Set-Content -Path $dest -Value $SkillContent
            Write-Ok "Zed AI → $dest"
            Write-Dim "Restart Zed to activate"
        }
        "codex" {
            $dir  = "$Cwd\.codex"
            $dest = "$dir\$SkillName.md"
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
            Set-Content -Path $dest -Value $SkillContent
            Write-Ok "Codex CLI → $dest"
            Write-Dim "Use: codex --context .codex\ `"your prompt`""
        }
        "plain" {
            $dir  = "$Cwd\.ai-skills"
            $dest = "$dir\$SkillName.md"
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
            Set-Content -Path $dest -Value $SkillContent
            Write-Ok "Plain Markdown → $dest"
            Write-Dim "Paste into any AI tool's system prompt or context"
        }
        default {
            Write-Fail "Unknown platform: $Plat. Run -List to see options."
        }
    }
}

# ─── LIST ──────────────────────────────────────────────────────────
function Show-List {
    Write-Head "Supported IDEs / Platforms:"
    Write-Host "  -Platform cursor          Cursor (.cursor\rules\*.mdc)" -ForegroundColor Cyan
    Write-Host "  -Platform windsurf        Windsurf (.windsurf\rules\*.md)" -ForegroundColor Cyan
    Write-Host "  -Platform claude          Claude Code — project (.claude\skills\)" -ForegroundColor Cyan
    Write-Host "  -Platform claude-global   Claude Code — global (~\.claude\skills\)" -ForegroundColor Cyan
    Write-Host "  -Platform copilot         GitHub Copilot (.github\copilot-instructions.md)" -ForegroundColor Cyan
    Write-Host "  -Platform continue        Continue.dev (.continue\rules\)" -ForegroundColor Cyan
    Write-Host "  -Platform zed             Zed AI (.zed\)" -ForegroundColor Cyan
    Write-Host "  -Platform codex           OpenAI Codex CLI (.codex\)" -ForegroundColor Cyan
    Write-Host "  -Platform plain           Plain .md (.ai-skills\)" -ForegroundColor Cyan
    Write-Host "  -All                      Install for ALL detected IDEs" -ForegroundColor Cyan
    Write-Host ""
}

# ─── MAIN ──────────────────────────────────────────────────────────
Show-Banner
if ($List -or $Help) { Show-List; exit 0 }

Get-SkillContent

if ($All) {
    Write-Head "Installing for ALL detected IDEs..."
    $detected = Get-DetectedIDEs
    if ($detected.Count -eq 0) {
        Write-Warn "No IDEs detected. Installing as plain markdown."
        Install-ForPlatform "plain"
    } else {
        foreach ($ide in $detected) { Install-ForPlatform $ide }
    }
} elseif ($Platform -ne "") {
    Write-Head "Installing for: $Platform"
    Install-ForPlatform $Platform
} else {
    Write-Step "Auto-detecting IDE..."
    $detected = Get-DetectedIDEs
    if ($detected.Count -gt 0) {
        $target = $detected[0]
        Write-Info "Detected: $target"
        Install-ForPlatform $target
    } else {
        Write-Warn "No IDE detected. Installing as plain markdown."
        Install-ForPlatform "plain"
    }
}

Write-Host ""
Write-Ok "Done! Skill '$SkillName' v$SkillVersion installed."
Write-Dim "Run with -List to see all platform options."
Write-Host ""
