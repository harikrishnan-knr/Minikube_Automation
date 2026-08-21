#!/bin/bash

echo "========================================"
echo "     Minikube Automation Script"
echo "========================================"
echo
echo "Enter Your Method:"
echo "[1] Install Minikube & kubectl"
echo "[2] Remove Minikube & kubectl"
echo "[3] Help Menu"
read -r method

echo
echo "Entered Method: $method"

case "$method" in

    1)
        echo "Installing Minikube & kubectl..."
        echo
        echo "Enter Your Linux Distribution:"
        echo "[1] Debian/Ubuntu"
        echo "[2] RedHat/RHEL/Fedora"
        read -r package

        case "$package" in

            1)
                echo "Entered Type: Debian/Ubuntu"
                echo "Installing..."

                echo
                echo "Enter your username:"
                read -r user

                if ! id "$user" &>/dev/null; then
                    echo "Error: User '$user' does not exist."
                    exit 1
                fi

                echo
                echo "Check your username: $user"
                echo "[1] Correct"
                echo "[2] Wrong"
                read -r check

                if [ "$check" -eq 1 ]; then

                    echo
                    echo "Updating system..."
                    sudo apt-get update

                    echo
                    echo "Installing required packages..."
                    sudo apt-get install -y \
                        apt-transport-https \
                        ca-certificates \
                        curl \
                        gpg

                    # Create keyring directory
                    sudo mkdir -p /etc/apt/keyrings

                    # Kubernetes repository key
                    echo
                    echo "Adding Kubernetes repository..."

                    curl -fsSL \
                        https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key \
                        | sudo gpg --dearmor \
                        -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

                    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' \
                        | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

                    sudo apt-get update

                    echo
                    echo "Installing kubectl..."
                    sudo apt-get install -y kubectl

                    echo
                    echo "kubectl version:"
                    kubectl version --client

                    # Minikube installation
                    echo
                    echo "Installing Minikube..."

                    if [ ! -f "package/minikube_latest_amd64.deb" ]; then
                        echo "Error: Minikube package not found:"
                        echo "package/minikube_latest_amd64.deb"
                        exit 1
                    fi

                    sudo apt-get install -y ./package/minikube_latest_amd64.deb

                    echo
                    echo "Minikube version:"
                    minikube version

                    # Automation script setup
                    if [ -f "kube" ]; then
                        echo
                        echo "Installing kube automation command..."

                        sudo cp kube /usr/local/bin/kube
                        sudo chmod +x /usr/local/bin/kube
                        sudo chown "$user":"$user" /usr/local/bin/kube

                        echo "kube command installed successfully."
                    else
                        echo
                        echo "Warning: 'kube' file not found."
                    fi

                    echo
                    echo "========================================"
                    echo "Installation Completed Successfully!"
                    echo "========================================"

                elif [ "$check" -eq 2 ]; then
                    echo "Re-run this script and enter the correct username."

                else
                    echo "Invalid option."
                fi
                ;;

            2)
                echo "Entered Type: RedHat/RHEL/Fedora"
                echo "Installing..."

                echo
                echo "Enter your username:"
                read -r user

                if ! id "$user" &>/dev/null; then
                    echo "Error: User '$user' does not exist."
                    exit 1
                fi

                echo
                echo "Check your username: $user"
                echo "[1] Correct"
                echo "[2] Wrong"
                read -r check

                if [ "$check" -eq 1 ]; then

                    echo
                    echo "Updating system..."
                    sudo dnf update -y

                    echo
                    echo "Installing required packages..."
                    sudo dnf install -y wget curl

                    # Minikube installation
                    echo
                    echo "Installing Minikube..."

                    if [ ! -f "package/minikube-latest.x86_64.rpm" ]; then
                        echo "Error: Minikube package not found:"
                        echo "package/minikube-latest.x86_64.rpm"
                        exit 1
                    fi

                    sudo dnf install -y ./package/minikube-latest.x86_64.rpm

                    # Kubernetes repository
                    echo
                    echo "Adding Kubernetes repository..."

                    cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo > /dev/null
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.34/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.34/rpm/repodata/repomd.xml.key
EOF

                    echo
                    echo "Installing kubectl..."
                    sudo dnf install -y kubectl

                    echo
                    echo "kubectl version:"
                    kubectl version --client

                    echo
                    echo "Minikube version:"
                    minikube version

                    # Automation script setup
                    if [ -f "kube" ]; then
                        echo
                        echo "Installing kube automation command..."

                        sudo cp kube /usr/local/bin/kube
                        sudo chmod +x /usr/local/bin/kube
                        sudo chown "$user":"$user" /usr/local/bin/kube

                        echo "kube command installed successfully."
                    else
                        echo
                        echo "Warning: 'kube' file not found."
                    fi

                    echo
                    echo "========================================"
                    echo "Installation Completed Successfully!"
                    echo "========================================"

                elif [ "$check" -eq 2 ]; then
                    echo "Re-run this script and enter the correct username."

                else
                    echo "Invalid option."
                fi
                ;;

            *)
                echo "Error: Enter a correct distribution option."
                exit 1
                ;;
        esac
        ;;

    2)
        echo "Removing Minikube & kubectl..."
        echo
        echo "Enter Your Linux Distribution:"
        echo "[1] Debian/Ubuntu"
        echo "[2] RedHat/RHEL/Fedora"
        read -r package

        case "$package" in

            1)
                echo "Entered Type: Debian/Ubuntu"
                echo "Removing..."

                sudo apt-get remove -y minikube kubectl

                sudo rm -f /usr/local/bin/minikube
                sudo rm -f /usr/local/bin/kubectl

                rm -rf "$HOME/.minikube"

                # Remove Kubernetes repository
                sudo rm -f /etc/apt/sources.list.d/kubernetes.list
                sudo rm -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg

                sudo apt-get update

                echo
                echo "Successfully Removed!"
                ;;

            2)
                echo "Entered Type: RedHat/RHEL/Fedora"
                echo "Removing..."

                sudo dnf remove -y minikube kubectl

                sudo rm -f /usr/local/bin/minikube
                sudo rm -f /usr/local/bin/kubectl

                rm -rf "$HOME/.minikube"

                # Remove Kubernetes repository
                sudo rm -f /etc/yum.repos.d/kubernetes.repo

                echo
                echo "Successfully Removed!"
                ;;

            *)
                echo "Error: Enter a correct distribution option."
                exit 1
                ;;
        esac
        ;;

    3)
        echo
        echo "========================================"
        echo "              Help Menu"
        echo "========================================"
        echo
        echo "1. Install Minikube and kubectl"
        echo "2. Remove Minikube and kubectl"
        echo "3. Display this help menu"
        echo
        echo "Before installation:"
        echo "- Make sure sudo is available."
        echo "- Make sure the Minikube package exists."
        echo "- Make sure the 'kube' file exists if you want"
        echo "  the automation command installed."
        ;;

    *)
        echo "Error: Enter a correct method."
        exit 1
        ;;

esac
