REM Login to Podman registry (if not already logged in)
echo Logging into Podman registry 10.50.0.7:5001...
podman login 10.50.0.7:5001
if %errorlevel% neq 0 (
    echo Login failed. Please check your credentials.
    pause
    exit /b 1
)

REM Pull images with Podman first (since podman compose uses docker-compose which doesn't have podman credentials)
echo Pulling images with Podman...
podman pull 10.50.0.7:5001/csam_ai_server/api:2.2.5
if %errorlevel% neq 0 (
    echo Failed to pull api image.
    pause
    exit /b 1
)

podman pull 10.50.0.7:5001/csam_ai_server/app:2.2.5
if %errorlevel% neq 0 (
    echo Failed to pull app image.
    pause
    exit /b 1
)

REM Create required directories if they don't exist
if not exist "data" (
    echo Creating data directory...
    mkdir data
)

if not exist "config" (
    echo Creating config directory...
    mkdir config
)

REM Build and run podman compose (images are now local, so no auth needed)
echo Starting containers with podman compose...
podman compose -f docker-compose.yml up --build -d

REM Keep the window open to view logs (optional)
pause

REM Stop and remove docker compose
podman compose -f docker-compose.yml down