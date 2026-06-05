# Fix bug

## Workflow Steps

### [x] Step: Investigation and Planning

Analyze the bug report and design a solution.

1. Review the bug description, error messages, and logs
2. Clarify reproduction steps with the user if unclear
3. Check existing tests for clues about expected behavior
4. Locate relevant code sections and identify root cause
5. Propose a fix based on the investigation
6. Consider edge cases and potential side effects

Save findings to `d:\GIT\calculator\.zencoder\chats\322f5a4e-d391-45ef-a46c-57915639391b/investigation.md` with:

- Bug summary
- Root cause analysis
- Affected components
- Proposed solution

**Stop here.** Present the investigation findings to the user and wait for their confirmation before proceeding.

### [x] Step: Implementation

Read `d:\GIT\calculator\.zencoder\chats\322f5a4e-d391-45ef-a46c-57915639391b/investigation.md`
Implement the bug fix and UI improvements.

1. Add/adjust regression test(s) that fail before the fix and pass after
2. Implement the speech bug fix as per investigation
3. Update all buttons to use contrast colors instead of black
4. Run relevant tests
5. Update `d:\GIT\calculator\.zencoder\chats\322f5a4e-d391-45ef-a46c-57915639391b/investigation.md` with implementation notes and test results

### [ ] Step: Fix Urdu Number Pronunciation

Fix the bug where Urdu numbers are read incorrectly (e.g., 325 as "teen so bees panch" instead of "teen so pachees").

1. Analyze how Urdu numbers are converted to text
2. Identify the rule for combined tens and units (e.g., 25 should be "pachees", not "bees panch")
3. Implement the correct conversion logic
4. Verify with tests

If blocked or uncertain, ask the user for direction.
