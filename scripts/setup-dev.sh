#!/bin/bash

# StreetRacer Development Setup Script

set -e

echo "🏁 Setting up StreetRacer development environment..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose > /dev/null 2>&1; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose and try again."
    exit 1
fi

echo "✅ Docker is running"

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p backend/logs
mkdir -p keycloak/import

# Start infrastructure services first
echo "🚀 Starting infrastructure services..."
docker-compose -f docker-compose.dev.yml up -d postgres redis elasticsearch minio keycloak rabbitmq

# Wait for services to be healthy
echo "⏳ Waiting for services to be ready..."
sleep 30

# Check service health
echo "🔍 Checking service health..."
docker-compose -f docker-compose.dev.yml ps

# Start backend
echo "🔧 Starting backend service..."
docker-compose -f docker-compose.dev.yml up -d backend

# Wait for backend to be ready
echo "⏳ Waiting for backend to be ready..."
sleep 20

# Start frontend
echo "🎨 Starting frontend service..."
docker-compose -f docker-compose.dev.yml up -d frontend

echo "✅ Development environment is ready!"
echo ""
echo "🌐 Services are available at:"
echo "  - Frontend: http://localhost:3000"
echo "  - Backend API: http://localhost:5000"
echo "  - Keycloak: http://localhost:8080 (admin/admin)"
echo "  - MinIO Console: http://localhost:9001 (minio/minio123)"
echo "  - RabbitMQ Management: http://localhost:15672 (streetracer/password)"
echo "  - Kibana: http://localhost:5601"
echo ""
echo "📊 To view logs:"
echo "  docker-compose -f docker-compose.dev.yml logs -f [service-name]"
echo ""
echo "🛑 To stop all services:"
echo "  docker-compose -f docker-compose.dev.yml down"