# Examples

This directory contains example configuration files to help you get started with your project.

## Files

- **Dockerfile**: Multi-stage Docker build example with best practices
- **docker-compose.yml**: Docker Compose setup for local development
- **k8s/**: Kubernetes manifests for deployment
  - `deployment.yaml`: Deployment configurations
  - `service.yaml`: Service definitions
  - `ingress.yaml`: Ingress configuration with TLS
- **.env.template**: Environment variables template

## Usage

### Dockerfile

Copy and customize the Dockerfile for your application:

```bash
cp examples/Dockerfile ./Dockerfile
# Or for subdirectories
cp examples/Dockerfile ./backend/Dockerfile
```

### Docker Compose

For local development:

```bash
cp examples/docker-compose.yml ./docker-compose.yml
cp examples/.env.template ./.env
# Edit .env with your values
docker-compose up -d
```

### Kubernetes

Deploy to Kubernetes:

```bash
# Create namespace
kubectl apply -f examples/k8s/ingress.yaml

# Create secrets (update with your values)
kubectl create secret generic PROJECT_NAME-secrets \
  --from-literal=database-url='postgresql://...' \
  --from-literal=redis-url='redis://...' \
  -n PROJECT_NAME

# Create image pull secret for GHCR
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=YOUR_GITHUB_USERNAME \
  --docker-password=YOUR_GITHUB_TOKEN \
  -n PROJECT_NAME

# Apply deployments and services
kubectl apply -f examples/k8s/deployment.yaml
kubectl apply -f examples/k8s/service.yaml
kubectl apply -f examples/k8s/ingress.yaml
```

### Environment Variables

Copy the template and fill in your values:

```bash
cp examples/.env.template .env
# Edit .env with your actual values
# Never commit .env to version control!
```

## Customization

Remember to replace `PROJECT_NAME` in all example files with your actual project name:

```bash
# Replace PROJECT_NAME in examples
find examples -type f -exec sed -i '' 's/PROJECT_NAME/your-project/g' {} \;
```

## Notes

- These are **examples only** - customize them for your specific needs
- Update resource limits based on your application requirements
- Adjust health check endpoints to match your application
- Configure TLS certificates according to your setup
- Review security settings before deploying to production












