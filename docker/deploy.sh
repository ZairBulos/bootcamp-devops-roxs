#!/bin/bash

# Verificar que las variables de entorno DOCKER_USER y DOCKER_PASS estén definidas
if [ -z "$DOCKER_USER" ] || [ -z "$DOCKER_PASS" ]; then
  echo "Por favor, define DOCKER_USER y DOCKER_PASS antes de ejecutar el script."
  exit 1
fi

# Definir variables
DOCKER_REPO="295words"
VERSION=$(git describe --tags --abbrev=0)

# Verificar que se haya encontrado un tag en el repositorio
if [ -z "$VERSION" ]; then
  echo "No se ha encontrado un tag en el repositorio."
  exit 1
fi

# Iniciar sesión en Docker Hub
echo "Iniciando sesión en Docker Hub..."
echo $DOCKER_PASS | docker login -u ${DOCKER_USER} --password-stdin

# Construir las imágenes Docker
echo "Construyendo las imágenes Docker..."
docker build -t ${DOCKER_USER}/${DOCKER_REPO}-db:$VERSION ./db
docker build -t ${DOCKER_USER}/${DOCKER_REPO}-api:$VERSION ./api
docker build -t ${DOCKER_USER}/${DOCKER_REPO}-web:$VERSION ./web

# Subir las imágenes a Docker Hub
echo "Subiendo las imágenes a Docker Hub..."
docker push ${DOCKER_USER}/${DOCKER_REPO}-db:$VERSION
docker push ${DOCKER_USER}/${DOCKER_REPO}-api:$VERSION
docker push ${DOCKER_USER}/${DOCKER_REPO}-web:$VERSION

# Iniciar los servicios
echo "Iniciando los servicios..."
docker-compose up -d

echo "¡Despliegue completado!"