# Minikube Automation

A simple Bash-based automation toolkit for installing, configuring, and managing **Minikube** and **kubectl** on Linux — with support for both Debian/Ubuntu and RedHat/RHEL/Fedora distributions.

The repo bundles the required install packages, an interactive setup script, and a lightweight `kube` command for day-to-day cluster operations.

## Features

- 📦 **One-shot installer** — installs `kubectl` (from the official Kubernetes package repos) and `minikube` (from a bundled local package)
- 🖥️ **Multi-distro support** — Debian/Ubuntu (`.deb`) and RedHat/RHEL/Fedora (`.rpm`)
- 🧹 **Clean uninstall** — removes Minikube, kubectl, config repos, and keyrings
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
- [Docker](https://docs.docker.com/engine/install/) installed and running (used as the Minikube driver)
- An existing local user account (you'll be asked to confirm it during setup)

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
   [1] Install Minikube & kubectl
   [2] Remove Minikube & kubectl
   [3] Help Menu
   ```

   - Choosing **[1]** will ask for your Linux distribution (Debian/Ubuntu or RedHat/RHEL/Fedora) and your username, then install `kubectl`, `minikube`, and the `kube` helper command to `/usr/local/bin/kube`.
   - Choosing **[2]** will remove Minikube, kubectl, related repositories/keyrings, and the `~/.minikube` directory.
   - Choosing **[3]** displays a help menu with usage guidance.

## Usage

Once installed, use the `kube` command from anywhere to manage your cluster:

```bash
kube start   # Start Minikube (docker driver, 2 CPUs, 3072MB RAM, 30GB disk)
kube stop    # Delete/stop the Minikube cluster
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

- The `kube start` command launches Minikube with the following defaults: `--driver=docker --cpus=2 --memory=3072 --disk-size=30g`. Edit the `kube` script if you need different resource settings.
- `setup.sh` installs `kubectl` from the official Kubernetes v1.34 apt/yum repositories, and `minikube` from the packages bundled in the `package/` directory.
- Uninstalling does **not** remove Docker — only Minikube, kubectl, and their configuration.

## Contributing

Issues and pull requests are welcome. If you'd like to add support for another distribution or extend the `kube` helper, feel free to open a PR.

## License

No license specified yet. Consider adding one (e.g., MIT) if you plan to share or accept contributions.
