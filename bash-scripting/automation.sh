#!/bin/bash

# Verificar si el script se ejecuta como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta este script como root."
  exit 1
fi

echo "Actualizando el sistema..."
apt update && apt upgrade -y

echo "Instalando dependencias..."
apt install -y git docker.io

echo "Clonando el repositorio de la aplicación..."
git clone -b devops-automation-python https://github.com/roxsross/devops-static-web.git
cd devops-static-web

echo "Creando el directorio temporal..."
mkdir -p tempdir/templates tempdir/static

echo "Copiando los archivos de la aplicación al directorio temporal..."
cp -r static/* tempdir/static
cp -r templates/* tempdir/templates
cp desafio2_app.py tempdir/
cd tempdir

echo "Creando el archivo Dockerfile..."
cat <<EOL >Dockerfile
FROM python
RUN pip install flask
COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY desafio2_app.py /home/myapp/
EXPOSE 5050
CMD python3 /home/myapp/desafio2_app.py
EOL

echo "Iniciando el servicio Docker..."
systemctl start docker
systemctl enable docker

echo "Construyendo la imagen de Docker..."
docker build -t automation .

echo "Ejecutando la imagen de Docker..."
docker run -t -d -p 5050:5050 --name automationapp automation

echo "Listando los contenedores..."
docker ps -a

echo "Mostrando los logs del contenedor..."
CONTAINER_ID=$(docker ps -q -f name=automationapp)
docker logs "$CONTAINER_ID"

echo "Validando la IP del contenedor..."
CONTAINER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$CONTAINER_ID")
if [ -z "$CONTAINER_IP" ]; then
  echo "No se pudo obtener la IP del contenedor."
else
  echo "La aplicación está disponible en: http://$CONTAINER_IP:5050"
  echo "O puedes verificar en http://localhost:5050 si estás ejecutando en tu máquina local."
fi