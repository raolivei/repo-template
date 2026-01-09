# Contributing Guidelines

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to this project.

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the project
- Show empathy towards other contributors

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/PROJECT_NAME.git
   cd PROJECT_NAME
   ```
3. **Set up upstream remote**:
   ```bash
   git remote add upstream https://github.com/raolivei/PROJECT_NAME.git
   ```
4. **Create a branch** for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bug-fix
   ```

## Development Workflow

### Branch Naming

Use descriptive branch names:
- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation updates
- `refactor/description` - Code refactoring
- `test/description` - Test additions/updates

### Making Changes

1. **Make your changes** in your feature branch
2. **Write/update tests** if applicable
3. **Update documentation** if needed
4. **Run tests locally**:
   ```bash
   # Python
   pytest
   
   # Node.js
   npm test
   ```
5. **Run linters**:
   ```bash
   # Python
   ruff check .
   mypy .
   
   # Node.js
   npm run lint
   ```

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Test additions/changes
- `chore`: Maintenance tasks

**Examples:**
```
feat(api): add user authentication endpoint

Implements JWT-based authentication for user login.
Adds /api/v1/auth/login endpoint with token generation.

Closes #123
```

```
fix(frontend): resolve memory leak in component cleanup

The useEffect hook was not properly cleaning up event listeners,
causing memory leaks on component unmount.

Fixes #456
```

### Pull Request Process

1. **Update your branch** with latest changes:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Push your changes**:
   ```bash
   git push origin feature/your-feature-name
   ```

3. **Create a Pull Request** on GitHub:
   - Fill out the PR template
   - Link related issues
   - Request reviews from maintainers

4. **Ensure all checks pass**:
   - CI workflows must pass
   - Security scans must pass
   - Code review approval required

5. **Address review feedback**:
   - Make requested changes
   - Push updates to your branch
   - PR will update automatically

## Code Style

### Python

- Follow [PEP 8](https://pep8.org/) style guide
- Use type hints where applicable
- Maximum line length: 100 characters
- Use `ruff` for linting
- Use `mypy` for type checking

**Example:**
```python
from typing import Optional

def process_data(data: list[str], limit: Optional[int] = None) -> dict[str, int]:
    """Process data and return statistics.
    
    Args:
        data: List of data items to process
        limit: Optional limit on number of items
        
    Returns:
        Dictionary with processing statistics
    """
    if limit:
        data = data[:limit]
    return {"count": len(data), "processed": True}
```

### JavaScript/TypeScript

- Follow [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- Use ESLint for linting
- Use TypeScript for type safety
- Use Prettier for formatting (if configured)

**Example:**
```typescript
interface User {
  id: string;
  name: string;
  email: string;
}

async function fetchUser(id: string): Promise<User> {
  const response = await fetch(`/api/users/${id}`);
  if (!response.ok) {
    throw new Error(`Failed to fetch user: ${response.statusText}`);
  }
  return response.json();
}
```

### Docker

- Use multi-stage builds when possible
- Minimize image size
- Use specific version tags for base images
- Document build arguments

**Example:**
```dockerfile
# Build stage
FROM python:3.11-slim as builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Runtime stage
FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY . .
ENV PATH=/root/.local/bin:$PATH
CMD ["python", "app.py"]
```

## Testing

### Writing Tests

- Write tests for new features
- Write tests for bug fixes
- Aim for good test coverage
- Use descriptive test names

**Python example:**
```python
import pytest
from app import process_data

def test_process_data_with_limit():
    data = ["item1", "item2", "item3"]
    result = process_data(data, limit=2)
    assert result["count"] == 2

def test_process_data_without_limit():
    data = ["item1", "item2"]
    result = process_data(data)
    assert result["count"] == 2
```

**JavaScript example:**
```javascript
import { fetchUser } from './api';

describe('fetchUser', () => {
  it('should fetch user by id', async () => {
    const user = await fetchUser('123');
    expect(user.id).toBe('123');
    expect(user.name).toBeDefined();
  });

  it('should throw error for invalid id', async () => {
    await expect(fetchUser('invalid')).rejects.toThrow();
  });
});
```

### Running Tests

```bash
# Python
pytest
pytest --cov=. --cov-report=html

# Node.js
npm test
npm run test:coverage
```

## Documentation

- Update README.md for user-facing changes
- Update CHANGELOG.md for all changes
- Add code comments for complex logic
- Update API documentation if applicable

### CHANGELOG Format

Follow [Keep a Changelog](https://keepachangelog.com/) format:

```markdown
## [1.2.0] - 2024-01-15

### Added
- New feature: User authentication endpoint
- API documentation in `/docs` directory

### Changed
- Updated dependency versions
- Improved error messages

### Fixed
- Memory leak in component cleanup
- Authentication token expiration issue

### Removed
- Deprecated API endpoint `/api/v1/old-endpoint`
```

## Security

- **Never commit secrets** (API keys, passwords, tokens)
- Use environment variables or secrets management
- Report security vulnerabilities privately (see SECURITY.md)
- Follow secure coding practices

## Questions?

- Open an issue for bug reports or feature requests
- Check existing documentation
- Review closed issues/PRs for similar questions

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md (if applicable)
- Credited in release notes for significant contributions
- Acknowledged in the project README

Thank you for contributing! 🎉











