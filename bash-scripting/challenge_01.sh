#!/bin/bash

# Verificar si el script se ejecuta como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta este script como root."
  exit 1
fi

# 1. Preparación del Servidor
echo "Actualizando el sistema..."
apt update -qq && apt upgrade -y -qq
apt install -y -qq curl git nginx

# 2. Instalación de Dependencias
echo "Instalando paquetes necesarios..."

if command -v node &> /dev/null; then
  echo "Node.js ya está instalado. Versión: $(node -v)"
else
  echo "Node.js no está instalado. Instalando Node.js..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install 16
  nvm use 16
fi

if command -v pm2 &> /dev/null; then
  echo "PM2 ya está instalado. Versión: $(pm2 -v)"
else
  echo "PM2 no está instalado. Instalando PM2..."
  npm install pm2@latest -g
fi

# 3. Configuración de Aplicaciones
rm -rf bash-challenges/challenge_01
mkdir -p bash-challenges/challenge_01
cd bash-challenges/challenge_01

echo "Clonando el repositorio de aplicaciones..."
git clone -b ecommerce-ms https://github.com/roxsross/devops-static-web.git
cd devops-static-web

echo "Instalando dependencias de las aplicaciones..."
for dir in frontend merchandise products shopping-cart; do
  cd "$dir"
  npm install
  cd ..
done

# 4. Despliegue de Aplicaciones
echo "Configurando y desplegando aplicaciones con PM2..."

declare -A APPS
APPS=(
  ["frontend"]="3000"
  ["products"]="3001"
  ["shopping-cart"]="3002"
  ["merchandise"]="3003"
)

for app in "${!APPS[@]}"; do
  PORT=${APPS[$app]}
  echo "Desplegando $app en el puerto $PORT..."
  pm2 start npm --name "$app" --cwd ./$app -- start -- --port $PORT
done

# 5. Configuración del Servidor Web
echo "Configurando Nginx..."
NGINX_CONFIG_PATH="/etc/nginx/sites-available"
NGINX_ENABLED_PATH="/etc/nginx/sites-enabled"

for app in "${!APPS[@]}"; do
  PORT=${APPS[$app]}
  CONFIG_FILE="$NGINX_CONFIG_PATH/$app"
  echo "Configurando Nginx para $app en el puerto $PORT..."

  cat >"$CONFIG_FILE" <<EOL
server {
  listen 80;
  server_name $app.localhost;

  location / {
    proxy_pass http://localhost:$PORT;
  }
}
EOL

  ln -sf "$CONFIG_FILE" "$NGINX_ENABLED_PATH/$app"
done

echo "Habilitando Nginx..."
systemctl enable nginx

echo "Iniciando Nginx..."
systemctl start nginx

echo "Recargando Nginx..."
nginx -t && systemctl reload nginx

# 6. Automatización y Monitoreo
pm2 startup
pm2 save

# Finalización del Despliegue
echo "Despliegue completado exitosamente."
echo "Puedes acceder a las aplicaciones en los dominios locales configurados."