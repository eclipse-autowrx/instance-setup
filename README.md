# Setting Up Your Own Playground Instance

## Overview

The **playground.digital.auto** is an open, web-based prototyping environment designed for developing **Software-Defined Vehicle (SDV)** solutions.

The playground consists of two primary components:

- **Frontend**: [GitLab autowrx frontend](https://gitlab.eclipse.org/eclipse/autowrx/autowrx)
- **Backend**: [GitLab autowrx backend-core](https://gitlab.eclipse.org/eclipse/autowrx/backend-core)

All services run entirely within Docker containers.

![Architecture](https://bewebstudio.digitalauto.tech/data/projects/nTcRsgxcDWgr/instance_setup/Architecture.jpg)

## Running the application

### Using Docker

1. Clone the repository:

   ```bash
   git clone git@gitlab.eclipse.org:eclipse/autowrx/instance-setup.git playground
   ```

2. Navigate to the project folder:

   ```bash
   cd playground
   ```

3. Set up environment variables:

   - Create `.env` file from `.env.example` template:

     ```bash
         cp .env.example .env
     ```

   - Open `.env` and update the required environment variables as needed.

4. Start the services with Docker Compose

   ```bash
   docker compose up -d
   ```
