#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════╗
# ║  rn-expo-skill — React Native + Expo App Builder Skill          ║
# ║  One-liner: curl -fsSL https://raw.githubusercontent.com/       ║
# ║    YOUR_USER/rn-expo-skill/main/install.sh | bash               ║
# ╚══════════════════════════════════════════════════════════════════╝
#
# USAGE:
#   bash install.sh                   # auto-detect IDE
#   bash install.sh --cursor          # Cursor
#   bash install.sh --windsurf        # Windsurf
#   bash install.sh --claude          # Claude Code (project)
#   bash install.sh --claude-global   # Claude Code (global)
#   bash install.sh --copilot         # GitHub Copilot
#   bash install.sh --continue        # Continue.dev
#   bash install.sh --zed             # Zed AI
#   bash install.sh --codex           # OpenAI Codex CLI
#   bash install.sh --plain           # Plain .md (any tool)
#   bash install.sh --all             # Install for ALL detected IDEs
#   bash install.sh --list            # Show all options

set -euo pipefail

# ─── COLORS ────────────────────────────────────────────────────────
RESET='\033[0m'; BOLD='\033[1m'; DIM='\033[2m'
GREEN='\033[32m'; CYAN='\033[36m'; YELLOW='\033[33m'
RED='\033[31m'; BLUE='\033[34m'; MAGENTA='\033[35m'

ok()   { echo -e "${GREEN}✅ $1${RESET}"; }
info() { echo -e "${CYAN}ℹ  $1${RESET}"; }
warn() { echo -e "${YELLOW}⚠  $1${RESET}"; }
fail() { echo -e "${RED}✖  $1${RESET}"; exit 1; }
step() { echo -e "${BLUE}→  $1${RESET}"; }
dim()  { echo -e "${DIM}   $1${RESET}"; }
head() { echo -e "\n${BOLD}${MAGENTA}$1${RESET}\n"; }

# ─── CONFIG ────────────────────────────────────────────────────────
SKILL_NAME="react-native-expo-app-builder"
SKILL_VERSION="1.0.0"
GITHUB_RAW="https://raw.githubusercontent.com/YOUR_GITHUB_USER/rn-expo-skill/main/skill/SKILL.md"
CWD="$(pwd)"
HOME_DIR="$HOME"
TARGET=""
INSTALL_ALL=false

# ─── BANNER ────────────────────────────────────────────────────────
print_banner() {
  echo -e "
${BOLD}${MAGENTA}╔══════════════════════════════════════════════════════╗
║   ⚡  React Native + Expo App Builder  —  Skill v${SKILL_VERSION}  ║
╚══════════════════════════════════════════════════════╝${RESET}
"
}

# ─── DETECT ────────────────────────────────────────────────────────
detect_ide() {
  DETECTED=()

  [[ -d "$CWD/.cursor" || -f "$CWD/.cursorrules" ]]                  && DETECTED+=("cursor")
  [[ -d "$CWD/.windsurf" || -f "$CWD/.windsurfrules" ]]              && DETECTED+=("windsurf")
  [[ -d "$CWD/.claude" ]] || command -v claude &>/dev/null            && DETECTED+=("claude")
  [[ -d "$CWD/.github" || -f "$CWD/.github/copilot-instructions.md" ]] && DETECTED+=("copilot")
  [[ -d "$CWD/.continue" ]]                                           && DETECTED+=("continue")
  [[ -d "$CWD/.zed" ]]                                                && DETECTED+=("zed")
  command -v codex &>/dev/null                                        && DETECTED+=("codex")
}

# ─── LOAD SKILL CONTENT ────────────────────────────────────────────
SKILL_CONTENT=""

load_skill() {
  # 1. Try local bundled file (if running from npm package)
  LOCAL_BUNDLED="$(dirname "$0")/skill/SKILL.md"
  if [[ -f "$LOCAL_BUNDLED" ]]; then
    SKILL_CONTENT=$(cat "$LOCAL_BUNDLED")
    ok "Skill loaded from package."
    return
  fi

  # 2. Try local single-file in CWD
  LOCAL_SINGLE="$CWD/react-native-expo-app-builder-SINGLE-FILE.md"
  if [[ -f "$LOCAL_SINGLE" ]]; then
    SKILL_CONTENT=$(cat "$LOCAL_SINGLE")
    ok "Skill loaded from local file."
    return
  fi

  # 3. Try fetching from GitHub
  if command -v curl &>/dev/null; then
    step "Fetching skill from GitHub..."
    if HTTP_CODE=$(curl -o /tmp/rn-expo-skill.md -w "%{http_code}" -fsSL "$GITHUB_RAW" 2>/dev/null); then
      if [[ "$HTTP_CODE" == "200" ]]; then
        SKILL_CONTENT=$(cat /tmp/rn-expo-skill.md)
        ok "Skill fetched from GitHub."
        return
      fi
    fi
    warn "GitHub fetch failed (HTTP $HTTP_CODE) — using embedded minimal version."
  fi

  # 4. Embedded minimal fallback (always works, no network needed)
  SKILL_CONTENT=$(embedded_skill)
  warn "Using embedded minimal version. For full content, host on GitHub first."
}

# ─── EMBEDDED FALLBACK ─────────────────────────────────────────────
embedded_skill() {
cat << 'EMBEDDED'
---
name: react-native-expo-app-builder
description: >
  End-to-end blueprint for building production-ready, App Store-approved
  React Native + Expo apps. Covers all 9 phases: Setup, Architecture,
  Design System, App Shell, Navigation, Firebase Auth, Payments
  (IAP/Stripe/Razorpay/UPI), Onboarding, and Production Build.
  Trigger on: "React Native", "Expo", "mobile app", "app store",
  "Firebase auth", "onboarding", "EAS build", "Stripe", "IAP".
version: 1.0.0
---

# React Native + Expo — 9-Phase Build System

## Phase 1 · Setup
```bash
npx create-expo-app@latest MyApp --template blank-typescript
npx expo install expo-router react-native-reanimated react-native-gesture-handler
npx expo install @react-native-async-storage/async-storage expo-secure-store
npm install zustand @tanstack/react-query nativewind firebase
eas init && eas build:configure
```

## Phase 2 · Architecture
Stack: Zustand + TanStack Query + NativeWind + Expo Router + TypeScript strict
Folder: app/ components/ hooks/ stores/ services/ utils/ constants/ types/ assets/

## Phase 3 · Design System
1. Design Mascot (Figma/Stitch) → export SVG + Lottie
2. Derive color tokens (light/dark) from mascot palette
3. Build components: Button → Input → Card → Badge → Modal → Toast

## Phase 4 · App Shell
Header: Logo | Notifications | Settings gear
Settings: Account · Preferences · Support · Legal · Store · Sign Out · Delete Account
Legal URLs REQUIRED: Privacy Policy · Terms · EULA · Cookie Policy
Run: node scripts/validate-legal-urls.js before every submission

## Phase 5 · Navigation + Animations
Expo Router file-based navigation · Custom Reanimated tab bar
Animations: FadeInDown entry · Lottie mascot · Gesture-driven dismiss · Skeleton loading

## Phase 6 · Firebase Auth
Providers: Email/Password · Google Sign-In · Apple Sign-In (MANDATORY for iOS)
Storage: expo-secure-store (NEVER AsyncStorage for tokens)
Must implement: full account deletion cascade (Auth + Firestore + Storage)

## Phase 7 · Payments
iOS: RevenueCat + Apple IAP (ALL digital goods MUST use IAP on iOS)
Android: Stripe (global) · Razorpay + UPI (India)
Paywall must show: price · duration · auto-renew · cancel instructions · legal links

## Phase 8 · Onboarding
AsyncStorage key '@onboarding_complete_v1'
Flow: Splash → Slide 1 → Slide 2 → Permissions → Auth gate
Mascot Lottie on every slide · Skip always available

## Phase 9 · Production
eas build --profile production --platform ios --auto-submit
eas build --profile production --platform android --auto-submit
App Store first · Play Store after iOS approval

## Golden Rules
- Apple Sign-In: mandatory if ANY social login exists
- Delete Account: must work end-to-end (App Store requirement)
- All legal URLs live before submission (run validator script)
- Demo credentials MUST be in Review Notes
- expo-secure-store for sensitive data, NEVER AsyncStorage
- iOS first, Android second
EMBEDDED
}

# ─── INSTALLERS ────────────────────────────────────────────────────
install_cursor() {
  local DIR="$CWD/.cursor/rules"
  mkdir -p "$DIR"
  local DEST="$DIR/${SKILL_NAME}.mdc"
  cat > "$DEST" << FRONTMATTER
---
description: React Native + Expo App Builder — full 9-phase production skill
globs: ["**/*.tsx", "**/*.ts", "app.json", "eas.json", "*.config.js"]
alwaysApply: false
---

FRONTMATTER
  echo "$SKILL_CONTENT" >> "$DEST"
  ok "Cursor → $DEST"
  dim "Restart Cursor or Cmd+Shift+P → Reload Window"
}

install_windsurf() {
  local DIR="$CWD/.windsurf/rules"
  mkdir -p "$DIR"
  local DEST="$DIR/${SKILL_NAME}.md"
  echo "$SKILL_CONTENT" > "$DEST"
  ok "Windsurf → $DEST"
  dim "Restart Windsurf to activate"
}

install_claude() {
  local DIR="$CWD/.claude/skills/${SKILL_NAME}"
  mkdir -p "$DIR"
  local DEST="$DIR/SKILL.md"
  echo "$SKILL_CONTENT" > "$DEST"
  ok "Claude Code (project) → $DEST"
  dim "Active in Claude Code when opened in this directory"
}

install_claude_global() {
  local DIR="$HOME_DIR/.claude/skills/${SKILL_NAME}"
  mkdir -p "$DIR"
  local DEST="$DIR/SKILL.md"
  echo "$SKILL_CONTENT" > "$DEST"
  ok "Claude Code (global) → $DEST"
  dim "Active in ALL Claude Code projects on this machine"
}

install_copilot() {
  local DIR="$CWD/.github"
  mkdir -p "$DIR"
  local DEST="$DIR/copilot-instructions.md"
  local MARKER="<!-- rn-expo-skill:start -->"
  local END_MARKER="<!-- rn-expo-skill:end -->"
  if [[ -f "$DEST" ]] && grep -q "$MARKER" "$DEST"; then
    # Update existing block
    python3 -c "
import re, sys
content = open('$DEST').read()
new_block = '''$MARKER
$(echo "$SKILL_CONTENT" | head -100)
$END_MARKER'''
result = re.sub(r'$MARKER.*?$END_MARKER', new_block, content, flags=re.DOTALL)
open('$DEST', 'w').write(result)
" 2>/dev/null || {
      echo -e "\n\n${MARKER}\n${SKILL_CONTENT}\n${END_MARKER}" >> "$DEST"
    }
    warn "Updated existing Copilot instructions."
  else
    echo -e "\n\n${MARKER}\n${SKILL_CONTENT}\n${END_MARKER}" >> "$DEST"
  fi
  ok "Copilot → $DEST"
  dim "Commit .github/copilot-instructions.md to your repo"
}

install_continue() {
  local DIR="$CWD/.continue/rules"
  mkdir -p "$DIR"
  local DEST="$DIR/${SKILL_NAME}.md"
  echo "$SKILL_CONTENT" > "$DEST"
  ok "Continue.dev → $DEST"
  dim "Reload Continue: Cmd+Shift+P → Continue: Reload"
}

install_zed() {
  local DIR="$CWD/.zed"
  mkdir -p "$DIR"
  local DEST="$DIR/${SKILL_NAME}.md"
  echo "$SKILL_CONTENT" > "$DEST"
  ok "Zed AI → $DEST"
  dim "Restart Zed to activate"
}

install_codex() {
  local DIR="$CWD/.codex"
  mkdir -p "$DIR"
  local DEST="$DIR/${SKILL_NAME}.md"
  echo "$SKILL_CONTENT" > "$DEST"
  ok "Codex CLI → $DEST"
  dim "Use: codex --context .codex/ \"your prompt\""
}

install_plain() {
  local DIR="$CWD/.ai-skills"
  mkdir -p "$DIR"
  local DEST="$DIR/${SKILL_NAME}.md"
  echo "$SKILL_CONTENT" > "$DEST"
  ok "Plain Markdown → $DEST"
  dim "Paste content into any AI tool's system prompt or context window"
}

# ─── DISPATCH ──────────────────────────────────────────────────────
run_install() {
  local platform="$1"
  case "$platform" in
    cursor)        install_cursor ;;
    windsurf)      install_windsurf ;;
    claude)        install_claude ;;
    claude-global) install_claude_global ;;
    copilot)       install_copilot ;;
    continue)      install_continue ;;
    zed)           install_zed ;;
    codex)         install_codex ;;
    plain)         install_plain ;;
    *)             fail "Unknown platform: $platform. Run --list to see options." ;;
  esac
}

# ─── HELP ──────────────────────────────────────────────────────────
print_list() {
  head "Supported IDEs / Platforms:"
  echo -e "  ${CYAN}--cursor${RESET}          Cursor (creates .cursor/rules/*.mdc)"
  echo -e "  ${CYAN}--windsurf${RESET}        Windsurf (creates .windsurf/rules/*.md)"
  echo -e "  ${CYAN}--claude${RESET}          Claude Code — project level (.claude/skills/)"
  echo -e "  ${CYAN}--claude-global${RESET}   Claude Code — global (~/.claude/skills/)"
  echo -e "  ${CYAN}--copilot${RESET}         GitHub Copilot (.github/copilot-instructions.md)"
  echo -e "  ${CYAN}--continue${RESET}        Continue.dev (.continue/rules/)"
  echo -e "  ${CYAN}--zed${RESET}             Zed AI (.zed/)"
  echo -e "  ${CYAN}--codex${RESET}           OpenAI Codex CLI (.codex/)"
  echo -e "  ${CYAN}--plain${RESET}           Plain .md — any LLM tool (.ai-skills/)"
  echo -e "  ${CYAN}--all${RESET}             Install for ALL detected IDEs"
  echo -e "  ${CYAN}--list${RESET}            Show this list"
  echo ""
}

# ─── PARSE ARGS ────────────────────────────────────────────────────
for arg in "$@"; do
  case "$arg" in
    --list|-l)         print_banner; print_list; exit 0 ;;
    --help|-h)         print_banner; print_list; exit 0 ;;
    --all)             INSTALL_ALL=true ;;
    --cursor)          TARGET="cursor" ;;
    --windsurf)        TARGET="windsurf" ;;
    --claude)          TARGET="claude" ;;
    --claude-global)   TARGET="claude-global" ;;
    --copilot)         TARGET="copilot" ;;
    --continue)        TARGET="continue" ;;
    --zed)             TARGET="zed" ;;
    --codex)           TARGET="codex" ;;
    --plain)           TARGET="plain" ;;
    *)                 warn "Unknown flag: $arg"; print_list; exit 1 ;;
  esac
done

# ─── RUN ───────────────────────────────────────────────────────────
print_banner
load_skill
detect_ide

if [[ "$INSTALL_ALL" == true ]]; then
  head "Installing for ALL detected IDEs..."
  if [[ ${#DETECTED[@]} -eq 0 ]]; then
    warn "No IDEs detected. Installing as plain markdown."
    run_install "plain"
  else
    for ide in "${DETECTED[@]}"; do
      run_install "$ide"
    done
  fi

elif [[ -n "$TARGET" ]]; then
  head "Installing for: $TARGET"
  run_install "$TARGET"

else
  # Auto-detect
  step "Auto-detecting IDE..."
  if [[ ${#DETECTED[@]} -gt 0 ]]; then
    TARGET="${DETECTED[0]}"
    info "Detected: ${BOLD}$TARGET${RESET}"
    run_install "$TARGET"
  else
    warn "No IDE detected. Installing as plain markdown."
    run_install "plain"
  fi
fi

echo ""
ok "Done! Skill '${SKILL_NAME}' v${SKILL_VERSION} installed."
echo -e "${DIM}Run with --list to see all platform options.${RESET}\n"
