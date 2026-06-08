#!/usr/bin/env node
/**
 * rn-expo-skill — React Native + Expo App Builder Skill Installer
 * 
 * INSTALL COMMANDS:
 *   npx rn-expo-skill                   Auto-detect IDE and install
 *   npx rn-expo-skill --cursor          Install for Cursor
 *   npx rn-expo-skill --windsurf        Install for Windsurf
 *   npx rn-expo-skill --claude          Install for Claude Code (project-level)
 *   npx rn-expo-skill --claude-global   Install for Claude Code (global, all projects)
 *   npx rn-expo-skill --copilot         Install for GitHub Copilot
 *   npx rn-expo-skill --continue        Install for Continue.dev
 *   npx rn-expo-skill --zed             Install for Zed AI
 *   npx rn-expo-skill --codex           Install for OpenAI Codex / Codex CLI
 *   npx rn-expo-skill --plain           Install as plain .md in .ai-skills/ folder
 *   npx rn-expo-skill --list            List all supported IDEs
 *
 * Publish to npm:  npm publish (from this directory)
 * GitHub raw URL:  https://raw.githubusercontent.com/YOUR_USER/rn-expo-skill/main/install.js
 */

const fs   = require('fs');
const path = require('path');
const os   = require('os');
const https = require('https');

// ─── CONFIG ────────────────────────────────────────────────────────────────

const SKILL_NAME    = 'react-native-expo-app-builder';
const SKILL_VERSION = '1.0.0';

// Where to fetch the skill from (update after you push to GitHub)
const GITHUB_RAW_BASE =
  'https://raw.githubusercontent.com/YOUR_GITHUB_USER/rn-expo-skill/main/skill';

// ─── COLORS ────────────────────────────────────────────────────────────────

const c = {
  reset:  '\x1b[0m',
  bold:   '\x1b[1m',
  dim:    '\x1b[2m',
  green:  '\x1b[32m',
  cyan:   '\x1b[36m',
  yellow: '\x1b[33m',
  red:    '\x1b[31m',
  blue:   '\x1b[34m',
  magenta:'\x1b[35m',
  white:  '\x1b[37m',
};

const ok    = (msg) => console.log(`${c.green}✅ ${msg}${c.reset}`);
const info  = (msg) => console.log(`${c.cyan}ℹ  ${msg}${c.reset}`);
const warn  = (msg) => console.log(`${c.yellow}⚠  ${msg}${c.reset}`);
const err   = (msg) => console.log(`${c.red}✖  ${msg}${c.reset}`);
const head  = (msg) => console.log(`\n${c.bold}${c.magenta}${msg}${c.reset}\n`);
const step  = (msg) => console.log(`${c.blue}→  ${msg}${c.reset}`);
const dim   = (msg) => console.log(`${c.dim}   ${msg}${c.reset}`);

// ─── PLATFORM DEFINITIONS ──────────────────────────────────────────────────

/**
 * Each platform defines:
 *   detect()   → boolean  : Is this IDE active in current project?
 *   install()  → void     : Install the skill
 *   label      → string   : Human-readable name
 *   flag       → string   : CLI flag (without --)
 */
const PLATFORMS = {

  cursor: {
    label: 'Cursor',
    flag: 'cursor',
    detect: (cwd) =>
      fs.existsSync(path.join(cwd, '.cursor')) ||
      fs.existsSync(path.join(cwd, '.cursorrules')),
    install: (cwd, content) => {
      const dir = path.join(cwd, '.cursor', 'rules');
      fs.mkdirSync(dir, { recursive: true });
      const dest = path.join(dir, `${SKILL_NAME}.mdc`);
      fs.writeFileSync(dest, formatForCursor(content));
      return dest;
    },
  },

  windsurf: {
    label: 'Windsurf (Codeium)',
    flag: 'windsurf',
    detect: (cwd) =>
      fs.existsSync(path.join(cwd, '.windsurf')) ||
      fs.existsSync(path.join(cwd, '.windsurfrules')),
    install: (cwd, content) => {
      const dir = path.join(cwd, '.windsurf', 'rules');
      fs.mkdirSync(dir, { recursive: true });
      const dest = path.join(dir, `${SKILL_NAME}.md`);
      fs.writeFileSync(dest, content);
      return dest;
    },
  },

  claude: {
    label: 'Claude Code (project-level)',
    flag: 'claude',
    detect: (cwd) =>
      fs.existsSync(path.join(cwd, '.claude')) ||
      commandExists('claude'),
    install: (cwd, content) => {
      const dir = path.join(cwd, '.claude', 'skills', SKILL_NAME);
      fs.mkdirSync(dir, { recursive: true });
      const dest = path.join(dir, 'SKILL.md');
      fs.writeFileSync(dest, content);
      return dest;
    },
  },

  'claude-global': {
    label: 'Claude Code (global — all projects)',
    flag: 'claude-global',
    detect: () => commandExists('claude'),
    install: (_cwd, content) => {
      const dir = path.join(os.homedir(), '.claude', 'skills', SKILL_NAME);
      fs.mkdirSync(dir, { recursive: true });
      const dest = path.join(dir, 'SKILL.md');
      fs.writeFileSync(dest, content);
      return dest;
    },
  },

  copilot: {
    label: 'GitHub Copilot',
    flag: 'copilot',
    detect: (cwd) =>
      fs.existsSync(path.join(cwd, '.github')) ||
      fs.existsSync(path.join(cwd, '.github', 'copilot-instructions.md')),
    install: (cwd, content) => {
      const dir = path.join(cwd, '.github');
      fs.mkdirSync(dir, { recursive: true });
      const dest = path.join(dir, 'copilot-instructions.md');
      const existing = fs.existsSync(dest) ? fs.readFileSync(dest, 'utf8') : '';
      const marker = `<!-- rn-expo-skill:start -->`;
      const endMarker = `<!-- rn-expo-skill:end -->`;
      const block = `${marker}\n${content}\n${endMarker}`;
      const updated = existing.includes(marker)
        ? existing.replace(new RegExp(`${marker}[\\s\\S]*?${endMarker}`), block)
        : `${existing}\n\n${block}`;
      fs.writeFileSync(dest, updated.trim());
      return dest;
    },
  },

  continue: {
    label: 'Continue.dev',
    flag: 'continue',
    detect: (cwd) => fs.existsSync(path.join(cwd, '.continue')),
    install: (cwd, content) => {
      const dir = path.join(cwd, '.continue', 'rules');
      fs.mkdirSync(dir, { recursive: true });
      const dest = path.join(dir, `${SKILL_NAME}.md`);
      fs.writeFileSync(dest, content);
      return dest;
    },
  },

  zed: {
    label: 'Zed AI',
    flag: 'zed',
    detect: (cwd) => fs.existsSync(path.join(cwd, '.zed')),
    install: (cwd, content) => {
      const dir = path.join(cwd, '.zed');
      fs.mkdirSync(dir, { recursive: true });
      const dest = path.join(dir, `${SKILL_NAME}.md`);
      fs.writeFileSync(dest, content);
      return dest;
    },
  },

  codex: {
    label: 'OpenAI Codex / Codex CLI',
    flag: 'codex',
    detect: () => commandExists('codex'),
    install: (cwd, content) => {
      const dir = path.join(cwd, '.codex');
      fs.mkdirSync(dir, { recursive: true });
      const dest = path.join(dir, `${SKILL_NAME}.md`);
      fs.writeFileSync(dest, content);
      return dest;
    },
  },

  plain: {
    label: 'Plain Markdown (any tool)',
    flag: 'plain',
    detect: () => false, // only triggered by explicit flag
    install: (cwd, content) => {
      const dir = path.join(cwd, '.ai-skills');
      fs.mkdirSync(dir, { recursive: true });
      const dest = path.join(dir, `${SKILL_NAME}.md`);
      fs.writeFileSync(dest, content);
      return dest;
    },
  },
};

// ─── HELPERS ───────────────────────────────────────────────────────────────

function commandExists(cmd) {
  try {
    const { execSync } = require('child_process');
    execSync(
      process.platform === 'win32' ? `where ${cmd}` : `which ${cmd}`,
      { stdio: 'ignore' }
    );
    return true;
  } catch { return false; }
}

function formatForCursor(content) {
  // Cursor .mdc files support frontmatter for rule metadata
  return `---
description: React Native + Expo App Builder — full 9-phase production skill
globs: ["**/*.tsx", "**/*.ts", "app.json", "eas.json", "*.config.js"]
alwaysApply: false
---

${content}`;
}

function printBanner() {
  console.log(`
${c.bold}${c.magenta}╔══════════════════════════════════════════════════════╗
║   ⚡  React Native + Expo App Builder  —  Skill v${SKILL_VERSION}  ║
╚══════════════════════════════════════════════════════╝${c.reset}
`);
}

function printList() {
  head('Supported IDEs / Platforms:');
  Object.values(PLATFORMS).forEach(p => {
    console.log(`  ${c.cyan}--${p.flag.padEnd(16)}${c.reset} ${p.label}`);
  });
  console.log(`\n  ${c.dim}--list             Show this list${c.reset}`);
  console.log(`  ${c.dim}--help             Show usage${c.reset}\n`);
}

function getSkillContent() {
  // 1. Try local bundled skill (if installed via npm package)
  const localPath = path.join(__dirname, 'skill', 'SKILL.md');
  if (fs.existsSync(localPath)) {
    return fs.readFileSync(localPath, 'utf8');
  }

  // 2. Try local single-file in CWD
  const cwdPath = path.join(process.cwd(), 'react-native-expo-app-builder-SINGLE-FILE.md');
  if (fs.existsSync(cwdPath)) {
    return fs.readFileSync(cwdPath, 'utf8');
  }

  // 3. Return embedded minimal version (always works, no network needed)
  return getEmbeddedSkill();
}

async function fetchSkillFromGitHub() {
  return new Promise((resolve, reject) => {
    const url = `${GITHUB_RAW_BASE}/SKILL.md`;
    https.get(url, { headers: { 'User-Agent': 'rn-expo-skill-installer' } }, (res) => {
      if (res.statusCode === 404) {
        reject(new Error('Skill not found on GitHub — using embedded version'));
        return;
      }
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => resolve(data));
    }).on('error', reject);
  });
}

function getEmbeddedSkill() {
  // Minimal embedded version — always available offline
  return `---
name: react-native-expo-app-builder
description: >
  End-to-end blueprint for building production-ready React Native + Expo apps.
  Covers all 9 phases: Setup, Architecture, Design System, App Shell, Navigation,
  Firebase Auth, Payments (IAP/Stripe/Razorpay), Onboarding, and Production Build.
  Triggers on: React Native, Expo app, mobile app build, app store submission,
  payment integration, Firebase auth, onboarding screens, EAS build.
version: ${SKILL_VERSION}
---

# React Native + Expo App Builder

**Full skill installed. Upgrade to the complete version:**
\`\`\`bash
npx rn-expo-skill --plain
\`\`\`

Or download from: https://github.com/YOUR_GITHUB_USER/rn-expo-skill

## Quick Reference — 9 Phases

1. **Setup**: \`npx create-expo-app@latest MyApp --template blank-typescript\`
2. **Architecture**: Zustand + TanStack Query + NativeWind + Expo Router
3. **Design**: Mascot → Color tokens → Component library (Figma/Stitch)
4. **App Shell**: Header, Settings, Privacy Policy, Terms, EULA, Delete Account
5. **Home + Nav**: Expo Router, custom animated tab bar, Reanimated animations
6. **Auth**: Firebase + Apple Sign-In (mandatory iOS) + Google Sign-In
7. **Payments**: RevenueCat/IAP (iOS) + Stripe/Razorpay/UPI (Android)
8. **Onboarding**: Splash → Slides → Permissions → Auth gate
9. **Production**: EAS Build → TestFlight → App Store → Play Store

## Golden Rules
- Apple Sign-In mandatory if ANY social login exists
- Delete Account must work end-to-end (App Store requirement)
- All legal URLs must be live before submission
- Demo credentials MUST be provided for review
- Never store sensitive data in AsyncStorage — use expo-secure-store
- iOS first, then Android
`;
}

// ─── MAIN ──────────────────────────────────────────────────────────────────

async function main() {
  printBanner();

  const args = process.argv.slice(2);
  const cwd  = process.cwd();

  // Handle meta flags
  if (args.includes('--list') || args.includes('-l')) { printList(); return; }
  if (args.includes('--help') || args.includes('-h')) {
    info('Usage: npx rn-expo-skill [--platform]');
    info('Run without flags to auto-detect your IDE.');
    printList();
    return;
  }

  // Resolve target platform
  let target = null;
  for (const [key, platform] of Object.entries(PLATFORMS)) {
    if (args.includes(`--${platform.flag}`)) {
      target = key;
      break;
    }
  }

  // Auto-detect if no flag given
  if (!target) {
    step('Auto-detecting your IDE/platform...');
    for (const [key, platform] of Object.entries(PLATFORMS)) {
      if (key === 'plain') continue;
      if (platform.detect(cwd)) {
        target = key;
        info(`Detected: ${c.bold}${platform.label}${c.reset}`);
        break;
      }
    }
    if (!target) {
      warn('No IDE detected — installing as plain markdown.');
      warn('Run with --list to see specific platform options.');
      target = 'plain';
    }
  }

  const platform = PLATFORMS[target];
  head(`Installing for: ${platform.label}`);

  // Load skill content
  step('Loading skill content...');
  let content;
  try {
    content = getSkillContent();
    ok('Skill content loaded.');
  } catch (e) {
    warn('Could not load full content — using embedded version.');
    content = getEmbeddedSkill();
  }

  // Install
  step(`Installing to your project at: ${c.bold}${cwd}${c.reset}`);
  try {
    const dest = platform.install(cwd, content);
    console.log('');
    ok(`Skill installed!`);
    dim(`Location: ${dest}`);
    console.log('');
    printNextSteps(target, dest);
  } catch (e) {
    err(`Installation failed: ${e.message}`);
    process.exit(1);
  }
}

function printNextSteps(target, dest) {
  console.log(`${c.bold}${c.green}Next Steps:${c.reset}`);

  const steps = {
    cursor: [
      'Restart Cursor (or reload window: Cmd+Shift+P → "Reload Window")',
      'Open any .tsx file → the skill is now active in AI context',
      'Say: "Build my React Native app" — the skill guides the AI',
    ],
    windsurf: [
      'Restart Windsurf',
      'The rule is now active in all AI Flows',
      'Say: "Set up my Expo project" to trigger Phase 1',
    ],
    claude: [
      'Open Claude Code in this project directory',
      'Skill loads automatically from .claude/skills/',
      'Say: "Build my React Native app" to activate',
    ],
    'claude-global': [
      'Skill is now global — active in ALL Claude Code projects',
      'Say: "Build my React Native app" to activate',
    ],
    copilot: [
      'Commit the updated .github/copilot-instructions.md',
      'GitHub Copilot now uses this skill in all chat interactions',
      'Works in VS Code, JetBrains, and GitHub.com',
    ],
    continue: [
      'Reload Continue.dev (Cmd+Shift+P → "Continue: Reload")',
      'The skill appears in your Continue context rules',
    ],
    zed: [
      'Restart Zed',
      'The skill is active in Zed AI Assistant',
    ],
    codex: [
      'Run: codex --context .codex/ <your-prompt>',
      'Or the skill auto-loads based on your Codex config',
    ],
    plain: [
      `Copy ${dest} content into your AI tool's system prompt or context`,
      'Works with: ChatGPT, Gemini, Mistral, Antigravity, Tembo, or any LLM',
      'For Claude.ai: paste into Project Instructions or a Project',
    ],
  };

  (steps[target] || steps.plain).forEach((s, i) => {
    console.log(`  ${c.cyan}${i + 1}.${c.reset} ${s}`);
  });

  console.log(`\n${c.dim}Skill version: ${SKILL_VERSION} | Flag used: --${PLATFORMS[target].flag}${c.reset}\n`);
}

main().catch(e => {
  err(`Unexpected error: ${e.message}`);
  process.exit(1);
});
