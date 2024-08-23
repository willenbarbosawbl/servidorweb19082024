#!/bin/bash

# Função para instalar o ProFTPD
install_proftpd() {
    echo "Instalando ProFTPD..."
    sudo apt update
    sudo apt install -y proftpd

    echo "Configurando ProFTPD..."
    # Cria backup do arquivo de configuração original
    sudo cp /etc/proftpd/proftpd.conf /etc/proftpd/proftpd.conf.bak

    # Adiciona a configuração DefaultRoot para limitar o usuário à sua pasta
    sudo bash -c 'cat <<EOF >> /etc/proftpd/proftpd.conf
DefaultRoot ~
EOF'

    # Reinicia o serviço para aplicar as mudanças
    sudo systemctl restart proftpd

    echo "ProFTPD instalado e configurado com DefaultRoot."
}

# Função para desinstalar o ProFTPD
uninstall_proftpd() {
    echo "Deseja apagar a pasta do ProFTPD? (s/n): "
    read -r apagar_pasta

    echo "Desinstalando ProFTPD..."
    sudo systemctl stop proftpd
    sudo apt purge -y proftpd

    # Remove a pasta de configuração, se desejado
    if [[ $apagar_pasta =~ ^[Ss]$ ]]; then
        echo "Apagando pasta de configuração do ProFTPD..."
        sudo rm -rf /etc/proftpd
    else
        echo "Pasta de configuração do ProFTPD mantida."
    fi

    echo "ProFTPD desinstalado."
}

# Menu principal
echo "Escolha uma opção:"
echo "1. Instalar ProFTPD"
echo "2. Desinstalar ProFTPD"
echo "0. Sair"
read -r opcao

case $opcao in
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
        echo "Opção inválida."
        ;;
esac
