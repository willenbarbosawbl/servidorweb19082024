#!/bin/bash

# Função para remover um usuário e suas pastas
remover_usuario() {
    local usuario="$1"
    
    # Remove o usuário do grupo www-data
    deluser "$usuario" www-data
    
    # Pergunta se o usuário deseja apagar a pasta do usuário
    read -p "Deseja apagar a pasta do usuário /home/$usuario? (s/n): " resposta
    if [[ "$resposta" =~ ^[sS]$ ]]; then
        rm -rf /home/"$usuario"
        echo "Pasta do usuário /home/$usuario apagada."
    fi
    
    # Remove o usuário do sistema
    deluser --remove-home "$usuario"
    echo "Usuário $usuario removido."
}

# Função para remover arquivos de configuração do Apache
remover_apache_config() {
    local dominio="$1"
    
    # Remove o arquivo de configuração do Apache
    local conf_file="/etc/apache2/sites-available/$dominio.conf"
    if [[ -f "$conf_file" ]]; then
        rm "$conf_file"
        echo "Arquivo de configuração do Apache $dominio removido de /etc/apache2/sites-available."
        
        # Remove o link simbólico em sites-enabled, se existir
        local link_file="/etc/apache2/sites-enabled/$dominio.conf"
        if [[ -L "$link_file" ]]; then
            rm "$link_file"
            echo "Link simbólico removido de /etc/apache2/sites-enabled."
        fi
    else
        echo "Arquivo de configuração do Apache para $dominio não encontrado."
    fi
    
    # Reinicia o Apache para aplicar as mudanças
    systemctl restart apache2
}

# Verifica se o script está sendo executado como root
if [[ "$EUID" -ne 0 ]]; then
    echo "Este script deve ser executado como root." >&2
    exit 1
fi

# Solicita o nome do usuário e do domínio
read -p "Informe o nome do usuário a ser removido: " usuario
read -p "Informe o domínio para remover a configuração do Apache: " dominio

# Remove o usuário e seus arquivos
remover_usuario "$usuario"

# Remove a configuração do Apache
remover_apache_config "$dominio"

echo "Processo concluído."
