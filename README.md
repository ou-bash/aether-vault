# aether-vault

aether-vault is a high-performance, self-hosted private cloud bridge. It transforms local Linux hardware into a globally accessible, encrypted storage vault using a secure WireGuard-based mesh network.

## Architecture & Stack
*   **Engine**: FileBrowser (High-concurrency Golang-based file manager)
*   **Reverse Proxy**: Nginx Proxy Manager (Visual traffic orchestration & SSL)
*   **Network**: Tailscale (Zero-config WireGuard Mesh VPN for NAT traversal)
*   **Containerization**: Docker & Docker Compose (Isolated, reproducible environment)
*   **CI/CD**: GitHub Actions (Integrated ShellCheck linting & Docker verification)
*   **Automation**: Crontab-driven background persistence & daily snapshots.

## Docker Deployment
The fastest way to deploy aether-vault. This ensures all dependencies and binaries are handled automatically.

### 1. Provision the Environment
```bash
git clone https://github.com
cd aether-vault
cp .env.example .env
```
*Edit `.env` to set your custom `UID`, `GID`, and project paths.*

### 2. Launch the Cloud
```bash
docker compose up -d
```

### 3. Access & Admin
*   **AetherVault (Direct)**: `http://localhost:8080`
*   **Nginx Proxy Manager**: `http://localhost:81`
    *   *Default Login*: `admin@example.com` | `changeme`
*   **Global Mesh Access**: Connect via Tailscale and navigate to `http://[your-hostname]` from any authorized device.

## Native Linux Deployment
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
To verify traffic is flowing securely through your encrypted Tailscale tunnel, you can monitor the internal interface:

```bash
# Monitor incoming cloud traffic specifically on the Tailscale interface
sudo tcpdump -i tailscale0 port 8080
```

*This proves that requests are arriving via the private mesh network and not the public internet.*


##  Maintenance & Backups
aether-vault includes a pre-configured backup utility. To automate daily snapshots at 2:00 AM, add the following to your `crontab -e`:

```bash
0 2 * * * /home/[your-user]/aether-vault/scripts/backup.sh >> /home/[your-user]/AetherVault_Backups/backup.log 2>&1
```

## Project Structure
```plaintext
aether-vault/
├── .github/workflows/            # CI Pipeline (ShellCheck & Docker Verify)
├── config/                       # Configuration storage and settings
├── scripts/                      # Core automation
│   ├── backup.sh                 # Automated snapshot utility
│   ├── install.sh                # Manual binary installer
│   └── setup_db.sh               # Service & Env generator
├── systemd/                      # Native Linux service templates
├── .env.example                  # Secrets blueprint
├── .gitignore                    # Prevents private data leakage
├── docker-compose.yml            # Full stack orchestration (App + Proxy)
└── README.md                     # Documentation
```

## Security & Mesh Networking
aether-vault is designed to be invisible to the public internet. By utilizing **Tailscale**, it bypasses ISP firewalls and CGNAT without the need for vulnerable port forwarding. All traffic is end-to-end encrypted via the WireGuard protocol.
