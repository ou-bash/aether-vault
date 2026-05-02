# aether-vault

**aether-vault** is a high-performance, self-hosted private cloud bridge. It transforms local Linux hardware into a globally accessible, encrypted storage vault using a secure WireGuard-based mesh network.

---

## Architecture & Stack
- **Engine:** [FileBrowser](https://filebrowser.org/) (High-concurrency Golang-based file manager)
- **Network:** [Tailscale](https://tailscale.com/) (Zero-config WireGuard Mesh VPN for secure global access)
- **Orchestration:** Systemd (Ensures 99.9% uptime with automated background persistence)
- **Security:** Decoupled Secrets Management via `.env` and Environment Templating.

---

## Prerequisites
- **Tailscale:** Installed and authenticated on both this host and your mobile device.
- **Systemd:** A Linux distribution using systemd (Ubuntu, Debian, Fedora, etc.).
- **Permissions:** Sudo access for service orchestration.


## Quick Start (Deployment)

### 1. Provision the Environment
Clone the repository and prepare the secrets file:
```bash
git clone https://github.com/YOUR_USER/aether-vault.git
cd aether-vault
cp .env.example .env
```
*Note: Edit `.env` to set your custom `VAULT_ADMIN_USER`, `VAULT_ADMIN_PASSWORD`, and `VAULT_PORT`.*

### 2. Execute Orchestration Scripts
```bash
# Install binaries and create directory silos
bash scripts/install.sh

# Initialize database and generate local systemd service from template
bash scripts/setup_db.sh
```

### 3. Activate the Service
```bash
sudo cp systemd/aether.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now aether
```

---

## Network & Security Debugging
To verify that traffic is correctly flowing through your encrypted Tailscale tunnel and not the open internet, you can inspect the packets directly on the virtual interface:

```bash
# Monitor incoming cloud traffic specifically on the Tailscale interface
sudo tcpdump -i tailscale0 port 8080
```

---

## Key Features
- **Environment Agnostic:** Uses `sed`-based templating to adapt to any user's local directory structure automatically during setup.
- **Global Mesh Access:** Bypasses NAT and Firewalls—access your files from your mobile device anywhere in the world.
- **Automatic Persistence:** Managed by `systemd` to ensure the service restarts automatically on system boot or unexpected failure.
- **Secure by Design:** Sensitive credentials and local paths are isolated from the codebase using `.env` files and `.gitignore` patterns.

---

## Project Structure
```text
aether-vault/
├── bin/              # Binary executables (Git ignored)
├── database/         # SQLite configuration data (Git ignored)
├── files/            # Your cloud storage directory (Git ignored)
├── scripts/
│   ├── install.sh    # Environment provisioner
│   └── setup_db.sh   # Configurator & service generator
├── systemd/
│   ├── aether.service.template  # Portable service definition
│   └── aether.service           # Generated local service (Git ignored)
└── README.md         # Documentation
```
