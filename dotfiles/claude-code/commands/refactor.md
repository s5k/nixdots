# Expert Refactor

I'll analyze your git changes and refactor them for readability, maintainability, and performance.

## Usage

```bash
/refactor
/refactor --staged
/refactor --performance
/refactor --last-commit
```

## Instructions for Claude

I'll review and refactor **$ARGUMENTS** (or current git changes if no arguments) like an expert developer would.

### 1. Analyze Changes

```bash
git diff --cached  # for staged changes
git diff          # for unstaged changes
git show HEAD     # for last commit (if --last-commit)
```

**Search existing codebase for:**

- Similar functions/utilities that already exist
- Type definitions that should be centralized
- Shared constants or configurations
- Common patterns or abstractions

### 2. Expert Review Criteria

**Readability**

- Clear variable/function names
- Remove magic numbers/strings
- Simplify complex conditionals
- Add meaningful comments (only where needed)
- Consistent code style

**Maintainability**

- Apply SOLID principles
- Extract reusable functions
- Remove code duplication
- Improve error handling
- Organize imports/dependencies

**Performance**

- Optimize algorithms (O(n²) → O(n))
- Reduce unnecessary loops
- Cache expensive operations
- Lazy load when appropriate
- Remove redundant calculations

**Project Structure**

- Respect framework conventions (React, Vue, Django, Rails, etc.)
- Follow project's existing patterns
- Split large files (>300 lines) into logical modules
- Organize by feature/domain when appropriate
- Maintain consistent folder structure

### 3. Refactoring Actions

1. **Analyze project context**:

   - Check CLAUDE.md for project conventions
   - Identify framework (React, Vue, Django, Rails, etc.)
   - Review existing folder structure
   - Understand naming patterns

2. **Search for redundancy**:

   - Check if similar functions exist elsewhere
   - Find existing type definitions
   - Look for shared constants/configs
   - Identify common patterns

3. **Apply refactoring patterns**:
   - Extract Method/Variable
   - Remove redundant implementations
   - Move code to appropriate locations
   - Consolidate duplicate logic
   - Replace conditionals with polymorphism
   - Introduce explaining variables
   - Split large functions
   - **Split large files** into smaller, focused modules
4. **Organize by domain**:
   - **Types**: Move to `types/` or `@types/` directory
   - **Constants**: Move to `constants/` or `config/`
   - **Utils**: Move to `utils/` or `helpers/`
   - **Hooks**: Move to `hooks/` (React)
   - **Services**: Move to `services/`
   - **Models**: Move to `models/`
5. **Follow framework best practices**:
   - React: Custom hooks, component composition
   - Vue: Composables, single-file components
   - Django: Fat models, thin views
   - Rails: Concerns, service objects
   - Express: Middleware, route organization
6. **Ensure backward compatibility**
7. **Maintain existing tests**
8. **Add tests if missing**

### 4. Common Improvements

```javascript
// Before: Magic numbers, unclear intent
if (user.age > 17 && user.status === 1) {
  total = price * 0.9;
}

// After: Clear constants, readable logic
const ADULT_AGE = 18;
const ACTIVE_STATUS = 1;
const MEMBER_DISCOUNT = 0.1;

const isAdultMember = user.age >= ADULT_AGE && user.status === ACTIVE_STATUS;
if (isAdultMember) {
  total = price * (1 - MEMBER_DISCOUNT);
}
```

**File Splitting Example:**

```javascript
// Before: 500-line UserController.js

// After: Split into logical modules
UserController.js         // Main controller logic
├── validators/
│   └── userValidator.js  // Input validation
├── services/
│   └── userService.js    // Business logic
└── utils/
    └── userHelpers.js    // Helper functions
```

**Type Organization Example:**

```typescript
// Before: Types defined inline
// components/UserProfile.tsx
interface UserData {
  id: string;
  name: string;
}

// After: Centralized types
// types/user.ts
export interface UserData {
  id: string;
  name: string;
}

// components/UserProfile.tsx
import { UserData } from "@/types/user";
```

**Redundancy Removal Example:**

```javascript
// Before: Same validation in 3 files
const isValidEmail = (email) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);

// After: Shared utility
// utils/validation.js
export const isValidEmail = (email) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);

// Import in all 3 files
import { isValidEmail } from "@/utils/validation";
```

### 5. Output Format

For each refactoring:

1. Show the problematic code
2. Explain why it needs improvement
3. Show the refactored version
4. List the benefits

### 6. Flags

- `--staged`: Only refactor staged changes
- `--performance`: Focus on performance optimizations
- `--last-commit`: Refactor the last commit
- Default: Refactor all uncommitted changes

## Remember

- **Search before creating**: Check if similar code exists
- **Centralize shared code**: Types, utils, constants
- **Remove all redundancy**: Don't duplicate logic
- Respect project's existing structure
- Follow framework conventions
- Keep files small and focused (<300 lines)
- Maintain functionality
- Make incremental changes
- Explain reasoning
- Consider team patterns
