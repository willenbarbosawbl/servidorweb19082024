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
    PAGE_ERROR_DIR="$USER_HOME/page_error"
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
    PAGE_ERROR_DIR="$USER_HOME/page_error"
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
    PAGE_ERROR_DIR="$USER_HOME/page_error"
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

# Função para ajustar permissões de pastas e arquivos
ajustar_permissoes() {
    local usuario="$1"
    local home_dir="/home/$usuario"

    # Verifica se o diretório home do usuário existe
    if [ ! -d "$home_dir" ]; then
        echo "O diretório home para o usuário $usuario não existe."
        return 1
    fi

    # Ajusta permissões de pastas para 0755
    find "$home_dir" -type d -exec chmod 0755 {} \;
    echo "Permissões de pastas ajustadas para 0755 em $home_dir."

    # Ajusta permissões de arquivos para 0644
    find "$home_dir" -type f -exec chmod 0644 {} \;
    echo "Permissões de arquivos ajustadas para 0644 em $home_dir."
}

# Função para criar um certificado SSL autoassinado
criar_certificado_ssl() {
    local dominio="$1"
    local usuario="$2"
    local home_dir="/home/$usuario/ssl"
    local certificado="$home_dir/${dominio}.crt"
    local chave="$home_dir/${dominio}.key"
    
    # Solicita informações ao usuário
    read -p "Informe o nome da Organização (O): " organizacao
    read -p "Informe a Unidade Organizacional (OU): " unidade_organizacional

    # Verifica se o diretório SSL existe, caso contrário, cria-o
    if [ ! -d "$home_dir" ]; then
        sudo mkdir -p "$home_dir"
        sudo chown "$usuario":"$usuario" "$home_dir"
    fi

    # Cria o certificado autoassinado
    openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
        -keyout "$chave" -out "$certificado" \
        -subj "/C=BR/ST=Sao Paulo/L=Sao Paulo/O=$organizacao/OU=$unidade_organizacional/CN=$dominio"

    echo "Certificado SSL autoassinado criado com sucesso."
    echo "Certificado: $certificado"
    echo "Chave: $chave"
}

#!/bin/bash

# Função para criar o arquivo de configuração do Nginx
criar_config_nginx() {
    local dominio="$1"
    local usuario="$2"
    local home_dir="/home/$usuario"
    local config_dir="/etc/nginx/sites-available"
    local config_file="$config_dir/$dominio.conf"
    local link_sym_phpmyadmin="$home_dir/public_html/phpmyadmin"
    local certificado="$home_dir/ssl/${dominio}.crt"
    local chave="$home_dir/ssl/${dominio}.key"
    local page_error="$home_dir/page_error"    
    local log_dir="$home_dir/logs"

    # Cria o arquivo de configuração do Nginx
    sudo tee "$config_file" > /dev/null <<EOF
server {
    listen 80;
    server_name $dominio;

    # Redireciona HTTP para HTTPS
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name $dominio;

    ssl_certificate $certificado;
    ssl_certificate_key $chave;

    root $home_dir/public_html;
    index index.php index.html index.htm;

    # Configura logs
    access_log $log_dir/access.log;
    error_log $log_dir/error.log;

    # Páginas de erro
    error_page 404 /404.html;
    error_page 405 /405.html;
    error_page 500 /500.html;

    location = /404.html {
        root $page_error/page_error;
        internal;
    }

    location = /405.html {
        root $page_error/page_error;
        internal;
    }

    location = /500.html {
        root $page_error/page_error;
        internal;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location /phpmyadmin {
        alias $link_sym_phpmyadmin;
        index index.php;
        try_files \$uri \$uri/ =404;
    }
}
EOF

    # Cria um link simbólico para habilitar a configuração do Nginx
    sudo ln -s "$config_file" /etc/nginx/sites-enabled/

    # Cria o link simbólico para o phpMyAdmin
    sudo ln -s /usr/share/phpmyadmin "$link_sym_phpmyadmin"

    # Reinicia o Nginx para aplicar as alterações
    sudo systemctl restart nginx

    echo "Configuração do Nginx criada e habilitada com sucesso para o domínio $dominio."
}

# Exemplo de uso da função
#dominio="meudominio.com.br"
#usuario="nome_do_usuario"

#criar_config_nginx "$dominio" "$usuario"


# Função para criar o usuário e adicionar ao grupo www-data
criar_usuario() {
    local usuario="$1"

    # Cria o usuário com um diretório home, caso ainda não exista
    if ! id -u "$usuario" > /dev/null 2>&1; then
        sudo useradd -m -s /bin/bash "$usuario"
        echo "Usuário $usuario criado com sucesso."
    else
        echo "Usuário $usuario já existe."
    fi

    # Adiciona o usuário ao grupo www-data
    sudo usermod -aG www-data "$usuario"
    echo "Usuário $usuario adicionado ao grupo www-data."
}

# Função para criar as pastas necessárias e ajustar permissões
criar_pastas() {
    local usuario="$1"
    local home_dir="/home/$usuario"

    # Cria as pastas public_html, page_error, logs e ssl
    sudo mkdir -p "$home_dir/public_html" "$home_dir/page_error" "$home_dir/logs" "$home_dir/ssl"
    echo "Pastas public_html, page_error, logs e ssl criadas em $home_dir."

    # Ajusta as permissões das pastas
    sudo chown -R "$usuario":"$usuario" "$home_dir/public_html" "$home_dir/page_error" "$home_dir/logs" "$home_dir/ssl"
    sudo chmod -R 755 "$home_dir/public_html" "$home_dir/page_error" "$home_dir/logs" "$home_dir/ssl"
    echo "Permissões ajustadas para o usuário $usuario."
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

            criar_usuario "$usuario"
            criar_pastas "$usuario"

            create_page_404 "/home/$usuario"
            create_page_405 "/home/$usuario"
            create_page_500 "/home/$usuario"

            create_page_index "/home/$usuario" "$dominio_completo"
            create_page_info_php "/home/$usuario"

            ajustar_permissoes "$usuario"

            criar_certificado_ssl "$dominio" "$usuario"

            criar_config_nginx "$dominio" "$usuario"

            break
        else
            echo "TLD inválido. Tente novamente."
        fi
    else
        echo "Formato de domínio inválido. Não use acentos, espaços, ou insira um TLD válido. Tente novamente."
    fi
done
