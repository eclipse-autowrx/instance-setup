# Configuration Documentation

This document describes the configuration options and environment variables for the Kong API Gateway setup.

## Environment Variables

| Variable       | Description                                  | Default | Required |
| -------------- | -------------------------------------------- | ------- | -------- |
| `CORS_ORIGINS` | Comma-separated list of allowed CORS origins | None    | No       |

## Kong Configuration

The Kong gateway is configured using a declarative configuration file (`kong.yml`) that is generated from the template at startup.

### Base Configuration

| Setting            | Value                | Description                    |
| ------------------ | -------------------- | ------------------------------ |
| Database           | Off                  | Running in DB-less mode        |
| Declarative Config | `/etc/kong/kong.yml` | Path to the configuration file |
| Plugins            | bundled,custom-auth  | Enabled plugins                |

## Services

### inventory-be

| Setting      | Value           | Description                 |
| ------------ | --------------- | --------------------------- |
| Host         | inventory-be    | Service hostname            |
| Port         | 3001            | Service port                |
| Protocol     | HTTP            | Protocol for communication  |
| Read Timeout | 180000 ms       | Timeout for read operations |
| Route Path   | `/v2/inventory` | Base path for routing       |

### playground-be (main)

| Setting      | Value                | Description                 |
| ------------ | -------------------- | --------------------------- |
| Host         | playground-be        | Service hostname            |
| Port         | 8080                 | Service port                |
| Protocol     | HTTP                 | Protocol for communication  |
| Read Timeout | 180000 ms            | Timeout for read operations |
| Routes       | Multiple (see below) |                             |

#### Routes

1. **deny_authorization_route**

   - Path: `/v2/auth/authorize`
   - Plugin: request-termination (403 Forbidden)

2. **main_route**
   - Handles all standard HTTP methods

## Plugins

### Rate Limiting

| Setting     | Value           | Description                   |
| ----------- | --------------- | ----------------------------- |
| Enabled     | true            | Plugin status                 |
| Limit By    | header          | Rate limiting strategy        |
| Header Name | x-forwarded-for | Header used for rate limiting |
| Minute      | 240             | Requests allowed per minute   |
| Policy      | local           | Storage policy                |

### CORS

| Setting     | Value                                 | Description                            |
| ----------- | ------------------------------------- | -------------------------------------- |
| Origins     | Configured via `CORS_ORIGINS` env var | Allowed origins                        |
| Headers     | Multiple standard headers             | Allowed headers                        |
| Credentials | true                                  | Allow credentials                      |
| Max Age     | 3600                                  | Preflight results cache time (seconds) |

### Custom Auth Plugin

| Setting         | Value                                          | Description                                          |
| --------------- | ---------------------------------------------- | ---------------------------------------------------- |
| URL             | http://playground-be:8080/v2/auth/authenticate | Authentication endpoint                              |
| Protected Paths | `^/v2/inventory/.*$`                           | Regex patterns for paths that require authentication |

## Startup Process

The startup script (startup.sh) performs the following operations:

1. Processes the `CORS_ORIGINS` environment variable and formats it for the Kong configuration
2. Generates the final `kong.yml` from the template
3. Validates the configuration
4. Starts Kong if validation passes

## Development Notes

- Custom authentication plugin is implemented in Lua
- Protected paths are defined in the plugin configuration
- Authentication headers are forwarded to the authentication service
