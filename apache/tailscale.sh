#!/bin/bash

# Função para instalar o Tailscale
install_tailscale() {
    echo "Instalando Tailscale..."
    curl -fsSL https://tailscale.com/install.sh | sh

    # Ativar o Tailscale
    echo "Ativando Tailscale..."
    sudo tailscale up
}

# Função para desinstalar o Tailscale
uninstall_tailscale() {
    echo "Desinstalando Tailscale..."
    sudo tailscale down
    sudo apt-get remove --purge tailscale -y

    # Perguntar se deseja remover a pasta do Tailscale
    read -p "Deseja remover a pasta do Tailscale? (s/n): " remove_folder
    if [[ "$remove_folder" =~ ^[Ss]$ ]]; then
        echo "Removendo pasta do Tailscale..."
        sudo rm -rf /var/lib/tailscale
    else
        echo "A pasta do Tailscale não foi removida."
    fi
}

# Menu principal
echo "Escolha uma opção:"
echo "1. Instalar Tailscale"
echo "2. Desinstalar Tailscale"
echo "0. Sair"

read -p "Opção: " option

case $option in
    1)
        install_tailscale
        ;;
    2)
        uninstall_tailscale
        ;;
    0)
        echo "Saindo..."
        ;;
    *)
        echo "Opção inválida!"
        ;;
esac