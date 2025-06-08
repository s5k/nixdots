# Commit Command

Create well-formatted conventional commits with optional emoji and ticket ID support.

## Usage

```bash
/commit                    # Auto-generate with emoji
/commit --no-verify       # Skip pre-commit checks
/commit --no-emoji        # No emoji in auto-generated
/commit JIRA-123          # Ticket only (generates message)
/commit fix: resolve bug  # Custom message (no emoji)
```

## STRICT EXECUTION ORDER

**CRITICAL: Never add "Co-authored-by: Claude" or any Claude attribution to commits.**

### Step 1: Parse Arguments

```
IF $ARGUMENTS exists:
  - Check for flags: --no-verify, --no-emoji, --staged
  - Check for ticket pattern: JIRA-123, PROJ-456, #123
  - Check for commit message: "type: description"
  - IF only ticket ID → will auto-generate message WITHOUT emoji
  - IF custom message → use as-is WITHOUT emoji
```

### Step 2: Pre-commit Verification

```
IF --no-verify NOT in $ARGUMENTS:
  1. FIRST read CLAUDE.md file
  2. Search for lint/test commands in CLAUDE.md
  3. IF found → run those commands
  4. IF not found → skip verification
  5. IF commands fail → ask user to fix or continue
ELSE:
  Skip this step entirely
```

### Step 3: Check Git Status

```bash
# Check what needs to be committed
git status --porcelain

# IF --staged flag present:
#   Only commit staged files
# ELSE IF no files staged:
#   git add .
# Show user what will be committed
```

### Step 4: Generate Commit Message

```
IF $ARGUMENTS contains ticket only (e.g., JIRA-123):
  1. Analyze changes with: git diff --cached
  2. Determine type: feat/fix/docs/refactor/etc
  3. Generate: [JIRA-123] type: description (NO EMOJI)

ELIF $ARGUMENTS contains custom message:
  1. Parse ticket if present
  2. Use message as-is (NO EMOJI)

ELSE (no arguments):
  1. Analyze changes with: git diff --cached
  2. Determine type and scope
  3. Generate with emoji (unless --no-emoji)
```

### Step 5: Execute Commit

```bash
# Use ONLY this format:
git commit -m "message here"

# DO NOT use:
# - git commit --author
# - git commit --signoff
# - Any Co-authored-by text
```

## Decision Tree

```
START
  ↓
Has $ARGUMENTS?
  ├─ YES → Parse for ticket/message/flags
  │    ├─ Only ticket? → Generate message, NO emoji
  │    ├─ Has message? → Use as-is, NO emoji
  │    └─ Has --no-verify? → Skip step 2
  └─ NO → Will generate with emoji
  ↓
Should verify? (no --no-verify flag)
  ├─ YES → Read CLAUDE.md FIRST
  │    ├─ Found lint commands? → Run them
  │    └─ No commands? → Continue
  └─ NO → Skip verification
  ↓
Check git status
  ├─ Files staged? → Use staged files
  └─ Nothing staged? → git add .
  ↓
Generate/use commit message
  ↓
Execute: git commit -m "message"
```

## Message Format Examples

```bash
# Input → Output

/commit
→ ✨ feat: add user authentication

/commit --no-emoji
→ feat: add user authentication

/commit JIRA-123
→ [JIRA-123] fix: resolve authentication issue

/commit JIRA-123 feat: add new endpoint
→ [JIRA-123] feat: add new endpoint

/commit fix: update dependencies
→ fix: update dependencies
```

## Important Rules

1. **ALWAYS read CLAUDE.md before running any lint/test commands**
2. **NEVER add emoji when $ARGUMENTS provided**
3. **NEVER add Claude attribution or Co-authored-by**
4. **Use simple git commit -m only**
5. **Ticket-only input should generate full message**

## Error Handling

- If CLAUDE.md not found → Skip verification
- If lint/test fails → Ask user: "Tests failed. Continue anyway? (y/n)"
- If no git repo → Error: "Not a git repository"
- If nothing to commit → Info: "No changes to commit"
