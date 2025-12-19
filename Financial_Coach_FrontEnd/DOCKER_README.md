# Financial Coach Frontend - Docker Setup

This project uses Docker to ensure consistent development environments across all team members, eliminating dependency conflicts and "works on my machine" issues.

## Prerequisites
- Docker Desktop installed and running
- Git

## Quick Start

### First Time Setup
1. Clone the repository
2. Navigate to the project directory
3. Build and run the container:
   ```bash
   docker-compose up --build
   ```
   > **Note**: The first build will take 10-15 minutes as Docker downloads the Flutter image (~1.1GB). Subsequent builds will be much faster.

4. Access the app at `http://localhost:8080`

### Daily Development
```bash
docker-compose up
```

### Stop the Container
```bash
docker-compose down
```

## What's Included
- **Flutter SDK 3.24.0**: Pinned version ensures everyone uses the same SDK
- **Web Support**: Pre-configured for Flutter web development
- **Hot Reload**: Works inside the container

## Benefits
- ✅ No local Flutter installation required
- ✅ Guaranteed SDK version consistency across team
- ✅ No dependency conflicts
- ✅ Easy onboarding for new team members
- ✅ Works on Windows, Mac, and Linux

## Troubleshooting
- **Docker not running**: Start Docker Desktop before running commands
- **Port 8080 in use**: Change the port in `docker-compose.yml`
- **Slow build**: First build downloads ~1.1GB, be patient
