#!/bin/bash

# Verificar si el script se ejecuta como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta este script como root."
  exit 1
fi

# Variables de entorno
USER=$(whoami)
HOME_DIR=$(eval echo ~$USER)
WORK_DIR="$HOME_DIR/bash-challenges/challenge_02"

# 2. Preparación del entorno
echo "Actualizando el sistema..."
apt update -qq && apt upgrade -y -qq
apt install -y python3-pip python3-venv git

echo "Activando el entorno virtual..."
rm -rf $WORK_DIR
mkdir -p $WORK_DIR
cd $WORK_DIR
python3 -m venv venv
source venv/bin/activate

# 3. Configuración de la aplicación
echo "Clonando el repositorio de la aplicación..."
git clone -b booklibrary https://github.com/roxsross/devops-static-web.git

# 4. Instalación de dependencias
echo "Instalando dependencias de la aplicación..."
cd devops-static-web
pip install -r requirements.txt

# 5. Configuración de Gunicorn
echo "Configurando Gunicorn..."
pip install gunicorn
cat <<EOL >/etc/systemd/system/library_site.service
[Unit]
Description=Gunicorn instance to serve library_site
After=network.target

[Service]
User=$USER
Group=www-data
WorkingDirectory=$WORK_DIR/devops-static-web
ExecStart=$WORK_DIR/venv/bin/gunicorn -b localhost:8000 library_site:app
Restart=always

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload
systemctl start library_site
systemctl enable library_site

# 6. Integración y configuración de Nginx
echo "Instalando Nginx..."
apt install nginx -y
systemctl start nginx
systemctl enable nginx

echo "Configurando Nginx..."
cat <<EOL >/etc/nginx/sites-available/library_site
server {
  listen 80;
  server_name _;

  location / {
    proxy_pass http://localhost:8000;
  }
}
EOL

ln -s /etc/nginx/sites-available/library_site /etc/nginx/sites-enabled/

echo "Reiniciando Nginx..."
systemctl restart nginx