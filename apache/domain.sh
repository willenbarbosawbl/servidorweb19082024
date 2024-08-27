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
        if [ "$tld" == "$valid_tld" ]; then
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

# Função para criar um usuário e adicioná-lo ao grupo www-data
criar_usuario() {
    local nome_usuario=$1

    # Verifica se o nome do usuário foi fornecido
    if [ -z "$nome_usuario" ]; then
        echo "Por favor, forneça um nome de usuário."
        return 1
    fi

    # Verifica se o usuário já existe
    if id "$nome_usuario" &>/dev/null; then
        echo "O usuário '$nome_usuario' já existe."
        return 1
    fi

    # Cria o usuário
    sudo useradd -m "$nome_usuario"
    if [ $? -ne 0 ]; then
        echo "Erro ao criar o usuário '$nome_usuario'."
        return 1
    fi

    # Adiciona o usuário ao grupo www-data
    sudo usermod -aG www-data "$nome_usuario"
    if [ $? -ne 0 ]; then
        echo "Erro ao adicionar o usuário '$nome_usuario' ao grupo www-data."
        return 1
    fi

    echo "Usuário '$nome_usuario' criado e adicionado ao grupo www-data com sucesso."
    return 0
}

criar_pastas_usuario() {
    local usuario="$1"

    if [ -z "$usuario" ]; then
        echo "Uso: $0 <nome_do_usuario>"
        return 1
    fi

    # Verifica se o usuário existe
    if id "$usuario" &>/dev/null; then
        # Diretório home do usuário
        local home_dir=$(eval echo ~$usuario)

        # Verifica se o diretório home existe
        if [ -d "$home_dir" ]; then
            echo "Criando pastas em $home_dir..."

            # Cria as pastas
            mkdir -p "$home_dir/public_html"
            mkdir -p "$home_dir/logs"
            mkdir -p "$home_dir/pages_error"
            mkdir -p "$home_dir/ssl"

            echo "Pastas criadas com sucesso."
        else
            echo "Diretório home do usuário não encontrado."
            return 1
        fi
    else
        echo "Usuário '$usuario' não encontrado."
        return 1
    fi
}

# Função para definir permissões para pastas e arquivos
definir_permissoes() {
    local home_dir="$1"  # Diretório base onde as permissões serão aplicadas

    if [ -z "$home_dir" ]; then
        echo "Erro: O diretório base não foi fornecido."
        return 1
    fi

    if [ ! -d "$home_dir" ]; then
        echo "Erro: O diretório '$home_dir' não existe."
        return 1
    fi

    echo "Definindo permissões para diretórios em '$home_dir'..."
    find "$home_dir" -type d -exec chmod 0755 {} \;

    echo "Definindo permissões para arquivos em '$home_dir'..."
    find "$home_dir" -type f -exec chmod 0644 {} \;

    echo "Permissões definidas com sucesso."
}

# Função que cria cabeçalho html
create_html_header(){
    echo '<!DOCTYPE html>' >> "$1"
    echo '<html lang="pt-br">' >> "$1"
    echo '<head>' >> "$1"
    echo '    <meta charset="UTF-8">' >> "$1"
    echo '    <meta name="viewport" content="width=device-width, initial-scale=1.0">' >> "$1"
    echo "    <title>$2</title>" >> "$1"
    echo '    <link href="https://stackpath.bootstrapcdn.com/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">' >> "$1"
    echo '    <style>' >> "$1"
    echo '        body, html {' >> "$1"
    echo '            height: 100%;' >> "$1"
    echo '            margin: 0;' >> "$1"
    echo '            font-family: Arial, Helvetica, sans-serif;' >> "$1"
    echo '        }' >> "$1"
    echo '        .bg {' >> "$1"
    echo '            background-image: url('"'"'https://img.freepik.com/free-photo/zen-stones-sand-background-health-wellness-concept_53876-124303.jpg?t=st=1716698385~exp=1716701985~hmac=ead285b8abd7ce059b0965eb63452f48d2308bebf957990f545328d80b496541&w=2000'"'"');' >> "$1"
    echo '            height: 100%;' >> "$1"
    echo '            background-position: center;' >> "$1"
    echo '            background-repeat: no-repeat;' >> "$1"
    echo '            background-size: cover;' >> "$1"
    echo '        }' >> "$1"
    echo '        .centered-message {' >> "$1"
    echo '            position: absolute;' >> "$1"
    echo '            top: 50%;' >> "$1"
    echo '            left: 50%;' >> "$1"
    echo '            transform: translate(-50%, -50%);' >> "$1"
    echo '            color: white;' >> "$1"
    echo '            text-align: center;' >> "$1"
    echo '            padding: 20px;' >> "$1"
    echo '            background: rgba(0, 0, 0, 0.6);' >> "$1"
    echo '            border-radius: 10px;' >> "$1"
    echo '        }' >> "$1"
    echo '    </style>' >> "$1"
    echo '</head>' >> "$1"
    echo '<body>' >> "$1"
}

# Função que cria rodapé html
create_html_footer(){
    echo '<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>' >> "$1"
    echo '</body>' >> "$1"
    echo '</html>' >> "$1"
}

# Função que cria página de erro 404
create_page_404(){
    echo "Criando página 404 padrão..."
    USER_HOME=$1
    PAGE_ERROR_DIR="$USER_HOME/pages_error"
    PATH_ERROR="$PAGE_ERROR_DIR/404.html"
    TITLE="404 Página não encontrada."

    # Criar cabeçalho HTML
    create_html_header "$PATH_ERROR" "$TITLE"
    # Conteúdo da página
    echo '    <div class="bg">' >> "$PATH_ERROR"
    echo '        <div class="centered-message">' >> "$PATH_ERROR"
    echo "            <h1>$TITLE</h1>" >> "$PATH_ERROR"
    echo '            <p>A página que você está procurando não foi encontrada.</p>' >> "$PATH_ERROR"
    echo '            <a href="/" class="btn btn-primary">Voltar para a página inicial</a>' >> "$PATH_ERROR"
    echo '        </div>' >> "$PATH_ERROR"
    echo '    </div>' >> "$PATH_ERROR"
    # Criar rodapé HTML
    create_html_footer "$PATH_ERROR"
    echo "Página 404 criada em $PATH_ERROR"
}

# Função que cria página de erro 405
create_page_405(){
    echo "Criando página 405 padrão..."
    USER_HOME=$1
    PAGE_ERROR_DIR="$USER_HOME/pages_error"
    PATH_ERROR="$PAGE_ERROR_DIR/405.html"
    TITLE="405 Página não encontrada."

    # Criar cabeçalho HTML
    create_html_header "$PATH_ERROR" "$TITLE"
    # Conteúdo da página
    echo '    <div class="bg">' >> "$PATH_ERROR"
    echo '        <div class="centered-message">' >> "$PATH_ERROR"
    echo "            <h1>$TITLE</h1>" >> "$PATH_ERROR"
    echo '            <p>A página que você está procurando não foi encontrada.</p>' >> "$PATH_ERROR"
    echo '            <a href="/" class="btn btn-primary">Voltar para a página inicial</a>' >> "$PATH_ERROR"
    echo '        </div>' >> "$PATH_ERROR"
    echo '    </div>' >> "$PATH_ERROR"
    # Criar rodapé HTML
    create_html_footer "$PATH_ERROR"
    echo "Página 405 criada em $PATH_ERROR"
}

# Função que cria página de erro 500
create_page_500(){
    echo "Criando página 500 padrão..."
    USER_HOME=$1
    PAGE_ERROR_DIR="$USER_HOME/pages_error"
    PATH_ERROR="$PAGE_ERROR_DIR/500.html"
    TITLE="500 Erro interno o servidor"

    # Criar cabeçalho HTML
    create_html_header "$PATH_ERROR" "$TITLE"
    # Conteúdo da página
    echo '    <div class="bg">' >> "$PATH_ERROR"
    echo '        <div class="centered-message">' >> "$PATH_ERROR"
    echo "            <h1>$TITLE</h1>" >> "$PATH_ERROR"
    echo '            <p>A página que você está procurando não foi encontrada.</p>' >> "$PATH_ERROR"
    echo '            <a href="/" class="btn btn-primary">Voltar para a página inicial</a>' >> "$PATH_ERROR"
    echo '        </div>' >> "$PATH_ERROR"
    echo '    </div>' >> "$PATH_ERROR"
    # Criar rodapé HTML
    create_html_footer "$PATH_ERROR"
    echo "Página 500 criada em $PATH_ERROR"
}

# Função que cria página index
create_page_index(){
    echo "Criando página index"
    USER_HOME=$1
    PATH_DIR="$USER_HOME/public_html"
    PATH_FILE="$PATH_DIR/index.html"
    TITLE="Página principal de $2"

    # Criar cabeçalho HTML
    create_html_header "$PATH_FILE" "$TITLE"
    # Conteúdo da página
    echo '    <div class="bg">' >> "$PATH_FILE"
    echo '        <div class="centered-message">' >> "$PATH_FILE"
    echo "            <h1>$TITLE</h1>" >> "$PATH_FILE"
    echo '            <p>A página que você está acessando ainda está em construção.</p>' >> "$PATH_FILE"
    echo '            <a href="/" class="btn btn-primary">Voltar para a página inicial</a>' >> "$PATH_FILE"
    echo '        </div>' >> "$PATH_FILE"
    echo '    </div>' >> "$PATH_FILE"
    # Criar rodapé HTML
    create_html_footer "$PATH_FILE"
    echo "Página index criada em $PATH_FILE"
}

# Função que cria página index
create_page_info_php(){
    echo "Criando página info.php"
    USER_HOME=$1
    PATH_DIR="$USER_HOME/public_html"
    PATH_FILE="$PATH_DIR/info.php"
    
    echo "<?php phpinfo();?>" >> "$PATH_FILE" 
    echo "Página de informações do php criada em $PATH_FILE"
}

# Cria certificado SSL 
criar_certificado_ssl(){
    local dominio=$1
    local usuario=$2
    read -p "Informe a Organização (O): " organizacao
    read -p "Informe a Unidade Organizacional (OU): " unidade_organizacional

    # Define o caminho da pasta SSL dentro da home do usuário
    DIR_SSL="/home/$usuario/ssl"

    # Gerar o certificado e a chave privada
    openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
    -subj "/C=BR/ST=Sao Paulo/L=Sao Paulo/O=$organizacao/OU=$unidade_organizacional/CN=$dominio" \
    -keyout "$DIR_SSL/$dominio.key" -out "$DIR_SSL/$dominio.crt"

    # Informe ao usuário onde os arquivos foram salvos
    echo "Certificado e chave privada em: "
    echo "$DIR_SSL/$dominio.crt"
    echo "$DIR_SSL/$dominio.key"
}

# Cria configuração do apache2
configure_apache_ssl_domain() {
    local domain="$1"
    local user_home="$2"
    local apache_conf_dir="/etc/apache2/sites-available"
    local ssl_dir="$user_home/ssl"
    local public_html_dir="$user_home/public_html"
    local error_pages_dir="$user_home/pages_error"
    local logs_dir="$user_home/logs"

    # Verificar se o domínio e o diretório do usuário foram fornecidos
    if [[ -z "$domain" || -z "$user_home" ]]; then
        echo "Uso: configure_apache_ssl_domain <dominio> <diretorio_home_do_usuario>"
        return 1
    fi

    # Verificar se os arquivos de certificado e chave existem
    local crt_file="$ssl_dir/$domain.crt"
    local key_file="$ssl_dir/$domain.key"
    if [[ ! -f "$crt_file" || ! -f "$key_file" ]]; then
        echo "Certificado ou chave não encontrados em $ssl_dir"
        return 1
    fi

    # Criar o arquivo de configuração do Apache2
    local conf_file="$apache_conf_dir/$domain.conf"

    echo "<VirtualHost *:80>" >> "$conf_file"
    echo "    ServerName $domain" >> "$conf_file"
    echo "    ServerAlias www.$domain" >> "$conf_file"
    echo "    Redirect permanent / https://$domain/" >> "$conf_file"
    echo "</VirtualHost>" >> "$conf_file"
    echo "" >> "$conf_file"
    echo "<VirtualHost *:443>" >> "$conf_file"
    echo "    ServerName $domain" >> "$conf_file"
    echo "    ServerAlias www.$domain" >> "$conf_file"
    echo "" >> "$conf_file"
    echo "    DocumentRoot $public_html_dir" >> "$conf_file"
    echo "" >> "$conf_file"
    echo "    SSLEngine on" >> "$conf_file"
    echo "    SSLCertificateFile $crt_file" >> "$conf_file"
    echo "    SSLCertificateKeyFile $key_file" >> "$conf_file"
    echo "" >> "$conf_file"
    echo "    ErrorLog $logs_dir/error.log" >> "$conf_file"
    echo "    CustomLog $logs_dir/access.log combined" >> "$conf_file"
    echo "" >> "$conf_file"
    echo "    <Directory $public_html_dir>" >> "$conf_file"
    echo "        Options Indexes FollowSymLinks" >> "$conf_file"
    echo "        AllowOverride All" >> "$conf_file"
    echo "        Require all granted" >> "$conf_file"
    echo "    </Directory>" >> "$conf_file"
    echo "" >> "$conf_file"
    echo "    ErrorDocument 403 $error_pages_dir/403.html" >> "$conf_file"
    echo "    ErrorDocument 404 $error_pages_dir/404.html" >> "$conf_file"
    echo "    ErrorDocument 500 $error_pages_dir/500.html" >> "$conf_file"
    echo "</VirtualHost>" >> "$conf_file"

    # Ativar a configuração e reiniciar o Apache2
    a2ensite "$domain.conf"
    systemctl reload apache2

    echo "Configuração para $domain criada e ativada com sucesso."
}

# Função para alterar a senha do usuário
alterar_senha_usuario() {
    # Solicita o nome do usuário
    local USERNAME=$1

    # Verifica se o usuário existe no sistema
    if id "$USERNAME" &>/dev/null; then
        # Solicita a nova senha
        read -s -p "Digite a nova senha para o usuário $USERNAME: " PASSWORD
        echo
        read -s -p "Confirme a nova senha: " PASSWORD_CONFIRM
        echo

        # Verifica se as senhas coincidem
        if [ "$PASSWORD" == "$PASSWORD_CONFIRM" ]; then
            # Altera a senha do usuário
            echo "$USERNAME:$PASSWORD" | sudo chpasswd
            echo "Senha alterada com sucesso para o usuário $USERNAME."
        else
            echo "Erro: As senhas não coincidem."
            exit 1
        fi
    else
        echo "Erro: O usuário $USERNAME não existe."
        exit 1
    fi
}

# Loop para garantir que o domínio seja válido
while true; do
    read -p "Digite o nome do domínio com extensão (ex: meudominio.com.br): " dominio

    # Remove acentos e espaços    
    dominio=$(remove_acentos_espacos "$dominio")

    # Valida se o domínio está em formato correto
    if [[ "$dominio" =~ ^[a-zA-Z0-9-]+\.[a-zA-Z0-9.-]+$ ]]; then
        # Verifica se o TLD é válido
        if tld_valido "$dominio"; then
            dominio_completo=$dominio
            echo "Domínio válido: $dominio"
            # Remove a extensão do domínio e armazena o resultado na variável de usuário
            usuario=$(remover_extensao_dominio "$dominio")
            echo "Nome do usuário: $usuario"
            # Informa o domínio completo
            echo "O domínio completo é: $dominio_completo"

            # Cria novo usuário
            criar_usuario "$usuario"
            # Cria pasta do usuário
            criar_pastas_usuario "$usuario"
            # Cria a senha do usuário
            alterar_senha_usuario "$usuario"
            # Define permissões da pastas do usuário
            definir_permissoes "/home/$usuario"
            # Cria página de error 404
            create_page_404 "/home/$usuario"
            # Cria página de error 405
            create_page_405 "/home/$usuario"
            # Cria página de error 500
            create_page_500 "/home/$usuario"
            # Cria página de Index
            create_page_index "/home/$usuario" "$dominio_completo"
            # Cria página de info do php
            create_page_info_php "/home/$usuario"
            # Define permissões da pastas do usuário
            definir_permissoes "/home/$usuario"
            # Cria certificado autoassinado do domínio
            criar_certificado_ssl "$dominio_completo" "$usuario"
            # Cria configuração do domínio no apache2
            configure_apache_ssl_domain "$dominio_completo" "/home/$usuario"
            break
        else
            echo "TLD inválido. Tente novamente."
        fi
    else
        echo "Formato de domínio inválido. Não use acentos, espaços, ou insira um TLD válido. Tente novamente."
    fi
done