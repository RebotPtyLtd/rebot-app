# Local Docker Environment Setup

This guide provides clear instructions for building, running, and testing the office management application in a local Docker environment.

## 🏗️ Architecture

The application consists of two main services:
- **SvelteKit Frontend**: Office management web application (with dev and prod versions)
- **Wiremock API**: Mock backend API for development and testing

## 📋 Prerequisites

- Docker Desktop installed and running
- Docker Compose (usually included with Docker Desktop)
- Git (for cloning the repository)

## 🚀 Quick Start

### 1. Clone and Navigate
```bash
git clone <repository-url>
cd rebot-app
```

### 2. Build and Start Services
```bash
# Build all services and start them (dev only, with watch)
docker-compose up --build --watch

# Start production service (and all dev dependencies)
docker-compose --profile prod up --build

# Or build without cache for a clean start
docker-compose build --no-cache
docker-compose up --watch
```

### 3. Verify Services Are Running
```bash
# Check container status
docker-compose ps

# Check logs
docker-compose logs -f
```

## 🔧 Available Commands

### Build Commands
```bash
# Build all services
docker-compose build

# Build specific service
docker-compose build sveltekit-dev
docker-compose build sveltekit-prod
docker-compose build wiremock

# Build without cache (clean build)
docker-compose build --no-cache
```

### Run Commands
```bash
# Start all dev services in foreground with watch (default)
docker-compose up --watch

# Start production service (and all dev dependencies)
docker-compose --profile prod up

# Start only dev or only prod
# (dev is default, prod must be specified)
docker-compose --profile dev up --watch
docker-compose --profile prod up

# Start specific service
# (e.g., just sveltekit-dev)
docker-compose up --watch sveltekit-dev
# (e.g., just sveltekit-prod)
docker-compose --profile prod up sveltekit-prod
# (e.g., just wiremock)
docker-compose up wiremock

# Start with logs visible
docker-compose up --watch

# Start specific service with logs
docker-compose up --watch sveltekit-dev
```

### Stop Commands
```bash
# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v

# Stop and remove images
docker-compose down --rmi all
```

### Log Commands
```bash
# View all logs
docker-compose logs

# View specific service logs
docker-compose logs sveltekit-dev
docker-compose logs sveltekit-prod
docker-compose logs wiremock

# Follow logs in real-time
docker-compose logs -f

# View last 50 lines
docker-compose logs --tail=50
```

## 🧪 Testing Commands

### Test API Endpoints
```bash
# Test login API (dev)
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@example.com", "password": "password123"}'

# Test login API (prod)
curl -X POST http://localhost:3500/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@example.com", "password": "password123"}'

# Test offices API (dev)
curl http://localhost:3000/api/offices
# Test offices API (prod)
curl http://localhost:3500/api/offices

# Test authenticated endpoint (dev)
curl -H "Authorization: Bearer mock-jwt-token-for-admin" \
  http://localhost:3000/api/auth/me
# Test authenticated endpoint (prod)
curl -H "Authorization: Bearer mock-jwt-token-for-admin" \
  http://localhost:3500/api/auth/me

# Test Wiremock directly
curl http://localhost:8080/api/offices
```

### Test Web Application
```bash
# Test main page (dev)
curl http://localhost:3000/
# Test main page (prod)
curl http://localhost:3500/

# Test login page (dev)
curl http://localhost:3000/login
# Test login page (prod)
curl http://localhost:3500/login

# Test office detail page (dev)
curl http://localhost:3000/offices/1
# Test office detail page (prod)
curl http://localhost:3500/offices/1
```

### Health Checks
```bash
# Check if containers are running
docker-compose ps

# Check resource usage
docker stats

# Check container logs for errors
docker-compose logs sveltekit-dev --tail=20
docker-compose logs sveltekit-prod --tail=20
docker-compose logs wiremock --tail=20
```

## 🔍 Troubleshooting

### Common Issues

#### 1. Port Already in Use
```bash
# Check what's using the ports
lsof -i :3000
lsof -i :3500
lsof -i :8080

# Kill processes if needed
kill -9 <PID>
```

#### 2. Container Won't Start
```bash
# Check container logs
docker-compose logs sveltekit-dev
docker-compose logs sveltekit-prod
docker-compose logs wiremock

# Rebuild from scratch
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

#### 3. API Calls Failing
```bash
# Test direct Wiremock connection
curl http://localhost:8080/__admin/mappings

# Test SvelteKit proxy
curl http://localhost:3000/api/offices

# Check network connectivity between containers
docker exec sveltekit ping wiremock
```

#### 4. Login Not Working
```bash
# Test login API directly
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@example.com", "password": "password123"}'

# Check authentication flow
curl -H "Authorization: Bearer mock-jwt-token-for-admin" \
  http://localhost:3000/api/auth/me
```

### Reset Everything
```bash
# Complete reset
docker-compose down -v --rmi all
docker system prune -f
docker-compose build --no-cache
docker-compose up -d
```

## 📊 Monitoring

### View Resource Usage
```bash
# Real-time resource usage
docker stats

# Container details
docker-compose ps
```

### View Logs
```bash
# Follow all logs
docker-compose logs -f

# Follow specific service
docker-compose logs -f sveltekit
docker-compose logs -f wiremock
```

## 🔐 Test Credentials

### Login Credentials
- **Email**: `admin@example.com`
- **Password**: `password123`
- **Role**: Admin

### API Endpoints
- **Login**: `POST /api/auth/login`
- **User Info**: `GET /api/auth/me`
- **Offices**: `GET /api/offices`
- **Office Users**: `GET /api/offices/{id}/users`
- **Office Items**: `GET /api/offices/{id}/items`

## 🌐 Access URLs

- **Frontend Application (dev)**: http://localhost:3000/
- **Frontend Application (prod)**: http://localhost:3500/
- **Login Page (dev)**: http://localhost:3000/login
- **Login Page (prod)**: http://localhost:3500/login
- **Wiremock API**: http://localhost:8080/
- **Wiremock Admin**: http://localhost:8080/__admin/

## 📁 Project Structure

```
rebot-app/
├── docker-compose.yml          # Docker services configuration
├── my-office-app/             # SvelteKit frontend
│   ├── Dockerfile             # Frontend container build
│   ├── src/                   # Application source code
│   └── package.json           # Frontend dependencies
└── backend/                   # Backend configuration
    └── wiremock-mappings.json # API mock definitions
```

## 🛠️ Development Workflow

### 1. Start Development Environment
```bash
docker-compose up --watch
```

### 1b. Start Production Environment
```bash
docker-compose --profile prod up
```

### 2. Make Code Changes
Edit files in `my-office-app/src/`

### 3. Rebuild After Changes
```bash
# Rebuild and restart frontend
docker-compose build sveltekit
docker-compose up -d sveltekit
docker-compose up sveltekit --watch

# Or rebuild everything
docker-compose build sveltekit --no-cache
docker-compose up -d
```

### 4. Test Changes
```bash
# Test API endpoints
curl http://localhost:3000/api/offices

# Test web application
open http://localhost:3000
```

## 🧹 Cleanup

### Stop Services
```bash
docker-compose down
```

### Remove Everything
```bash
# Stop and remove containers, networks, volumes
docker-compose down -v

# Remove images
docker-compose down --rmi all

# Clean up unused Docker resources
docker system prune -f
```

## 📝 Notes

- The Docker Compose file uses profiles: `sveltekit-dev` is under the `dev` profile (default), and `sveltekit-prod` is under the `prod` profile (must be explicitly enabled). By default, only dev services run. Use `--profile prod` to run the production service.
- The application uses `adapter-node` for production builds in Docker
- API calls are proxied through SvelteKit server routes to Wiremock
- The environment variable `DOCKER_ENV=true` is set in the container
- Wiremock provides 21 API endpoints for testing
- All API responses are mocked data for development purposes

## 🆘 Getting Help

If you encounter issues:

1. Check the logs: `docker-compose logs`
2. Verify ports are available: `lsof -i :3000 && lsof -i :8080`
3. Rebuild from scratch: `docker-compose build --no-cache`
4. Check Docker Desktop is running
5. Ensure you have sufficient disk space and memory

For additional help, check the main README.md file or create an issue in the repository. 