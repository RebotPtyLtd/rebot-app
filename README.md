# rebot-app

Welcome to a simple code test

# 🛠️ Rebot App: Getting Started with Docker Compose

This guide walks you through setting up and running the **Rebot App** with Docker Compose. It includes instructions for macOS, Linux, and Windows.

---

## ✅ Prerequisites

Make sure the following are installed on your system:

### macOS
- [Homebrew](https://brew.sh/)
- Docker Desktop: `brew install --cask docker`
- Node.js (if running frontend locally): `brew install node`

### Linux (Debian/Ubuntu)
- Docker: [Install instructions](https://docs.docker.com/engine/install/ubuntu/)
- Docker Compose: Comes with recent Docker versions or [install separately](https://docs.docker.com/compose/install/)
- Node.js: `sudo apt install nodejs npm`

### Windows
- [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop)
- WSL2 enabled and configured
- Node.js: [Download installer](https://nodejs.org/)

---

## 🚀 Run the App with Docker Compose

### 1. Clone the Repository
```bash
git clone https://github.com/your-org/rebot-app.git
cd rebot-app
```

### 2. Make Sure File Structure Looks Like This
```
rebot-app/
├── backend/
│   ├── wiremock-mappings.json
│   └── ...
├── my-office-app/
│   ├── Dockerfile
│   └── ...
├── docker-compose.yml
```

### 3. Start the App
```bash
docker-compose --profile dev up --build --watch
```

This will:
- Launch **WireMock** on port `8080`
- Start the **SvelteKit frontend (development)** on port `3000`

> You can now open [http://localhost:3000](http://localhost:3000) in your browser to use the app.


---

## 📦 Services

| Service     | URL                         | Description            |
|-------------|-----------------------------|------------------------|
| Frontend    | http://localhost:3000       | SvelteKit UI          |
| Backend API | http://localhost:8080       | WireMock endpoints     |
| WireMock UI | http://localhost:8080/__admin/ | WireMock dashboard |

---

## Test Credentials:

    Email: admin@example.com

    Password: password123

## 🧹 Stopping and Cleaning Up

To stop the containers:
```bash
docker-compose down
```

To remove containers, images, volumes (clean slate):
```bash
docker-compose down --volumes --remove-orphans
```

---

## 🧪 Tips for Developers
- Edit files under `my-office-app/` to develop the UI.
- The dev frontend watches for file changes and hot reloads in the container.
- Backend data is mock-only and lives in `backend/wiremock-mappings.json`.
- Modify and regenerate mock data using `backend/data-generator.js`.

---

## 🆘 Troubleshooting

### Port Conflicts?
Ensure ports `3000` and `8080` are not already in use:
```bash
lsof -i :3000
lsof -i :8080
```

### Docker Permission Issues (Linux)
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Hot Reload not working on Windows with WSL2?
Ensure you cloned the repo to /home/$USER as WSL2 has issues with the notification system when files are located outside
the WSL2 instance (eg in /mnt/c/*)
Also make sure you're running docker-compose up --profile dev -w - the -w flag tells Docker to run the watch process.
---

Happy hacking! 🚀
