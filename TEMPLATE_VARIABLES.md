# Template Variables

This document lists all placeholder variables used in the repository template that need to be replaced when setting up a new project.

## Primary Variable: PROJECT_NAME

The main placeholder variable is `PROJECT_NAME`. Replace it with your actual project/repository name.

### Files Containing PROJECT_NAME

| File | Location | Description |
|------|----------|-------------|
| `.github/workflows/build-and-push.yml` | `env.IMAGE_NAME` | Docker image name |
| `.github/workflows/ci.yml` | Build job tags | Docker test image name |
| `github/setup-branch-protection.sh` | `REPO_NAME` variable | Repository name for GitHub CLI |
| `README.md` | Badge URLs (commented) | GitHub Actions badge URLs |
| `README.md` | Examples | Example image names |
| `SETUP.md` | Examples | Example commands and paths |

## Replacement Methods

### Automated Replacement (Recommended)

Use the provided setup script:

```bash
./scripts/setup-new-repo.sh YOUR_PROJECT_NAME
```

This script will:
- Replace all instances of `PROJECT_NAME` with your project name
- Update repository-specific paths
- Initialize VERSION file
- Set up initial git configuration

### Manual Replacement

**macOS/Linux:**
```bash
find . -type f -not -path "./.git/*" -not -path "./node_modules/*" \
  -not -path "./venv/*" -exec sed -i '' 's/PROJECT_NAME/your-project-name/g' {} \;
```

**Linux (GNU sed):**
```bash
find . -type f -not -path "./.git/*" -not -path "./node_modules/*" \
  -not -path "./venv/*" -exec sed -i 's/PROJECT_NAME/your-project-name/g' {} \;
```

**Windows (PowerShell):**
```powershell
Get-ChildItem -Recurse -File | ForEach-Object {
    (Get-Content $_.FullName) -replace 'PROJECT_NAME', 'your-project-name' | 
    Set-Content $_.FullName
}
```

## Verification

After replacement, verify no instances remain:

```bash
# Search for remaining PROJECT_NAME instances
grep -r "PROJECT_NAME" . --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=venv

# Should return no results (or only in this TEMPLATE_VARIABLES.md file)
```

## Additional Customizations

### Image Names

Update Docker image names in `.github/workflows/build-and-push.yml`:

**Single component:**
```yaml
env:
  IMAGE_NAME: ghcr.io/raolivei/YOUR_PROJECT_NAME
```

**Multi-component:**
```yaml
env:
  IMAGE_NAME_API: ghcr.io/raolivei/YOUR_PROJECT_NAME-api
  IMAGE_NAME_FRONTEND: ghcr.io/raolivei/YOUR_PROJECT_NAME-frontend
```

### Repository Owner

If your GitHub username differs from `raolivei`, update:

```bash
# Replace in workflow files
find .github/workflows -type f -exec sed -i '' 's/raolivei/YOUR_GITHUB_USERNAME/g' {} \;

# Replace in setup script
sed -i '' 's/raolivei/YOUR_GITHUB_USERNAME/g' github/setup-branch-protection.sh
```

### Branch Names

If your default branch is not `main`, update:

```bash
# Replace in workflow files
find .github/workflows -type f -exec sed -i '' 's/branches:.*main/branches: YOUR_BRANCH/g' {} \;

# Replace in branch protection config
sed -i '' 's/"main"/"YOUR_BRANCH"/g' github/branch-protection-config.json
sed -i '' 's/BRANCH="main"/BRANCH="YOUR_BRANCH"/g' github/setup-branch-protection.sh
```

### Paths

Update workflow path triggers to match your project structure:

**In `.github/workflows/build-and-push.yml`:**
```yaml
paths:
  - "backend/**"      # Update to your source paths
  - "frontend/**"    # Update to your source paths
  - "src/**"         # Add as needed
```

**In `.github/workflows/ci.yml`:**
```yaml
paths:
  - "backend/**"
  - "frontend/**"
  - "src/**"
```

## Monitoring Configuration

The `monitoring.yaml` file defines how Grafana dashboards are generated for your application.

### Files Requiring Updates

| File | Fields to Update | Description |
|------|------------------|-------------|
| `monitoring.yaml` | `app.name`, `app.namespace` | Application identity |
| `monitoring.yaml` | `app.components.*` | Service names and ports |
| `.github/workflows/generate-dashboard.yml` | N/A (auto-configured) | Dashboard generation |

### Update Monitoring Config

```bash
# Edit monitoring.yaml
vi monitoring.yaml

# Replace placeholders:
# - [PROJECT_NAME] → Your App Name (title case)
# - [project-name] → your-namespace (lowercase)
# - Service names → actual k8s service names
```

See `workspace-config/monitoring/README.md` for full documentation.

## Complete Replacement Checklist

- [ ] Replace `PROJECT_NAME` with actual project name
- [ ] Update image names in `build-and-push.yml`
- [ ] Update repository owner (if different from `raolivei`)
- [ ] Update branch names (if different from `main`)
- [ ] Update workflow paths to match project structure
- [ ] Update `github/setup-branch-protection.sh` with repository name
- [ ] Update badge URLs in `README.md` (uncomment and update)
- [ ] Update `monitoring.yaml` with app-specific configuration
- [ ] Copy `github/workflows/generate-dashboard.yml` to `.github/workflows/`
- [ ] Verify no `PROJECT_NAME` instances remain
- [ ] Test workflows with a test PR

## Examples

### Example: Single-Component Project

**Project:** `my-api`

```bash
# Run replacement
./scripts/setup-new-repo.sh my-api

# Results:
# - Image name: ghcr.io/raolivei/my-api
# - Repository: raolivei/my-api
# - All PROJECT_NAME replaced with my-api
```

### Example: Multi-Component Project

**Project:** `my-app` with `api` and `frontend` components

```bash
# Run replacement
./scripts/setup-new-repo.sh my-app

# Then manually update build-and-push.yml:
env:
  IMAGE_NAME_API: ghcr.io/raolivei/my-app-api
  IMAGE_NAME_FRONTEND: ghcr.io/raolivei/my-app-frontend
```

## Troubleshooting

### Replacement Didn't Work

1. **Check file permissions:**
   ```bash
   ls -la scripts/setup-new-repo.sh
   chmod +x scripts/setup-new-repo.sh
   ```

2. **Verify script exists:**
   ```bash
   ls -la scripts/
   ```

3. **Run manually:**
   ```bash
   find . -type f -name "*.yml" -o -name "*.yaml" -o -name "*.md" -o -name "*.sh" | \
     xargs sed -i '' 's/PROJECT_NAME/your-project/g'
   ```

### Some Files Not Updated

Some files may intentionally keep `PROJECT_NAME` as examples:
- `TEMPLATE_VARIABLES.md` (this file)
- `SETUP.md` (contains examples)
- `README.md` (contains examples)

These are documentation files and should keep examples for reference.

## Support

If you encounter issues with template variable replacement:
1. Check this document for the correct variable names
2. Review `SETUP.md` for detailed instructions
3. Use the automated script: `./scripts/setup-new-repo.sh`
4. Verify replacements with: `grep -r "PROJECT_NAME" .`













