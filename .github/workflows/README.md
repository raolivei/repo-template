# GitHub Actions Workflows

This directory contains CI/CD workflows for automated testing, building, and security scanning.

## Workflows

### `security-scan.yml`

Automated security scanning that runs on:
- Every push to `main` and `dev` branches
- Every pull request to `main`
- Weekly schedule (Mondays at midnight UTC)
- Manual trigger via `workflow_dispatch`

**Jobs:**
- **codeql-analysis**: Static code analysis for security vulnerabilities
- **dependency-scan**: Scans npm and pip dependencies for known vulnerabilities
- **container-scan**: Scans Dockerfiles and container images using Trivy
- **secret-scan**: Basic secret pattern detection in git history

**Permissions:**
- `contents: read` - Read repository contents
- `security-events: write` - Upload security findings to GitHub Security tab

### `build-and-push.yml`

Builds and pushes Docker images to GitHub Container Registry (GHCR).

**Triggers:**
- Push to `main` or `dev` branches
- Git tags matching `v*` pattern
- Pull requests to `main` (build only, no push)
- Manual trigger with optional tag input

**Features:**
- Multi-platform builds (linux/amd64, linux/arm64)
- Automatic semantic versioning from `VERSION` file
- Image tagging strategy:
  - `main` branch → `main`, `latest`, `main-<sha>` tags
  - `dev` branch → `dev`, `dev-<sha>` tags
  - Git tags `v1.2.3` → `v1.2.3`, `v1.2`, `v1`, `<sha>` tags
  - PRs → `pr-<number>` (build only, no push)
- Post-build vulnerability scanning with Trivy
- Results uploaded to GitHub Security tab

**Required Secrets:**
- `CR_PAT`: GitHub Container Registry Personal Access Token with `write:packages` permission

### `ci.yml`

Continuous Integration workflow for code quality checks.

**Triggers:**
- Pull requests to `main` or `dev`
- Push to `dev` branch
- Manual trigger

**Jobs:**
- **lint**: Code linting (Python: ruff, mypy; Node.js: ESLint)
- **type-check**: Type checking (Python: mypy; Node.js: TypeScript)
- **test**: Test execution (Python: pytest; Node.js: npm test)
- **build**: Docker image build verification (no push)

**Features:**
- Automatic detection of Python/Node.js projects
- Caching for faster builds
- Continues on error for non-critical checks

## Image Tagging Strategy

Images are tagged based on the trigger:

| Trigger | Tags |
|---------|------|
| `main` branch push | `main`, `latest`, `main-<sha>` |
| `dev` branch push | `dev`, `dev-<sha>` |
| Git tag `v1.2.3` | `v1.2.3`, `v1.2`, `v1`, `<sha>` |
| Pull request #42 | `pr-42` (build only) |
| Manual with tag input | Custom tag |

## Required GitHub Secrets

### `CR_PAT`
GitHub Container Registry Personal Access Token

**How to create:**
1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token with `write:packages` and `read:packages` permissions
3. Add as repository secret named `CR_PAT`

### Optional Secrets

Add any other secrets your project needs:
- Database credentials
- API keys
- OAuth tokens
- etc.

## Customization

### Update Workflow Paths

Edit workflow files to match your project structure:

```yaml
# In build-and-push.yml
paths:
  - "backend/**"      # Update to your source paths
  - "frontend/**"     # Update to your source paths
```

### Update Status Checks

After customizing workflows, update branch protection:

1. Edit `github/branch-protection-config.json`
2. Update `contexts` array with your workflow job names
3. Run `./github/setup-branch-protection.sh`

### Add Language-Specific Checks

Edit `ci.yml` to add checks for your stack:
- Go: `golangci-lint`, `go test`
- Rust: `cargo clippy`, `cargo test`
- Java: `mvn checkstyle`, `mvn test`
- etc.

## Troubleshooting

### Workflow Not Running

**Symptoms:** Workflow doesn't appear in Actions tab or doesn't trigger on expected events

**Solutions:**
1. **Check workflow file syntax:**
   ```bash
   # Validate YAML syntax
   yamllint .github/workflows/*.yml
   # Or use GitHub's workflow validator
   ```

2. **Verify trigger conditions:**
   - Check branch names match (`main` vs `master`)
   - Verify path filters match your project structure
   - Ensure workflow file is in `.github/workflows/` directory

3. **Check GitHub Actions is enabled:**
   - Repository Settings → Actions → General
   - Ensure "Allow all actions" is selected

4. **Verify workflow file permissions:**
   ```bash
   ls -la .github/workflows/
   # Files should be readable
   ```

### Build Failures

**Symptoms:** Build job fails with Docker or build errors

**Solutions:**
1. **Test Dockerfile locally:**
   ```bash
   docker build -t test-image -f Dockerfile .
   # Or for subdirectory
   docker build -t test-image -f backend/Dockerfile ./backend
   ```

2. **Verify build context paths:**
   ```yaml
   # In build-and-push.yml
   context: ./backend      # Must match Dockerfile location
   file: ./backend/Dockerfile
   ```

3. **Check for missing dependencies:**
   - Review Dockerfile for base images
   - Verify all required files are in build context
   - Check COPY/ADD commands reference correct paths

4. **Review workflow logs:**
   - Go to Actions → Failed workflow → Build job
   - Expand "Build and push Docker image" step
   - Look for specific error messages

5. **Common build issues:**
   - **Context path wrong:** Ensure `context` matches directory containing Dockerfile
   - **Missing files:** Verify all files referenced in Dockerfile exist
   - **Platform issues:** Check `platforms` setting matches your needs
   - **Cache issues:** Try disabling cache temporarily: `cache-from: ""`

### Security Scan Failures

**Symptoms:** Security scanning jobs fail or report errors

**Solutions:**

1. **CodeQL Analysis fails:**
   - Ensure language is in matrix: `language: ['javascript', 'python']`
   - Check CodeQL supports your language version
   - Verify source code is accessible (not in .gitignore)

2. **Dependency scan fails:**
   - Verify package files exist: `package-lock.json`, `requirements.txt`
   - Check files are in expected locations
   - Ensure package manager is available in workflow

3. **Container scan fails:**
   - Verify Dockerfile exists and is valid
   - Check image was built successfully before scanning
   - Review Trivy output for specific vulnerabilities

### CI Job Failures

**Symptoms:** Lint, test, or type-check jobs fail

**Solutions:**

1. **Linting fails:**
   - Install linting tools locally and run: `npm run lint` or `ruff check .`
   - Fix linting errors or update lint configuration
   - Check if linting tools are in dependencies

2. **Tests fail:**
   - Run tests locally: `npm test` or `pytest`
   - Verify test dependencies are installed
   - Check test configuration matches local setup

3. **Type checking fails:**
   - Run type checker locally: `npm run type-check` or `mypy .`
   - Fix type errors or add type ignores
   - Verify TypeScript/mypy configuration

### Image Push Failures

**Symptoms:** Build succeeds but push to GHCR fails

**Solutions:**

1. **Authentication issues:**
   - Verify `CR_PAT` secret is set correctly
   - Check token has `write:packages` permission
   - Ensure token is not expired

2. **Image name issues:**
   - Verify image name format: `ghcr.io/OWNER/REPO`
   - Check repository exists and you have write access
   - Ensure image name matches repository name

3. **Permission issues:**
   - Check repository visibility (public/private)
   - Verify GitHub Actions permissions in repository settings
   - Ensure workflow has `packages: write` permission

### Workflow Timeout

**Symptoms:** Workflows take too long or timeout

**Solutions:**

1. **Optimize Docker builds:**
   - Use multi-stage builds
   - Leverage build cache (`cache-from: type=gha`)
   - Minimize build context size

2. **Parallelize jobs:**
   - Run independent jobs in parallel
   - Use job dependencies (`needs:`) appropriately

3. **Increase timeout (if needed):**
   ```yaml
   timeout-minutes: 30  # Default is 360 minutes
   ```

## Customization Examples

### Adding a New Language

**For Go projects:**

1. Update `security-scan.yml`:
   ```yaml
   matrix:
     language: ['javascript', 'python', 'go']
   ```

2. Add Go checks to `ci.yml`:
   ```yaml
   - name: Set up Go
     if: hashFiles('go.mod') != ''
     uses: actions/setup-go@v5
     with:
       go-version: '1.21'
   
   - name: Run Go linting
     if: hashFiles('go.mod') != ''
     run: |
       go install golangci-lint/cmd/golangci-lint@latest
       golangci-lint run
   ```

### Multi-Component Build

**For projects with api and frontend:**

1. Update `build-and-push.yml` env:
   ```yaml
   env:
     IMAGE_NAME_API: ghcr.io/raolivei/PROJECT_NAME-api
     IMAGE_NAME_FRONTEND: ghcr.io/raolivei/PROJECT_NAME-frontend
   ```

2. Uncomment and customize multi-component build jobs
3. Update paths to match your structure

### Custom Build Arguments

**Add build-time variables:**

```yaml
build-args: |
  BUILD_VERSION=${{ steps.package-version.outputs.version }}
  NODE_ENV=production
  API_URL=${{ secrets.API_URL }}
```

## Best Practices

1. **Use semantic versioning:** Always update VERSION file before tagging releases
2. **Test locally first:** Run workflows locally before pushing
3. **Monitor security scans:** Review Security tab regularly
4. **Keep dependencies updated:** Let Dependabot handle updates
5. **Use branch protection:** Enforce PR reviews and status checks
6. **Document changes:** Update CHANGELOG.md for significant changes
7. **Optimize builds:** Use caching and multi-stage Dockerfiles

### Security Scan Issues

- CodeQL: Ensure language is in matrix
- Dependency scan: Verify package manager files exist
- Container scan: Check Dockerfile exists and is valid

### Permission Errors

- Verify GitHub secrets are set correctly
- Check repository settings allow GitHub Actions
- Ensure PAT has required permissions

