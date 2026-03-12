# C-SAM AI Server

**Version:** v2.2.5

C-SAM AI Server is a containerized application for automated visual inspection of MLCC (Multi-Layer Ceramic Capacitor) components using C-SAM (C-mode Scanning Acoustic Microscopy) images. It uses deep learning models (TensorFlow/Keras `.h5`) to classify images as **G** (Good) or **NG** (No Good).

## Architecture

The application runs two containers via Podman Compose:

| Service      | Description                        | Port   |
|--------------|------------------------------------|--------|
| **backend**  | FastAPI REST API (v2)              | `8000` |
| **frontend** | Web UI served via NGINX            | `8080` |

Both services are connected through a `load_balancer` bridge network. The frontend depends on the backend and proxies API requests to it.

## Project Structure

```
csam_ai_server-2.2.5/
├── .env                    # Environment configuration
├── docker-compose.yml      # Podman Compose definition
├── run_compose.bat         # Full deployment script (login, pull, run)
├── start_podman.bat        # Quick start script
├── test.py                 # Standalone model prediction test
├── config/
│   ├── csam_ai_server.db   # SQLite database
│   └── model/              # AI model files
│       ├── *.h5            # Keras model weights
│       └── *.txt           # Class label mappings (0=G, 1=NG)
└── data/
    └── images/             # C-SAM image storage
```

## Prerequisites

- **Podman** (with `podman compose` support)
- Access to the container registry at `10.50.0.7:5001`

## Quick Start

### 1. Configure Environment

Copy or edit the `.env` file and set the values for your machine:

```env
PC_NAME=<your-pc-name>
AI_TRAIN_URL=http://<training-server>:8000
PRASS_URL=http://<prass-server>:8081/mlccprass/service/traffic/json?trafficId=543972&CDC0001=241&NOC0027=
```

Key environment variables:

| Variable          | Description                              |
|-------------------|------------------------------------------|
| `PC_NAME`         | Machine hostname                         |
| `API_PORT`        | Backend API port (default: `8000`)       |
| `NGINX_PORT`      | Frontend web UI port (default: `8080`)   |
| `BACKEND_NAME`    | Backend service name for Podman network  |
| `DB_NAME`         | SQLite database name                     |
| `AI_TRAIN_URL`    | URL of the AI training server            |
| `PRASS_URL`       | PRASS integration endpoint               |
| `LOT_COLUMN`      | Lot number column mapping                |
| `ITEM_COLUMN`     | Item column mapping                      |

### 2. Deploy

Run the full deployment script (handles registry login, image pull, and container startup):

```bat
run_compose.bat
```

Or, if images are already pulled locally:

```bat
start_podman.bat
```

### 3. Access

- **Web UI:** `http://<PC_NAME>:8080`
- **API:** `http://<PC_NAME>:8000`
- **API Docs:** `http://<PC_NAME>:8000/docs`

## Model Files

Models are stored in `config/model/` and consist of:

- **`.h5`** — Keras model weights
- **`.txt`** — Class label mapping (e.g., `0 G`, `1 NG`)

Models are named by item code.

## Container Management

```bash
# Start containers
podman compose -f docker-compose.yml up -d

# View logs
podman compose -f docker-compose.yml logs -f

# Stop containers
podman compose -f docker-compose.yml down
```
