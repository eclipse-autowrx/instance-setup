# Setting Up Your Own Playground Instance

## Overview

The **playground.digital.auto** is an open, web-based prototyping environment designed for developing **Software-Defined Vehicle (SDV)** solutions.

The playground consists of some primary components:

- **Frontend**: [autowrx repo](https://github.com/eclipse-autowrx/autowrx): Frontend application built with Vite and React
- **Backend**: [backend-core repo](https://github.com/eclipse-autowrx/backend-core): Backend services built with Node.js, Express, and MongoDB
- **Inventory**: [inventory repo](https://github.com/eclipse-autowrx/inventory): Schema and instance data management system

The entire platform is containerized using Docker, making it easy to deploy and develop across different environments.

![Architecture](https://bewebstudio.digitalauto.tech/data/projects/nTcRsgxcDWgr/instance_setup/Architecture.jpg)

## Project Structure

```
.
├── autowrx/                  # Frontend application
├── backend-core/             # Core backend services
├── inventory/                # Schema and instance management
├── docker-compose.yml        # Base Docker Compose configuration
├── docker-compose.dev.yml    # Development environment configuration
├── docker-compose.prod.yml   # Production environment configuration
└── nginx.conf                # Nginx configuration
```

## Prerequisites

Before setting up your playground instance, ensure you have the following installed:

### Required Software

- **Docker** and **Docker Compose**
- **Git** (for cloning repositories)

### Optional (for local development)

- **Node.js** (v18+)
- **Yarn** package manager

### System Requirements

| Component | Minimum                  | Recommended |
| --------- | ------------------------ | ----------- |
| CPU       | 2 cores                  | 4 cores     |
| RAM       | 3 GiB                    | 4 GiB       |
| Disk      | 10 GiB                   | 20 GiB      |
| OS        | Any Docker-compatible OS | Linux/macOS |

> Memory Usage Note: The `KONG_SVC_NGINX_WORKER_PROCESSES` variable defaults to `auto`, which creates worker processes based on your CPU cores. This will consume memory proportional to your system specifications. If you're working with limited memory, you can reduce this by setting it to a specific number (e.g., 1 or 2) in your .env file.

## Setup Instructions

1. Clone the repository:

   ```bash
   git clone https://github.com/eclipse-autowrx/instance-setup playground
   cd playground
   ```

2. Initialize Submodules (Optional for Development):

   If you plan to do local development:

   ```bash
   git submodule update --init --remote --recursive
   ```

### Development Environment Setup

3. Set up environment variables for development:

   Create `.env` file from `.env.example` template:

   ```bash
   cp .env.example .env
   ```

   The default values in `.env.example` are suitable for development environments.

4. Start the Development Platform:

   ```bash
   docker compose -f docker-compose.yml -f docker-compose.dev.yml up
   ```

### Production Environment Setup

3. Set up environment variables for production:

   Create `.env` file from `.env.example` template:

   ```bash
   cp .env.example .env
   ```

   **⚠️ Important Production Configuration:**

   Before starting the production environment, you must edit the `.env` file and update the following variables:

   - **`JWT_COOKIE_DOMAIN`**: Set this to match your production domain.
     - Example: `yourdomain.com`
     - **Important**: Use only the domain name without the protocol scheme.
       - ❌ Invalid: `https://yourdomain.com`
       - ✅ Valid: `yourdomain.com`
   - **`NODE_ENV`**: Set to `production`
   - **Security variables**: Update any default passwords, secrets, or API keys
   - (Optional) Database configuration: Configure production database settings if using external databases

4. Start the Production Platform:

   ```bash
   docker compose up -d
   ```

## Accessing Your Platform

Once the containers are running, you can access:

| Service                  | URL                                         | Description                  |
| ------------------------ | ------------------------------------------- | ---------------------------- |
| **Main Application**     | http://localhost:3000                       | Primary playground interface |
| **Inventory Management** | http://localhost:3001                       | Schema and data management   |
| **API Documentation**    | http://localhost:3000/api/v2/inventory/docs | Swagger/OpenAPI docs         |
| **Backend API**          | http://localhost:3000/api/v2                | Direct API access            |

### Development-Only URLs

When running in development mode, additional services are available:

| Service                 | URL                   | Description            |
| ----------------------- | --------------------- | ---------------------- |
| **Frontend Dev Server** | http://localhost:3002 | Direct frontend access |

## API Documentation

The backend APIs are documented using Swagger/OpenAPI:

- Inventory API: http://localhost:3000/api/v2/inventory/docs

## Security Considerations

- All API endpoints are secured with JWT authentication
- Sensitive environment variables should be properly secured in production

## Troubleshooting

This section includes troubleshooting tips you might find helpful when setting up your Playground instance

### Docker Images Not Reflecting Updates

**Problem**: Changes to code aren't reflected in running containers.

**Solution**: Rebuild images with the `--build` flag:

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build
```

### Container Name Conflicts

**Problem**: Error message about containers already existing.

**Solutions**:

**Option 1**: Use project names to avoid conflicts:

```bash
docker compose --project-name my-playground -f docker-compose.yml -f docker-compose.dev.yml up
```

**Option 2**: Remove existing containers:

```bash
docker compose down
docker container prune
```

## License

Copyright (c) 2025 Robert Bosch GmbH.

This program and the accompanying materials are made available under the
terms of the MIT License which is available at
https://opensource.org/licenses/MIT.

SPDX-License-Identifier: MIT
