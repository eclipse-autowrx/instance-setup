#!/bin/bash

# Default values
MODE="dev"
DETACHED=false
BUILD=false

# Function to display usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -prod     Start in production mode"
    echo "  -d        Run in detached mode (background)"
    echo "  -b        Force rebuild of Docker images"
    echo "  -h        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0        # Start in development mode (default)"
    echo "  $0 -prod  # Start in production mode"
    echo "  $0 -d     # Start in development mode, detached"
    echo "  $0 -prod -d -b  # Start in production mode, detached with rebuild"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -prod)
            MODE="prod"
            shift
            ;;
        -d)
            DETACHED=true
            shift
            ;;
        -b)
            BUILD=true
            shift
            ;;
        -h)
            show_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Create .env file if it doesn't exist
if [ ! -f .env ] && [ -f .env.example ]; then
    cp .env.example .env
    echo ".env file created from .env.example"
fi

# Create upload directory if it doesn't exist
UPLOAD_PATH=$(grep "^UPLOAD_SVC_PATH=" .env 2>/dev/null | cut -d'=' -f2 | tr -d '"' | tr -d "'")
if [ -z "$UPLOAD_PATH" ]; then
    UPLOAD_PATH="./data"
fi

if [ ! -d "$UPLOAD_PATH" ]; then
    mkdir -p "$UPLOAD_PATH"
    echo "Created upload directory: $UPLOAD_PATH"
fi

# Install dependencies for development mode
if [ "$MODE" = "dev" ]; then
    echo "Installing dependencies for development mode..."
    
    # Install autowrx dependencies
    if [ -d "autowrx" ] && [ -f "autowrx/package.json" ]; then
        echo "Installing autowrx dependencies..."
        cd autowrx
        if command -v yarn &> /dev/null; then
            yarn install
        else
            npm install
        fi
        cd ..
    fi
    
    # Install backend-core dependencies
    if [ -d "backend-core" ] && [ -f "backend-core/package.json" ]; then
        echo "Installing backend-core dependencies..."
        cd backend-core
        if command -v yarn &> /dev/null; then
            yarn install
        else
            npm install
        fi
        cd ..
    fi
    
    # Install inventory/frontend dependencies
    if [ -d "inventory/frontend" ] && [ -f "inventory/frontend/package.json" ]; then
        echo "Installing inventory/frontend dependencies..."
        cd inventory/frontend
        if command -v yarn &> /dev/null; then
            yarn install
        else
            npm install
        fi
        cd ../..
    fi
    
    # Install inventory/backend dependencies
    if [ -d "inventory/backend" ] && [ -f "inventory/backend/package.json" ]; then
        echo "Installing inventory/backend dependencies..."
        cd inventory/backend
        if command -v yarn &> /dev/null; then
            yarn install
        else
            npm install
        fi
        cd ../..
    fi
    
    echo "Dependencies installation completed."
fi

# Build Docker compose command
DOCKER_CMD="docker compose -f docker-compose.yml"

if [ "$MODE" = "dev" ]; then
    DOCKER_CMD="$DOCKER_CMD -f docker-compose.dev.yml"
fi

DOCKER_CMD="$DOCKER_CMD up"

if [ "$BUILD" = true ]; then
    DOCKER_CMD="$DOCKER_CMD --build"
fi

if [ "$DETACHED" = true ]; then
    DOCKER_CMD="$DOCKER_CMD -d"
fi

# Show what we're doing
echo "Starting Playground in $MODE mode..."
echo "Command: $DOCKER_CMD"

# Execute the command
eval $DOCKER_CMD

# Show access URLs if successful
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Playground started successfully!"
    echo ""
    echo "Access URLs:"
    echo "  Main Application:     http://localhost:3000"
    echo "  Inventory Management: http://localhost:3001"
    echo "  Backend API:          http://localhost:3000/api/v2"
    
    if [ "$MODE" = "dev" ]; then
        echo "  Frontend Dev Server:  http://localhost:3002"
        echo "  API Documentation:    http://localhost:3000/api/v2/inventory/docs"
    fi
    
    echo ""
    echo "To stop: docker compose down"
fi