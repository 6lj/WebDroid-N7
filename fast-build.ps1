# Ultra-fast build script with maximum performance optimizations
Write-Host "Ultra-fast build with performance optimizations..."
Write-Host "Memory: 8GB, CPU: 4 cores, Optimized for speed"

# Enable Docker BuildKit for faster builds
$env:DOCKER_BUILDKIT=1
$env:COMPOSE_DOCKER_CLI_BUILD=1

# Build with parallel processing
docker-compose -f docker-compose.bliss.yml build --parallel

# Start with high performance
docker-compose -f docker-compose.bliss.yml up
