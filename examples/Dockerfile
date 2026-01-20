# Multi-stage Dockerfile Example
# This is a best-practices example for building production Docker images

# Build stage
FROM python:3.11-slim as builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Runtime stage
FROM python:3.11-slim

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /root/.local /root/.local

# Copy application code
COPY . .

# Make sure scripts in .local are usable
ENV PATH=/root/.local/bin:$PATH

# Create non-root user for security
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app
USER appuser

# Expose port (update as needed)
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8000/health')" || exit 1

# Run application
CMD ["python", "app.py"]

# Alternative: For Node.js applications
# FROM node:20-slim as builder
# WORKDIR /app
# COPY package*.json ./
# RUN npm ci --only=production
# 
# FROM node:20-slim
# WORKDIR /app
# COPY --from=builder /app/node_modules ./node_modules
# COPY . .
# EXPOSE 3000
# CMD ["node", "server.js"]













