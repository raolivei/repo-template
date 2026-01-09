# GitHub Project Boards Setup Guide

This guide explains how to set up and use GitHub Project Boards for issue and PR tracking.

## Overview

GitHub Projects (v2) provide a flexible way to organize and track work across your repository. This guide covers both manual setup and automation configuration.

## Quick Setup

### Automated Setup (Recommended)

Run the setup script:

```bash
cd /path/to/repo
./github/setup-project-board.sh [OWNER/REPO_NAME]
```

**Note**: Automated project creation via API may require additional permissions. If the script indicates manual setup is needed, follow the manual instructions below.

### Manual Setup

1. **Navigate to your repository** on GitHub
2. **Click on the "Projects" tab**
3. **Click "New project"**
4. **Select "Board" template** (or start from scratch)
5. **Name your project**: `[Repository Name] Project`
6. **Add columns**:
   - Backlog
   - To Do
   - In Progress
   - In Review
   - Done

## Column Configuration

### Standard Columns

| Column | Purpose | Automation |
|--------|---------|------------|
| **Backlog** | New issues and unprioritized work | New issues automatically added |
| **To Do** | Prioritized issues ready to start | Manual or label-based |
| **In Progress** | Active work | `status:in-progress` label |
| **In Review** | PRs and code review | PRs automatically added |
| **Done** | Completed work | Merged PRs, closed issues |

## Automation Setup

### 1. Field-Based Automation

GitHub Projects v2 supports field-based automation. Set up automation rules:

#### Status Field Automation

1. Go to your project board
2. Click "..." menu → "Settings"
3. Navigate to "Workflows" or "Automation"
4. Add rules:

**Rule 1: Move to "In Progress"**
- **When**: Issue is labeled `status:in-progress`
- **Then**: Move to "In Progress" column

**Rule 2: Move to "In Review"**
- **When**: Pull request is opened
- **Then**: Move to "In Review" column

**Rule 3: Move to "Done"**
- **When**: Pull request is merged OR issue is closed
- **Then**: Move to "Done" column

### 2. Label-Based Workflow

Use labels to trigger automation:

- `status:in-progress` → Moves issue to "In Progress"
- `status:ready-for-review` → Moves issue to "In Review"
- `status:blocked` → Can be used to flag blocked items

### 3. PR Linking

Link pull requests to issues:

1. In your PR description, include: `Closes #123` or `Fixes #123`
2. When PR is merged, the linked issue automatically closes
3. Configure automation to move closed issues to "Done"

## Best Practices

### Issue Management

1. **Create issues for all work**: Features, bugs, infrastructure changes
2. **Use appropriate labels**: `type:feature`, `type:bug`, `type:infrastructure`
3. **Set priority**: `priority:critical`, `priority:high`, etc.
4. **Link related issues**: Use "Related Issues" section in templates

### Branch Naming

Align branches with issue types:

- `feature/issue-123-add-login` → Links to `type:feature` issue #123
- `fix/issue-456-bug-fix` → Links to `type:bug` issue #456
- `infra/issue-789-k8s-update` → Links to `type:infrastructure` issue #789

### PR Workflow

1. **Link issues in PR**: `Closes #123` in PR description
2. **Update status labels**: Add `status:in-progress` when starting work
3. **Move to review**: PR automatically moves to "In Review" column
4. **Auto-close issues**: Merged PRs automatically close linked issues

## Advanced Configuration

### Custom Fields

Add custom fields to track additional metadata:

- **Priority**: Dropdown (Critical, High, Medium, Low)
- **Component**: Dropdown (API, Frontend, K8s, Docker)
- **Sprint/Milestone**: Text or date field
- **Estimated Effort**: Number field

### Views

Create different views for different needs:

- **By Status**: Group by status field
- **By Priority**: Group by priority field
- **By Component**: Group by component field
- **By Assignee**: Group by assignee

### Filters

Use filters to focus on specific work:

- `label:type:bug` - Show only bugs
- `label:priority:critical` - Show only critical items
- `assignee:@me` - Show only items assigned to you
- `status:in-progress` - Show only in-progress items

## Integration with GitHub Actions

You can automate project board updates via GitHub Actions:

```yaml
# Example: Auto-add issues to project board
- name: Add issue to project
  uses: actions/add-to-project@v0.4.0
  with:
    project-url: https://github.com/OWNER/REPO/projects/1
    github-token: ${{ secrets.GITHUB_TOKEN }}
```

## Troubleshooting

### Project Not Appearing

- Ensure you have repository admin access
- Check that Projects are enabled in repository settings
- Verify you're using GitHub Projects v2 (not classic)

### Automation Not Working

- Check automation rules are enabled in project settings
- Verify labels match exactly (case-sensitive)
- Ensure you have permissions to modify project automation

### Issues Not Auto-Moving

- Verify labels are applied correctly
- Check automation rules are configured
- Ensure field-based automation is enabled

## Resources

- [GitHub Projects Documentation](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
- [GitHub Projects API](https://docs.github.com/en/graphql/reference/objects#projectv2)
- [Automation in Projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project/using-the-api-to-manage-projects)

## Example Workflow

1. **Create Issue**: Use template (bug, feature, infrastructure)
2. **Add to Project**: Issue automatically appears in "Backlog"
3. **Prioritize**: Move to "To Do" when ready
4. **Start Work**: Add `status:in-progress` label → Moves to "In Progress"
5. **Create PR**: Link with `Closes #123` → Moves to "In Review"
6. **Merge PR**: Issue auto-closes → Moves to "Done"

This workflow ensures all work is tracked and visible throughout the development lifecycle.


