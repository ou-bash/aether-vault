# AetherVault
**AetherVault** is a secure, self-hosted private cloud bridge that transforms local storage into a globally accessible personal cloud.

## Architecture
- **Engine:** FileBrowser (Golang)
- **Network:** Tailscale (WireGuard Mesh VPN)
- **Orchestration:** Systemd
- **OS:** Ubuntu / Linux

## Quick Start
1. **Clone the repo:** `git clone https://github.com/YOUR_USER/AetherVault.git`
2. **Install:** `bash scripts/install.sh`
3. **Configure:** `bash scripts/setup_db.sh`
4. **Deploy Service:** 
   ```bash
   sudo cp systemd/aether.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable aether
   sudo systemctl start aether
