# Repository Template Index

## 📁 Directory Structure

```
repo-template/
├── .github/
│   ├── workflows/
│   │   ├── security-scan.yml      # Security scanning (CodeQL, Trivy, etc.)
│   │   ├── build-and-push.yml      # Docker build and push to GHCR
│   │   ├── ci.yml                  # Continuous integration (lint, test, build)
│   │   └── README.md               # Workflow documentation
│   ├── dependabot.yml              # Automated dependency updates
│   └── SECURITY.md                 # Security policy template
├── github/
│   ├── branch-protection-config.json  # Branch protection rules
│   └── setup-branch-protection.sh     # Automated setup script
├── .gitignore                      # Comprehensive ignore patterns
├── VERSION                         # Semantic version file (0.1.0)
├── CHANGELOG.md                    # Change log template
├── README.md                       # Template overview
├── SETUP.md                        # Detailed setup instructions
├── TEMPLATE_SUMMARY.md             # Analysis and comparison
├── QUICK_REFERENCE.md              # Quick reference guide
└── INDEX.md                        # This file
```

## 📚 Documentation Guide

### For First-Time Setup
1. **START HERE**: Read `README.md` for overview
2. **SETUP**: Follow `SETUP.md` step-by-step
3. **QUICK REFERENCE**: Use `QUICK_REFERENCE.md` for commands

### For Understanding
- **TEMPLATE_SUMMARY.md**: Analysis of existing repos and improvements
- **.github/workflows/README.md**: Detailed workflow documentation

### For Customization
- **SETUP.md**: Section "Step 2: Update Configuration"
- **QUICK_REFERENCE.md**: Customization checklist

## 🔧 Key Files to Customize

| File | What to Change |
|------|----------------|
| `github/setup-branch-protection.sh` | `REPO_NAME="PROJECT_NAME"` |
| `.github/workflows/build-and-push.yml` | `IMAGE_NAME`, `context`, `file` paths |
| `.github/workflows/*.yml` | `paths:` triggers, job names |
| `github/branch-protection-config.json` | `contexts:` array (workflow job names) |
| `.gitignore` | Add project-specific patterns |

## 🚀 Quick Start

```bash
# 1. Copy template
cp -r repo-template/* /path/to/new-repo/

# 2. Update PROJECT_NAME
find . -type f -exec sed -i '' 's/PROJECT_NAME/your-repo/g' {} \;

# 3. Set up branch protection (after first push)
./github/setup-branch-protection.sh
```

## 🔒 Security Features

- ✅ CodeQL static analysis
- ✅ Dependency vulnerability scanning
- ✅ Container image scanning (Trivy)
- ✅ Secret pattern detection
- ✅ Dependabot automated updates
- ✅ Branch protection rules
- ✅ Security policy template

## 📋 Workflow Overview

### Security Scanning (`security-scan.yml`)
- CodeQL analysis
- Dependency scanning (npm, pip)
- Container scanning
- Secret detection

### Build & Push (`build-and-push.yml`)
- Multi-platform Docker builds
- Semantic versioning
- Image vulnerability scanning
- GHCR push

### CI (`ci.yml`)
- Linting (Python, Node.js)
- Type checking
- Test execution
- Build verification

## 🎯 Next Steps

1. **Read** `SETUP.md` for detailed instructions
2. **Customize** configuration files
3. **Set up** GitHub secrets
4. **Run** branch protection setup
5. **Test** workflows with a PR

## 📖 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Dependabot Documentation](https://docs.github.com/en/code-security/dependabot)
- [CodeQL Documentation](https://codeql.github.com/docs/)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)

## ❓ Need Help?

1. Check `QUICK_REFERENCE.md` for common issues
2. Review `SETUP.md` troubleshooting section
3. Check workflow logs in GitHub Actions
4. Review `.github/workflows/README.md` for workflow details

