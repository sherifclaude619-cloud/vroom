#!/bin/bash

# StreetRacer Cleanup Script

set -e

echo "🧹 Cleaning up StreetRacer development environment..."

# Stop all services
echo "🛑 Stopping all services..."
docker-compose -f docker-compose.dev.yml down

# Remove containers
echo "🗑️ Removing containers..."
docker-compose -f docker-compose.dev.yml rm -f

# Remove images (optional)
read -p "Do you want to remove Docker images? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🗑️ Removing Docker images..."
    docker-compose -f docker-compose.dev.yml down --rmi all
fi

# Remove volumes (optional)
read -p "Do you want to remove Docker volumes (this will delete all data)? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🗑️ Removing Docker volumes..."
    docker-compose -f docker-compose.dev.yml down --volumes
fi

# Clean up Docker system (optional)
read -p "Do you want to run Docker system prune? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🧹 Running Docker system prune..."
    docker system prune -f
fi

echo "✅ Cleanup completed!"