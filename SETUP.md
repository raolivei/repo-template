# Repository Template Setup Guide

This guide will help you set up a new repository using this template.

## Step 1: Copy Template Files

### Option A: Automated Setup (Recommended)

```bash
# Copy entire template directory
cp -r repo-template/* /path/to/new-repo/

# Run automated setup script
cd /path/to/new-repo
chmod +x scripts/setup-new-repo.sh
./scripts/setup-new-repo.sh YOUR_PROJECT_NAME
```

### Option B: Manual Copy

Copy all files from this template to your new repository:

```bash
# From the template directory
cp -r .github/ /path/to/new-repo/
cp -r github/ /path/to/new-repo/
cp -r scripts/ /path/to/new-repo/ 2>/dev/null || true
cp -r examples/ /path/to/new-repo/ 2>/dev/null || true
cp .gitignore /path/to/new-repo/
cp VERSION /path/to/new-repo/
cp CHANGELOG.md /path/to/new-repo/
cp CONTRIBUTING.md /path/to/new-repo/ 2>/dev/null || true
cp LICENSE /path/to/new-repo/ 2>/dev/null || true
cp SETUP.md /path/to/new-repo/
```

**Verification:**
```bash
cd /path/to/new-repo
ls -la .github/workflows/  # Should show workflow files
ls -la github/              # Should show branch protection files
cat VERSION                 # Should show 0.1.0
```

## Step 2: Update Configuration

### Update Repository Name

1. **Edit `github/setup-branch-protection.sh`**:
   ```bash
   REPO_NAME="PROJECT_NAME"  # Change to your repository name
   ```

2. **Edit `.github/workflows/build-and-push.yml`**:
   ```yaml
   IMAGE_NAME: ghcr.io/raolivei/PROJECT_NAME  # Change PROJECT_NAME
   ```

3. **Search and replace `PROJECT_NAME`** in all files:
   ```bash
   # macOS/Linux
   find . -type f -not -path "./.git/*" -not -path "./node_modules/*" -not -path "./venv/*" \
     -exec sed -i '' 's/PROJECT_NAME/your-repo-name/g' {} \;
   
   # Or use the automated script
   ./scripts/setup-new-repo.sh your-repo-name
   ```

4. **Verify replacements**:
   ```bash
   grep -r "PROJECT_NAME" . --exclude-dir=.git --exclude-dir=node_modules
   # Should return no results (or only in this SETUP.md file)
   ```

### Update Workflow Paths

Edit `.github/workflows/build-and-push.yml` to match your project structure:

**Single-component project:**
```yaml
paths:
  - "**/Dockerfile"
  - "src/**"
  - ".github/workflows/build-and-push.yml"
  - "VERSION"
```

**Multi-component project (e.g., backend + frontend):**
```yaml
paths:
  - "**/Dockerfile"
  - "backend/**"
  - "frontend/**"
  - ".github/workflows/build-and-push.yml"
  - "VERSION"
```

**Monorepo structure:**
```yaml
paths:
  - "**/Dockerfile"
  - "apps/**"
  - "packages/**"
  - ".github/workflows/build-and-push.yml"
  - "VERSION"
```

**Verification:**
```bash
# Check if paths match your structure
ls -d backend frontend src apps packages 2>/dev/null
```

### Update Status Checks

Edit `github/branch-protection-config.json` to match your workflow job names:

```json
{
  "contexts": [
    "Security Scanning / codeql-analysis",
    "CI / lint",
    "CI / test"
    // Add/remove based on your workflows
  ]
}
```

## Step 3: Configure GitHub Secrets

### Required Secret: CR_PAT

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `CR_PAT`
5. Value: Your GitHub Personal Access Token with `write:packages` permission

**How to create PAT:**
1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Select scopes: `write:packages`, `read:packages`
4. Generate and copy the token
5. Add as repository secret `CR_PAT`

### Optional Secrets

Add any other secrets your project needs:
- Database credentials
- API keys
- OAuth tokens
- etc.

## Step 4: Customize Workflows

### Update Language Detection

The workflows automatically detect Python and Node.js projects. To add other languages:

**Edit `.github/workflows/security-scan.yml`:**
```yaml
matrix:
  language: ['javascript', 'python', 'go', 'rust']  # Add languages
```

**Edit `.github/workflows/ci.yml`:**
Add language-specific steps for Go, Rust, Java, etc. See examples in workflow comments.

### Update Docker Build

**Single Dockerfile at root:**
```yaml
context: .
file: ./Dockerfile
```

**Dockerfile in subdirectory:**
```yaml
context: ./backend
file: ./backend/Dockerfile
```

**Multi-component builds:**
Uncomment and customize the multi-component build jobs in `build-and-push.yml`:
```yaml
# Example for api and frontend
env:
  IMAGE_NAME_API: ghcr.io/raolivei/PROJECT_NAME-api
  IMAGE_NAME_FRONTEND: ghcr.io/raolivei/PROJECT_NAME-frontend
```

**Add build arguments:**
```yaml
build-args: |
  BUILD_VERSION=${{ steps.package-version.outputs.version }}
  NODE_ENV=production
```

**Verification:**
```bash
# Test Docker build locally
docker build -t test-image -f Dockerfile .
# Or for subdirectory
docker build -t test-image -f backend/Dockerfile ./backend
```

## Step 5: Set Up Branch Protection

After your first push to GitHub:

```bash
# Make script executable
chmod +x github/setup-branch-protection.sh

# Run setup (requires GitHub CLI)
./github/setup-branch-protection.sh
```

**Prerequisites:**
- GitHub CLI (`gh`) installed
- Authenticated: `gh auth login`
- Repository exists on GitHub

## Step 6: Set Up Issue Templates and Labels

### Issue Templates

Issue templates are already included in `.github/ISSUE_TEMPLATE/`. They include:
- **Bug Report** - For reporting bugs (maps to `fix/` branches)
- **Feature Request** - For new features (maps to `feature/` branches)
- **Infrastructure Task** - For infrastructure changes (maps to `infra/` branches)
- **Security Vulnerability** - For security issues

**Verification:**
```bash
ls -la .github/ISSUE_TEMPLATE/
# Should show: bug_report.md, feature_request.md, infrastructure.md, security_vulnerability.md, config.yml
```

### Set Up Labels

Labels are automatically applied based on issue templates and align with branch naming conventions.

**Automated Setup:**
```bash
# Make script executable
chmod +x github/setup-labels.sh

# Run setup (requires GitHub CLI)
./github/setup-labels.sh [OWNER/REPO_NAME]
```

If repository name is not provided, the script will try to detect it from git remote.

**Prerequisites:**
- GitHub CLI (`gh`) installed
- Authenticated: `gh auth login`
- Repository exists on GitHub

**Label Categories:**
- **Type labels**: `type:bug`, `type:feature`, `type:infrastructure`, `type:documentation`, `type:chore`, `type:refactor`, `type:test`
- **Priority labels**: `priority:critical`, `priority:high`, `priority:medium`, `priority:low`
- **Status labels**: `status:needs-triage`, `status:in-progress`, `status:blocked`, `status:ready-for-review`
- **Component labels**: `component:api`, `component:frontend`, `component:k8s`, `component:docker`, `component:ci-cd`

**Verification:**
```bash
# List labels via GitHub CLI
gh label list --repo OWNER/REPO_NAME

# Or check on GitHub: Repository → Issues → Labels
```

### Set Up Project Board (Optional)

Project boards help track issues and PRs through their lifecycle.

**Automated Setup:**
```bash
# Make script executable
chmod +x github/setup-project-board.sh

# Run setup (requires GitHub CLI)
./github/setup-project-board.sh [OWNER/REPO_NAME]
```

**Manual Setup:**
1. Go to your repository on GitHub
2. Click "Projects" tab
3. Click "New project"
4. Select "Board" template
5. Name it: `[Repository Name] Project`
6. Add columns: Backlog, To Do, In Progress, In Review, Done

See `github/PROJECT_BOARDS.md` for detailed setup and automation instructions.

**Verification:**
- Visit: `https://github.com/OWNER/REPO/projects`
- Verify project board exists with standard columns

## Step 7: Initialize Version

```bash
echo "0.1.0" > VERSION
git add VERSION
git commit -m "chore: initialize version"
```

## Step 8: Test Workflows

1. **Create a test branch**:
   ```bash
   git checkout -b test/workflows
   ```

2. **Make a small change** (e.g., update README):
   ```bash
   echo "# Test" >> README.md
   git add README.md
   git commit -m "test: verify workflows"
   git push -u origin test/workflows
   ```

3. **Create a Pull Request** on GitHub:
   - Go to your repository on GitHub
   - Click "Compare & pull request"
   - Fill in PR description
   - Create pull request

4. **Verify workflows run**:
   - Go to **Actions** tab in GitHub
   - Check that all workflows start:
     - `Security Scanning` (should run automatically)
     - `CI` (should run automatically)
     - `Build and Push` (should run automatically)
   - Wait for workflows to complete (may take 5-10 minutes)
   - Verify all checks pass (green checkmarks)

5. **Check workflow outputs**:
   ```bash
   # View workflow runs via GitHub CLI
   gh run list
   
   # View specific workflow run
   gh run view <run-id>
   ```

**Common Issues:**
- If workflows don't run: Check YAML syntax, verify paths in triggers
- If builds fail: Check Dockerfile exists, verify build context
- If security scans fail: Ensure language is in matrix, check package files exist

## Step 9: Clean Up

After verifying everything works:

1. Delete this `SETUP.md` file (optional)
2. Update `README.md` with your project-specific information
3. Update `CHANGELOG.md` with your initial release

## Verification Checklist

- [ ] All `PROJECT_NAME` references updated
- [ ] Workflow paths match your project structure
- [ ] `CR_PAT` secret configured
- [ ] Branch protection rules applied
- [ ] Issue templates available (check GitHub Issues → New issue)
- [ ] Labels created and visible (check GitHub Issues → Labels)
- [ ] Project board set up (optional, check GitHub Projects)
- [ ] Workflows run successfully on test PR
- [ ] Docker images build and push correctly
- [ ] Security scans complete without errors
- [ ] Version file initialized

## Next Steps

- Add project-specific documentation
- Configure additional secrets as needed
- Customize workflows for your stack
- Set up deployment workflows (if applicable)
- Configure CODEOWNERS (optional)

## Troubleshooting

### Workflows Not Running

**Symptoms:** Workflows don't appear in Actions tab or don't trigger

**Solutions:**
1. Check YAML syntax:
   ```bash
   # Validate YAML files
   yamllint .github/workflows/*.yml
   # Or use online validator: https://www.yamllint.com/
   ```

2. Verify file paths in workflow triggers match your project:
   ```bash
   # Check if paths exist
   ls -la backend/ frontend/ src/ 2>/dev/null
   ```

3. Ensure workflow files are in correct location:
   ```bash
   ls -la .github/workflows/
   # Should show: security-scan.yml, build-and-push.yml, ci.yml
   ```

4. Check GitHub Actions is enabled:
   - Go to repository Settings → Actions → General
   - Ensure "Allow all actions and reusable workflows" is selected

### Branch Protection Setup Fails

**Symptoms:** Script fails with authentication or permission errors

**Solutions:**
1. Verify GitHub CLI is installed:
   ```bash
   gh --version
   # Install if needed: brew install gh (macOS) or see https://cli.github.com/
   ```

2. Check authentication:
   ```bash
   gh auth status
   # Login if needed: gh auth login
   ```

3. Verify repository access:
   ```bash
   gh repo view raolivei/PROJECT_NAME
   # Should show repository info without errors
   ```

4. Check admin permissions:
   - Go to repository Settings → Collaborators
   - Ensure your account has Admin access

### Docker Build Fails

**Symptoms:** Build job fails with Docker errors

**Solutions:**
1. Test Dockerfile locally:
   ```bash
   docker build -t test-image -f Dockerfile .
   ```

2. Verify build context paths:
   ```yaml
   # In build-and-push.yml, ensure context matches Dockerfile location
   context: ./backend      # If Dockerfile is in backend/
   file: ./backend/Dockerfile
   ```

3. Check for missing dependencies:
   ```bash
   # Review Dockerfile for base images and dependencies
   cat Dockerfile
   ```

4. Review workflow logs:
   - Go to Actions → Failed workflow → Build job
   - Check "Build and push Docker image" step for errors

### Security Scans Fail

**Symptoms:** Security scanning jobs fail or report errors

**Solutions:**

1. **CodeQL fails:**
   - Ensure your language is in the matrix:
     ```yaml
     matrix:
       language: ['javascript', 'python', 'go']  # Add your language
     ```
   - Check if CodeQL supports your language: https://codeql.github.com/docs/

2. **Dependency scan fails:**
   - Verify package manager files exist:
     ```bash
     ls -la package-lock.json requirements.txt pyproject.toml
     ```
   - Ensure files are in expected locations (root or subdirectories)

3. **Container scan fails:**
   - Verify Dockerfile exists:
     ```bash
     find . -name "Dockerfile" -not -path "*/node_modules/*"
     ```
   - Check Dockerfile syntax is valid

### Common Pitfalls

1. **Forgetting to replace PROJECT_NAME:**
   - Use `grep -r "PROJECT_NAME" .` to find remaining instances
   - Run `./scripts/setup-new-repo.sh` to automate replacement

2. **Wrong image names:**
   - Ensure image names match GitHub Container Registry format: `ghcr.io/OWNER/REPO`
   - Check repository visibility (public/private) matches your needs

3. **Missing secrets:**
   - Verify `CR_PAT` secret is set in repository Settings → Secrets
   - Check secret name matches exactly (case-sensitive)

4. **Path mismatches:**
   - Workflow paths must match actual project structure
   - Use `find . -type d -name "backend" -o -name "frontend"` to verify structure

## Support

For issues or questions:
1. Check workflow logs in GitHub Actions
2. Review this setup guide
3. Consult GitHub Actions documentation
4. Check repository-specific documentation

