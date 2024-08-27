#!/bin/bash

function install_proftpd() {
    echo "Instalando o ProFTPD..."
    sudo apt-get update
    sudo apt-get install -y proftpd

    echo "Configurando o ProFTPD para acesso restrito à pasta home do usuário..."

    # Backup da configuração original
    sudo cp /etc/proftpd/proftpd.conf /etc/proftpd/proftpd.conf.bak

    # Configurando o ProFTPD
    sudo sed -i 's/# DefaultRoot/DefaultRoot ~/' /etc/proftpd/proftpd.conf

    echo "Configurando ProFTPD para não permitir login de usuários anônimos..."
    sudo sed -i 's/#RequireValidShell/RequireValidShell off/' /etc/proftpd/proftpd.conf

    # Reiniciando o ProFTPD para aplicar as mudanças
    sudo systemctl restart proftpd

    echo "Instalação e configuração do ProFTPD concluídas!"
}

function uninstall_proftpd() {
    echo "Desinstalando o ProFTPD..."

    sudo systemctl stop proftpd
    sudo apt-get remove --purge -y proftpd

    echo "ProFTPD foi desinstalado."

    read -p "Deseja apagar a pasta de configuração do ProFTPD? (s/n): " remove_folder
    if [[ "$remove_folder" == "s" || "$remove_folder" == "S" ]]; then
        sudo rm -rf /etc/proftpd
        echo "Pasta de configuração do ProFTPD removida."
    else
        echo "Pasta de configuração do ProFTPD preservada."
    fi
}

function main_menu() {
    while true; do
        echo "Escolha uma opção:"
        echo "1. Instalar e configurar o ProFTPD"
        echo "2. Desinstalar o ProFTPD"
        echo "0. Sair"
        read -p "Opção: " option

        case $option in
            1)
                install_proftpd
                ;;
            2)
                uninstall_proftpd
                ;;
            0)
                echo "Saindo..."
                exit 0
                ;;
            *)
                echo "Opção inválida. Tente novamente."
                ;;
        esac
    done
}

main_menu
