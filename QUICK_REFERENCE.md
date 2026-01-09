# Quick Reference Guide

## Essential Commands

### Initial Setup
```bash
# 1. Copy template to new repo
cp -r repo-template/* /path/to/new-repo/

# 2. Update repository name
find . -type f -exec sed -i '' 's/PROJECT_NAME/your-repo-name/g' {} \;

# 3. Make setup script executable
chmod +x github/setup-branch-protection.sh

# 4. Initialize version
echo "0.1.0" > VERSION
```

### GitHub Setup
```bash
# Set up branch protection (after first push)
./github/setup-branch-protection.sh

# Set up issue labels
./github/setup-labels.sh [OWNER/REPO_NAME]

# Set up project board (optional)
./github/setup-project-board.sh [OWNER/REPO_NAME]

# Verify GitHub CLI
gh auth status
```

## Required GitHub Secrets

| Secret | Purpose | How to Create |
|--------|---------|---------------|
| `CR_PAT` | Push to GHCR | GitHub Settings → Developer settings → Personal access tokens → Generate with `write:packages` |

## Workflow Triggers

### Security Scanning
- ✅ Every PR to `main`
- ✅ Push to `main`/`dev`
- ✅ Weekly schedule (Mondays)
- ✅ Manual trigger

### Build & Push
- ✅ Push to `main`/`dev`
- ✅ Git tags `v*`
- ✅ PRs (build only)
- ✅ Manual with tag input

### CI
- ✅ PRs to `main`/`dev`
- ✅ Push to `dev`
- ✅ Manual trigger

## Image Tagging

| Trigger | Tags |
|---------|------|
| `main` push | `main`, `latest`, `main-<sha>` |
| `dev` push | `dev`, `dev-<sha>` |
| Tag `v1.2.3` | `v1.2.3`, `v1.2`, `v1`, `<sha>` |
| PR #42 | `pr-42` (no push) |

## Issue Management

### Creating Issues
- Use templates: GitHub → Issues → New issue → Select template
- Templates: Bug Report, Feature Request, Infrastructure Task, Security Vulnerability

### Linking Issues to PRs
```bash
# In commit message
git commit -m "feat: Add feature

Closes #123"

# In PR description
# Closes #123
# Fixes #456
# Related to #789
```

### Branch Naming (aligns with issue types)
- `fix/issue-123-bug-name` → Bug reports
- `feature/issue-456-feature-name` → Feature requests
- `infra/issue-789-infra-name` → Infrastructure tasks
- `docs/issue-101-doc-name` → Documentation
- `chore/issue-202-chore-name` → Maintenance
- `refactor/issue-303-refactor-name` → Refactoring
- `test/issue-404-test-name` → Tests

### Label Management
```bash
# List all labels
gh label list --repo OWNER/REPO

# View label details
gh label view "type:bug" --repo OWNER/REPO

# Create label manually
gh label create "custom-label" --repo OWNER/REPO --color "ff0000" --description "Description"
```

## Customization Checklist

- [ ] Update `PROJECT_NAME` in all files
- [ ] Update workflow paths to match project structure
- [ ] Update Docker build context/file paths
- [ ] Update status checks in branch protection config
- [ ] Set up issue templates and labels
- [ ] Create project board (optional)
- [ ] Add project-specific secrets
- [ ] Customize language detection (if needed)
- [ ] Update `.gitignore` for project-specific patterns

## Troubleshooting

### Workflows not running?
- Check YAML syntax
- Verify file paths in triggers
- Ensure files are in `.github/workflows/`

### Branch protection fails?
- Verify `gh` CLI installed: `gh --version`
- Check authentication: `gh auth status`
- Ensure admin access to repo

### Build fails?
- Check Dockerfile syntax
- Verify build context paths
- Review workflow logs

### Security scans fail?
- CodeQL: Add language to matrix
- Dependency scan: Ensure package files exist
- Container scan: Verify Dockerfile exists

## File Locations

| File | Purpose |
|------|---------|
| `.github/workflows/security-scan.yml` | Security scanning |
| `.github/workflows/build-and-push.yml` | Docker builds |
| `.github/workflows/ci.yml` | CI checks |
| `.github/dependabot.yml` | Dependency updates |
| `.github/SECURITY.md` | Security policy |
| `.github/ISSUE_TEMPLATE/` | Issue templates |
| `.github/labels.json` | Label definitions |
| `github/branch-protection-config.json` | Protection rules |
| `github/setup-branch-protection.sh` | Setup script |
| `github/setup-labels.sh` | Label setup script |
| `github/setup-project-board.sh` | Project board setup |
| `github/PROJECT_BOARDS.md` | Project board docs |
| `VERSION` | Semantic version |
| `CHANGELOG.md` | Change log |

## Support

- See `SETUP.md` for detailed setup instructions
- See `.github/workflows/README.md` for workflow documentation
- See `.github/ISSUE_TEMPLATE/README.md` for issue linking guide
- See `github/PROJECT_BOARDS.md` for project board setup
- See `TEMPLATE_SUMMARY.md` for analysis and comparison

