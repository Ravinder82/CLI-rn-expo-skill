# rn-expo-skill ⚡

> **React Native + Expo App Builder** — A production-ready, 9-phase AI skill for building
> beautiful, App Store-approved mobile apps. Works with Claude, Cursor, Windsurf, GitHub Copilot,
> Continue.dev, Zed, OpenAI Codex, Antigravity, Tembo, and more.

---

## Install — One Command

### Auto-detect your IDE (recommended)

```bash
# Mac / Linux
curl -fsSL https://raw.githubusercontent.com/YOUR_USER/rn-expo-skill/main/install.sh | bash
```

```powershell
# Windows (PowerShell)
irm https://raw.githubusercontent.com/YOUR_USER/rn-expo-skill/main/install.ps1 | iex
```

```bash
# Any OS with Node.js
npx rn-expo-skill
```

---

## Install — Pick Your IDE

### 🖱 Cursor
```bash
npx rn-expo-skill --cursor
# OR
bash install.sh --cursor
```
Installs to: `.cursor/rules/react-native-expo-app-builder.mdc`

---

### 🌊 Windsurf (Codeium)
```bash
npx rn-expo-skill --windsurf
# OR
bash install.sh --windsurf
```
Installs to: `.windsurf/rules/react-native-expo-app-builder.md`

---

### 🤖 Claude Code — Project Level
```bash
npx rn-expo-skill --claude
# OR
bash install.sh --claude
```
Installs to: `.claude/skills/react-native-expo-app-builder/SKILL.md`

---

### 🌍 Claude Code — Global (all projects)
```bash
npx rn-expo-skill --claude-global
# OR
bash install.sh --claude-global
```
Installs to: `~/.claude/skills/react-native-expo-app-builder/SKILL.md`

---

### 🐙 GitHub Copilot
```bash
npx rn-expo-skill --copilot
# OR
bash install.sh --copilot
```
Appends to: `.github/copilot-instructions.md`
> Commit the file to your repo — Copilot picks it up automatically.

---

### 🔁 Continue.dev
```bash
npx rn-expo-skill --continue
# OR
bash install.sh --continue
```
Installs to: `.continue/rules/react-native-expo-app-builder.md`

---

### ⚡ Zed AI
```bash
npx rn-expo-skill --zed
# OR
bash install.sh --zed
```
Installs to: `.zed/react-native-expo-app-builder.md`

---

### 🧠 OpenAI Codex CLI
```bash
npx rn-expo-skill --codex
# OR
bash install.sh --codex
```
Installs to: `.codex/react-native-expo-app-builder.md`

---

### 📄 Plain Markdown (Antigravity, Tembo, ChatGPT, Gemini, any LLM)
```bash
npx rn-expo-skill --plain
# OR
bash install.sh --plain
```
Installs to: `.ai-skills/react-native-expo-app-builder.md`

> Then paste the content into your tool's system prompt, Project Instructions,
> or custom context window.

---

### 🚀 Install for ALL detected IDEs at once
```bash
npx rn-expo-skill --all
# OR
bash install.sh --all
```

---

## All Flags

| Flag | Target |
|---|---|
| *(no flag)* | Auto-detect IDE |
| `--cursor` | Cursor IDE |
| `--windsurf` | Windsurf / Codeium |
| `--claude` | Claude Code (project) |
| `--claude-global` | Claude Code (global) |
| `--copilot` | GitHub Copilot |
| `--continue` | Continue.dev |
| `--zed` | Zed AI |
| `--codex` | OpenAI Codex CLI |
| `--plain` | Plain .md (any tool) |
| `--all` | All detected IDEs |
| `--list` | Show all options |

---

## What's Inside — 9 Phases

| Phase | What it covers |
|---|---|
| **1 · Setup** | Expo scaffold, all deps, tsconfig, EAS init |
| **2 · Architecture** | Zustand, TanStack Query, NativeWind, folder structure, ESLint |
| **3 · Design System** | Mascot workflow, color tokens, component build order |
| **4 · App Shell** | Header, Settings screen, all compliance links + legal doc templates |
| **5 · Navigation** | Expo Router, custom animated tab bar, Reanimated recipes |
| **6 · Firebase Auth** | Email, Google, Apple Sign-In, account deletion cascade |
| **7 · Payments** | RevenueCat IAP (iOS), Stripe, Razorpay, UPI, paywall compliance |
| **8 · Onboarding** | Splash, slides, permissions, AsyncStorage gate |
| **9 · Production** | EAS build, App Store checklist, rejection prevention |

---

## Manual Upload (Claude.ai, Antigravity, Tembo)

For platforms without a CLI, use the single-file export:

1. Download `react-native-expo-app-builder-SINGLE-FILE.md`
2. **Claude.ai** → Open a Project → Project Instructions → paste content
3. **Antigravity** → Settings → System Prompt → paste content
4. **Tembo** → Agent Configuration → Context → paste content

---

## Publish to npm

```bash
# First time
npm login
npm publish

# Updates
npm version patch   # or minor / major
npm publish
```

After publishing, the command works globally:
```bash
npx rn-expo-skill           # always fetches latest
npx rn-expo-skill@1.0.0    # pin to version
```

---

## Host on GitHub (for curl install)

1. Push this repo to GitHub
2. Update `YOUR_GITHUB_USER` in `install.sh`, `install.ps1`, and `install.js`
3. Tag a release: `git tag v1.0.0 && git push --tags`
4. The one-liner now works:

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USER/rn-expo-skill/main/install.sh | bash
```

---

## Requirements

- **Node.js** 18+ (for `npx rn-expo-skill`)
- **bash** (for `install.sh` — Mac, Linux, WSL, Git Bash)
- **PowerShell** 5.1+ (for `install.ps1` — Windows)
- No other dependencies

---

## License

Apache License 2.0 
