# aether-vault

aether-vault is a high-performance, self-hosted private cloud bridge. It transforms local Linux hardware into a globally accessible, encrypted storage vault using a secure WireGuard-based mesh network.

## Architecture & Stack
*   **Engine**: FileBrowser (High-concurrency Golang-based file manager)
*   **Network**: Tailscale (Zero-config WireGuard Mesh VPN for secure global access)
*   **Containerization**: Docker & Docker Compose (Isolated, reproducible environment)
*   **Legacy Orchestration**: Systemd (Native Linux background persistence)
*   **Security**: Decoupled Secrets Management via `.env` and Environment Templating.

##  Docker Deployment
The fastest way to deploy AetherVault is using Docker. This ensures all dependencies and binaries are handled automatically.

### 1. Provision the Environment
```bash
git clone https://github.com/YOUR_USER/aether-vault.git
cd aether-vault
cp .env.example .env
```
Edit `.env` to set your custom `VAULT_ADMIN_PASSWORD` and `VAULT_PORT`.

### 2. Launch the Cloud
```bash
docker compose up -d
```
**Access your cloud**: Navigate to `http://localhost:8080` (or your custom port) and log in with the credentials set in your `.env`.

## Alternative: Manual Linux Deployment
For users who prefer running the service natively without Docker:

```bash
# 1. Install binaries
bash scripts/install.sh

# 2. Setup DB and generate service from template
bash scripts/setup_db.sh

# 3. Enable Systemd service
sudo cp systemd/aether.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now aether
```

## Network & Security Debugging
To verify traffic is flowing through your encrypted Tailscale tunnel:

```bash
# Monitor incoming cloud traffic specifically on the Tailscale interface
sudo tcpdump -i tailscale0 port 8080
```

## Key Features
*   **Docker-Native**: Deploy in seconds on any system with Docker installed --- no local library conflicts.
*   **Environment Agnostic**: Uses `.env` and `sed`-based templating to adapt to any directory structure.
*   **Global Mesh Access**: Bypasses NAT and Firewalls --- access your files via Tailscale from anywhere.
*   **Health Monitoring**: Docker-integrated health checks ensure the service is always responsive.
*   **Auto-Persistence**: Service restarts automatically on boot or failure.

## Project Structure
```plaintext
aether-vault/
├── config/             # Configuration templates and settings
├── scripts/            # Automation and installation scripts
│   ├── backup.sh       # Automated backup utility
│   ├── install.sh      # Manual install script
│   └── setup_db.sh     # Configurator and service generator
├── systemd/            # Portable service definitions and templates
├── .env.example        # Secrets blueprint for environment variables
├── .gitignore          # Rules for excluding private data from Git
├── README.md           # Project documentation and setup guide
└── docker-compose.yml  # Main Docker orchestration file
```
