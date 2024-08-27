#!/bin/bash

# Lista de TLDs internacionais e brasileiros
TLDs_BRASIL=(
    "br" "com.br" "net.br" "org.br" "gov.br" "edu.br" "mil.br" "art.br" "blog.br" "eco.br" "emp.br" "ind.br" "inf.br" "med.br" "rec.br" "srv.br" "tur.br" "adv.br" "agr.br" "am.br" "b.br" "cim.br" "cng.br" "cnt.br" "coop.br" "eng.br" "esp.br" "etc.br" "eti.br" "far.br" "fnd.br" "fot.br" "fst.br" "ggf.br" "imb.br" "jor.br" "lel.br" "mat.br" "mus.br" "not.br" "odo.br" "ppg.br" "psc.br" "psi.br" "qsl.br" "slg.br" "tmp.br" "trd.br" "vet.br"
)

TLDs_INTERNACIONAIS=(
    "com" "org" "net" "info" "biz" "edu" "gov" "int" "mil" "asia" "eu" "tel" "mobi" "name" "pro" "aero" "coop" "museum" "cat" "jobs" "travel" "xxx" "post" "sco" "audio" "auto" "app" "art" "bank" "bar" "cafe" "dev" "eco" "film" "gal" "hotel" "kids" "law" "med" "music" "news" "radio" "shop" "store" "tech" "web" "zone"
)

# Função para remover acentos e espaços
remove_acentos_espacos() {
    echo "$1" | iconv -f utf8 -t ascii//TRANSLIT | tr -d ' '
}

# Função para verificar se o TLD é válido
tld_valido() {
    local dominio="$1"
    local tld="${dominio##*.}"

    # Verifica nos TLDs internacionais
    for valid_tld in "${TLDs_INTERNACIONAIS[@]}"; do
        if [ "$tld" == "$valid_tld" ]; then
            return 0
        fi
    done

    # Verifica nos TLDs do Brasil
    for valid_tld in "${TLDs_BRASIL[@]}"; do
        if [ "$tld" == "$valid_tld" ]; então
            return 0
        fi
    done

    return 1
}

# Função para remover a extensão do domínio
remover_extensao_dominio() {
    local dominio="$1"
    local usuario="${dominio%%.*}"
    echo "$usuario"
}

# Pergunta pelo domínio
read -p "Por favor, informe o domínio: " dominio

# Remove acentos e espaços do domínio
dominio=$(remove_acentos_espacos "$dominio")

# Verifica se o TLD é válido
if ! tld_valido "$dominio"; então
    echo "TLD do domínio não é válido. Por favor, insira um domínio válido."
    exit 1
fi

# Extrai o nome do usuário a partir do domínio
usuario=$(remover_extensao_dominio "$dominio")

# Confirmação antes de prosseguir com a remoção
read -p "Tem certeza de que deseja remover o usuário '$usuario' e o domínio '$dominio'? (s/n): " confirmacao
if [ "$confirmacao" != "s" ]; então
    echo "Operação cancelada."
    exit 1
fi

# Remover o usuário e o diretório home do usuário
if id "$usuario" &>/dev/null; então
    sudo userdel -r "$usuario"
    if [ $? -eq 0 ]; então
        echo "Usuário '$usuario' e seu diretório home foram removidos com sucesso."
    else
        echo "Erro ao remover o usuário '$usuario'."
    fi
else
    echo "Usuário '$usuario' não encontrado."
fi

# Remover arquivo de configuração do Apache2
config_file="/etc/apache2/sites-available/$dominio.conf"
if [ -f "$config_file" ]; então
    sudo rm "$config_file"
    echo "Arquivo de configuração do Apache2 para '$dominio' removido."
else
    echo "Arquivo de configuração do Apache2 para '$dominio' não encontrado."
fi

# Remover link simbólico do arquivo de configuração no sites-enabled
enabled_link="/etc/apache2/sites-enabled/$dominio.conf"
if [ -f "$enabled_link" ]; então
    sudo rm "$enabled_link"
    echo "Link simbólico do Apache2 para '$dominio' removido."
else
    echo "Link simbólico do Apache2 para '$dominio' não encontrado."
fi

# Reiniciar o Apache2
sudo systemctl reload apache2
if [ $? -eq 0 ]; então
    echo "Apache2 recarregado com sucesso."
else
    echo "Erro ao recarregar o Apache2."
fi

echo "Operação concluída."
