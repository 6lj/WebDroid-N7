#!/bin/bash

echo "🚀 Ultra-Fast Android Boot - Maximum Performance Mode"
echo "Memory: 12GB, CPU: 6 cores, Optimized for speed"
echo

# Enable Docker optimizations
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Use performance configuration
echo "Using performance-optimized configuration..."
docker-compose -f docker-compose.performance.yml up --build
