@echo off
echo 🚀 Ultra-Fast Android Boot - Maximum Performance Mode
echo Memory: 12GB, CPU: 6 cores, Optimized for speed
echo.

REM Enable Docker optimizations
set DOCKER_BUILDKIT=1
set COMPOSE_DOCKER_CLI_BUILD=1

REM Use performance configuration
echo Using performance-optimized configuration...
docker-compose -f docker-compose.performance.yml up --build
