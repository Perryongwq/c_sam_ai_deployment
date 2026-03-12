REM Change to the directory containing docker-compose.yml
cd /d "C:\Users\C-SAMAI\Desktop\csam_ai_server-2.2.5"

REM Build and run podman compose
podman compose -f docker-compose.yml up --build -d

REM Keep the window open to view logs (optional)
pause

REM Stop and remove podman compose
podman compose -f docker-compose.yml down