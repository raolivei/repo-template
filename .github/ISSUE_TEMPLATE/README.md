# Issue Templates and Linking Guide

This directory contains issue templates for bug reports, feature requests, and infrastructure tasks. This guide explains how to use these templates and link issues to pull requests.

## Available Templates

- **Bug Report** (`bug_report.md`) - For reporting bugs and issues
- **Feature Request** (`feature_request.md`) - For suggesting new features
- **Infrastructure Task** (`infrastructure.md`) - For infrastructure changes (K8s, Docker, CI/CD)
- **Security Vulnerability** (`security_vulnerability.md`) - For reporting security issues

## Creating an Issue

1. Go to your repository on GitHub
2. Click "Issues" → "New issue"
3. Select the appropriate template
4. Fill out the template with relevant information
5. Add appropriate labels (automatically applied based on template)
6. Submit the issue

## Linking Issues to Pull Requests

### Method 1: In Commit Messages

Include issue references in your commit messages:

```bash
git commit -m "feat: Add user authentication

Closes #123"
```

**Keywords that close issues:**
- `Closes #123` - Closes the issue when PR is merged
- `Fixes #123` - Same as Closes
- `Resolves #123` - Same as Closes

**Keywords that link but don't close:**
- `Related to #123` - Links but doesn't close
- `See #123` - Links but doesn't close
- `Refs #123` - Links but doesn't close

### Method 2: In PR Description

Add issue references in your pull request description:

```markdown
## Description

This PR adds user authentication functionality.

## Related Issues

Closes #123
Fixes #456
Related to #789
```

### Method 3: In PR Title

You can also reference issues in the PR title:

```
Add user authentication (Closes #123)
```

## Branch Naming Convention

Align your branch names with issue types:

| Issue Type | Branch Prefix | Example |
|------------|---------------|---------|
| Bug Report | `fix/` | `fix/issue-123-login-bug` |
| Feature Request | `feature/` | `feature/issue-456-user-dashboard` |
| Infrastructure | `infra/` | `infra/issue-789-k8s-update` |
| Documentation | `docs/` | `docs/issue-101-readme-update` |
| Chore | `chore/` | `chore/issue-202-deps-update` |
| Refactor | `refactor/` | `refactor/issue-303-code-cleanup` |
| Test | `test/` | `test/issue-404-add-tests` |

## Issue Labels

Labels are automatically applied based on the template used:

- **Type Labels**: `type:bug`, `type:feature`, `type:infrastructure`, etc.
- **Priority Labels**: `priority:critical`, `priority:high`, `priority:medium`, `priority:low`
- **Status Labels**: `status:needs-triage`, `status:in-progress`, `status:blocked`, `status:ready-for-review`
- **Component Labels**: `component:api`, `component:frontend`, `component:k8s`, etc.

## Workflow Example

1. **Create Issue**: Use bug report template for a login bug
   - Issue #123 is created with `type:bug` label

2. **Create Branch**: `fix/issue-123-login-bug`

3. **Make Changes**: Fix the bug and commit

4. **Create PR**: 
   ```markdown
   ## Description
   Fixes login bug where users couldn't authenticate.
   
   Closes #123
   ```

5. **Merge PR**: When PR is merged, issue #123 automatically closes

## Best Practices

### Issue Creation

- ✅ Use the appropriate template
- ✅ Provide clear, detailed descriptions
- ✅ Include steps to reproduce (for bugs)
- ✅ Add relevant labels manually if needed
- ✅ Link related issues in "Related Issues" section

### PR Creation

- ✅ Always link to related issues
- ✅ Use `Closes #123` when PR fully addresses the issue
- ✅ Use `Related to #123` when PR is related but doesn't fully address it
- ✅ Update issue status labels (`status:in-progress` when starting work)
- ✅ Reference multiple issues if applicable: `Closes #123, #456`

### Issue Management

- ✅ Keep issues up to date with status labels
- ✅ Add comments when work starts or is blocked
- ✅ Close issues that are no longer relevant
- ✅ Use milestones to group related issues
- ✅ Assign issues to team members when appropriate

## Automatic Issue Closing

GitHub automatically closes issues when:

- A PR with `Closes #123`, `Fixes #123`, or `Resolves #123` is merged
- The PR is merged into the default branch (usually `main`)
- The issue number is correctly referenced

**Note**: Issues are only closed when PRs are merged, not when they are opened or updated.

## Multiple Issues

You can reference multiple issues in a single PR:

```markdown
Closes #123, #456
Fixes #789
Related to #101
```

All referenced issues will be linked, and those with closing keywords will be closed when the PR merges.

## Troubleshooting

### Issue Not Closing

- Verify the PR was merged (not just closed)
- Check that the issue number is correct: `#123` not `123` or `issue-123`
- Ensure closing keyword is used: `Closes`, `Fixes`, or `Resolves`
- Check that PR was merged into the default branch

### Issue Not Linking

- Verify issue number format: `#123`
- Check that the issue exists in the same repository
- Ensure the reference is in commit message, PR description, or PR title

### Labels Not Applied

- Check that labels exist in the repository
- Verify template has correct label names
- Run `./github/setup-labels.sh` to create missing labels

## Resources

- [GitHub Issue Linking](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue)
- [Closing Issues via Commit](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/using-keywords-in-issues-and-pull-requests)
- [Issue Templates](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository)


