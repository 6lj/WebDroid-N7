# Ultra-Fast Android Boot Script - Maximum Performance
Write-Host "🚀 Ultra-Fast Android Boot - Maximum Performance Mode"
Write-Host "Memory: 12GB, CPU: 6 cores, Optimized for speed"

# Enable Docker optimizations
$env:DOCKER_BUILDKIT=1
$env:COMPOSE_DOCKER_CLI_BUILD=1

# Use performance configuration
Write-Host "Using performance-optimized configuration..."
docker-compose -f docker-compose.performance.yml up --build
