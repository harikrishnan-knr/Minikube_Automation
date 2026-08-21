# Minikube Automation

A simple Bash-based automation toolkit for installing, configuring, and managing **Docker**, **kubectl**, and **Minikube** on Linux — with support for both Debian/Ubuntu and RedHat/RHEL/Fedora distributions.

The repo bundles the required Minikube install packages, an interactive setup script, and a lightweight `kube` command for day-to-day cluster operations.

## Features

- 📦 **One-shot installer** — installs `docker`, `kubectl` (from the official Kubernetes package repos), and `minikube` (from a bundled local package)
- 🖥️ **Multi-distro support** — Debian/Ubuntu (`.deb` via `apt-get`) and RedHat/RHEL/Fedora (`.rpm` via `dnf`)
- 🐳 **Docker setup included** — installs Docker, enables the service, and adds your user to the `docker` group
- 🧹 **Clean uninstall** — removes Minikube, kubectl, Docker, their data/config directories, and related repos/keyrings
- ⚡ **`kube` helper command** — start/stop/status your Minikube cluster with one word
- 📖 **Built-in help menu** for both scripts

## Repository Structure

```
Minikube_automation/
├── setup.sh    # Interactive installer/uninstaller (main entry point)
├── kube        # Helper script to start/stop the Minikube cluster
├── package/
│   ├── minikube_latest_amd64.deb   # Minikube package for Debian/Ubuntu
│   └── minikube-latest.x86_64.rpm  # Minikube package for RedHat/RHEL/Fedora
└── README.md
```

## Prerequisites

- A Linux machine (Debian/Ubuntu or RedHat/RHEL/Fedora based)
- `sudo` privileges
- An existing local user account (you'll be asked to confirm it during setup — Docker, kubectl config, and the `kube` command are set up for this user)

> Docker itself does **not** need to be pre-installed — `setup.sh` installs and enables it for you.

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/harikrishnan-knr/Minikube_automation.git
   cd Minikube_automation
   ```

2. Make the scripts executable:

   ```bash
   chmod +x setup.sh
   ```

3. Run the setup script:

   ```bash
   ./setup.sh
   ```

4. Follow the prompts:

   ```
   Enter Your Method:
   [1] Install Minikube, kubectl & Docker
   [2] Remove Minikube, kubectl & Docker
   [3] Help Menu
   ```

   - **[1] Install** — asks for your Linux distribution (Debian/Ubuntu or RedHat/RHEL/Fedora) and your username, then:
     - Installs and enables **Docker**, and adds your user to the `docker` group
     - Adds the official **Kubernetes v1.34** package repo and installs **kubectl**
     - Installs **Minikube** from the bundled `package/` archive and sets its driver to `docker`
     - Copies the `kube` helper script to `/usr/local/bin/kube` and makes it executable
   - **[2] Remove** — deletes any running Minikube cluster, then removes the `minikube`, `kubectl`, and `docker` packages, their binaries, data directories (`~/.minikube`, `/var/lib/docker`, `/var/lib/containerd`), and the Kubernetes package repo/keyring.
   - **[3] Help Menu** — displays usage guidance and pre-install checklist.

   > ⚠️ **Note on username entry:** the script validates that the entered user exists, then asks you to confirm it's correct. If you answer "Wrong", you'll need to re-run the script — it won't re-prompt automatically.

## Usage

Once installed, use the `kube` command from anywhere to manage your cluster:

```bash
kube start   # Start Minikube (docker driver, 2 CPUs, 3072MB RAM, 30GB disk)
kube stop    # Delete the Minikube cluster
kube help    # Show the help menu
```

### Example

```bash
$ kube start
Minikube Script...
😄  minikube v1.34.0 on ...
✨  Using the docker driver based on user configuration
...
Minikube Server Started...
```

## Notes

- After installation, **log out and log back in** so your user's new `docker` group membership takes effect before running `minikube`/`kube` commands.
- `kube start` launches Minikube with fixed defaults: `--driver=docker --cpus=2 --memory=3072 --disk-size=30g`. Edit the `kube` script if you need different resource settings.
- `setup.sh` installs `kubectl` from the official Kubernetes v1.34 apt/dnf repositories, and `minikube` from the packages bundled in the `package/` directory — no internet download of Minikube itself is required.
- The **Remove** option deletes Docker's data directories (`/var/lib/docker`, `/var/lib/containerd`) as well as the packages themselves — back up any images/volumes you need before uninstalling.

## Contributing

Issues and pull requests are welcome. If you'd like to add support for another distribution, add non-interactive/flag-based usage, or extend the `kube` helper, feel free to open a PR.

## License

No license specified yet. Consider adding one (e.g., MIT) if you plan to share or accept contributions.
