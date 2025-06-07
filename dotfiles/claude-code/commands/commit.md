# Universal Commit Command

Creates well-formatted commits with conventional commit messages. Automatically removes emoji when arguments are provided and handles ticket IDs.

## Usage

Basic usage:

```bash
/commit
```

With custom message (no emoji):

```bash
/commit fix: resolve authentication bug
/commit JIRA-123 feat: add user endpoints
/commit [TICKET-456] refactor: improve error handling
```

With options:

```bash
/commit --no-verify
/commit --no-emoji
```

## Instructions for Claude

When this command is invoked:

1. **Check if $ARGUMENTS contains a custom commit message**

   - If $ARGUMENTS is provided, parse it for:
     - Ticket ID patterns: `TICKET-123`, `[TICKET-123]`, `JIRA-456`, etc.
     - Conventional commit format after the ticket
   - For custom messages, DO NOT add emoji - use the provided message as-is
   - Format: `[TICKET-ID] type: message` if ticket found

2. **Pre-commit Checks** (skip if `--no-verify` in $ARGUMENTS)

   - Check CLAUDE.md for linting/testing commands
   - If linter commands found in CLAUDE.md, run them
   - If no linter info in CLAUDE.md, skip pre-commit checks
   - Common patterns to look for in CLAUDE.md:
     - "lint", "test", "check", "verify"
     - Commands like `npm run lint`, `pytest`, `cargo test`, etc.

3. **Git Operations**

   ```bash
   git status --porcelain
   ```

   - If no files staged, run `git add .`
   - Show what will be committed

4. **Analyze Changes** (only if no custom message)

   ```bash
   git diff --cached
   ```

   - Determine commit type: feat, fix, docs, style, refactor, test, chore
   - Identify scope if applicable
   - Check if changes should be split

5. **Commit Message Format**

   **Custom message examples:**

   ```
   Input: /commit PROJ-123 fix: resolve login issue
   Output: [PROJ-123] fix: resolve login issue

   Input: /commit fix: update dependencies
   Output: fix: update dependencies
   ```

   **Auto-generated (with emoji by default):**

   ```
   ✨ feat: add user authentication
   🐛 fix: resolve memory leak
   📝 docs: update API documentation
   ```

   **Auto-generated (--no-emoji flag):**

   ```
   feat: add user authentication
   fix: resolve memory leak
   docs: update API documentation
   ```

   **REMEMBER: Do Not Add Claude Credit In The Message**

## Ticket ID Parsing

Parse these patterns from $ARGUMENTS:

- `TICKET-123` → `[TICKET-123]`
- `[TICKET-123]` → `[TICKET-123]` (keep as is)
- `PROJ-456` → `[PROJ-456]`
- `#123` → `[#123]`
- Multiple formats: JIRA-123, GH-456, ISSUE-789, etc.

The ticket should be placed at the beginning of the commit message in square brackets.

## Commit Type Detection

When auto-generating commits, analyze the diff to determine type:

| Type     | When to use                  | Emoji |
| -------- | ---------------------------- | ----- |
| feat     | New functionality            | ✨    |
| fix      | Bug fixes                    | 🐛    |
| docs     | Documentation only           | 📝    |
| style    | Formatting, semicolons, etc. | 💄    |
| refactor | Code restructuring           | ♻️    |
| perf     | Performance improvements     | ⚡️   |
| test     | Adding tests                 | ✅    |
| chore    | Maintenance, dependencies    | 🔧    |
| build    | Build system changes         | 📦️   |
| ci       | CI/CD changes                | 👷    |
| revert   | Reverting commits            | ⏪️   |

## Examples

1. **Simple commit (auto-generated with emoji):**

   ```
   /commit
   ```

   Result: `✨ feat: implement user dashboard`

2. **Custom commit with ticket:**

   ```
   /commit JIRA-1234 fix: resolve null pointer exception
   ```

   Result: `[JIRA-1234] fix: resolve null pointer exception`

3. **Custom commit without ticket:**

   ```
   /commit refactor: simplify auth logic
   ```

   Result: `refactor: simplify auth logic`

4. **Skip verification:**

   ```
   /commit --no-verify
   ```

5. **No emoji for auto-generated:**
   ```
   /commit --no-emoji
   ```
   Result: `feat: implement user dashboard`

## Key Points

- When $ARGUMENTS is provided, NEVER add emoji
- Always check CLAUDE.md for project-specific linting commands
- If no linting info found, proceed without pre-commit checks
- Extract and format ticket IDs to `[TICKET-ID]` format
- Maintain conventional commit format: `type(scope): message`
- Breaking changes: use `!` after type/scope (e.g., `feat!: breaking change`)
- Do not add Claude credit in commit message
