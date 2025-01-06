# Challenge 04

## Dockerize & Deploy: Desafío Full Stack con Java, Go y PostgreSQL

El objetivo es automatizar la construcción, pruebas, empaquetado y despliegue de las aplicaciones Java y Go, junto con la base de datos PostgreSQL, utilizando Docker y Docker Compose. Incorporar prácticas de versionado semántico y asegurar una integración continua fluida para garantizar la entrega continua y la estabilidad del sistema.

Containerizar una API REST en Java, una aplicación web en Go, una base de datos PostgreSQL, y luego utilizar Docker Compose para orquestar los contenedores. Además, se incluye la subida a Docker Hub y un script bash para manejar versiones que se publican en docker-hub.

### Arquitectura

![](https://github.com/roxsross/bootcamp-devops-2023/raw/ejercicio2-dockeriza/assets/1.png)

### Repositorio

```bash
git clone -b ejercicio2-dockeriza https://github.com/roxsross/bootcamp-devops-2023.git
cd 295words-docker
```

### API REST en Java

Proporciona un proyecto Java que sirva palabras desde una base de datos. Containeriza la aplicación usando un Dockerfile.

```text
Version de JAVA >= 18
Version de Maven >= 3
Se recomienda el uso de amazoncorretto
Conexion string base de datos: postgresql://db:5432/postgres [linea 24 , Main.java]
Port 8080
```

### Aplicación Web en Go

La aplicación web en Go que llama a la API Java y convierta las palabras en oraciones. Containeriza la aplicación utilizando un Dockerfile.

```text
Imagen recomendada: golang:alpine
```

### Base de Datos PostgreSQL

Configura una base de datos PostgreSQL que almacene las palabras.

data de inicio `words.sql`

```text
Imagen recomendada: postgres:15-alpine
datos de conexion:
POSTGRES_USER: postgres
POSTGRES_PASSWORD: postgres
Recuerde de inyectar los datos antes de iniciar el contenedor
```

### Docker Compose

Crea un archivo `docker-compose.yml` que defina servicios para cada contenedor (api, web, db) y configure las conexiones necesarias entre ellos.

### Subida a Docker Hub

- Crea cuentas en Docker Hub si no las tienes.
- Sube las imágenes de tus contenedores al Docker Hub con versiones semánticas utilizando etiquetas. Puedes usar el comando docker push.

### Script Bash

Crea un script bash llamado, por ejemplo, `deploy.sh` que automatice el proceso. El script debe contener pasos para construir las imágenes Docker, etiquetarlas con versiones, subirlas a Docker Hub y ejecutar Docker Compose.

Utiliza herramientas como git describe o semantic-release para gestionar versiones semánticas automáticamente.

Recuerda documentar adecuadamente tu código, Dockerfiles, y el docker-compose.yml.

El script bash debería ser ejecutable y fácil de entender para facilitar la automatización del proceso.

## Solución

### API REST en Java

```Dockerfile
# Imagen base para Java
FROM amazoncorretto:18-alpine

# Establecer el directorio de trabajo
WORKDIR /app

# Instalar Maven
RUN apk add --no-cache maven

# Copiar el archivo pom.xml
COPY pom.xml .

# Copiar el código fuente
COPY src /app/src

# Construir la aplicación Maven
RUN mvn clean package

# Exponer el puerto 8080
EXPOSE 8080	

# Ejecutar la aplicación
CMD ["java", "-jar", "/app/target/words.jar"]
```

### Aplicación Web en Go

```Dockerfile
# Imagen base para golang
FROM golang:alpine

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar los archivos necesarios
COPY dispatcher.go /app
COPY . /app

# Instalar las dependencias y construir la aplicación
RUN go build -o main dispatcher.go

# Exponer el puerto 80
EXPOSE 80

# Ejecutar la aplicación
CMD ["./main"]
```

### Base de Datos PostgreSQL

```Dockerfile
# Imagen base para PostgreSQL
FROM postgres:15-alpine

# Copiar el archivo de inicialización de la base de datos
COPY ./words.sql /docker-entrypoint-initdb.d/

# Exponer el puerto 5432
EXPOSE 5432
```

### Docker Compose

```yml
services:
  # Postgres
  postgres:
    image: zairbulos/295words-db:latest
    container_name: db
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    ports:
      - "5432:5432"
    networks:
      - challenge-04

  # BackEnd
  backend:
    image: zairbulos/295words-api:latest
    container_name: api
    ports:
      - "8080:8080"
    depends_on:
      - postgres
    networks:
      - challenge-04

  # FrontEnd
  frontend:
    image: zairbulos/295words-web:latest
    container_name: web
    ports:
      - "80:80"
    depends_on:
      - backend
    networks:
      - challenge-04

networks:
  challenge-04:
    driver: bridge
```

## Subida a Docker Hub

```bash
docker build -t zairbulos/295words-db:latest ./db
docker tag zairbulos/295words-db:latest zairbulos/295words-db:v1.0.0
docker push zairbulos/295words-db:latest
docker push zairbulos/295words-db:v1.0.0

docker build -t zairbulos/295words-api:latest ./api
docker tag zairbulos/295words-api:latest zairbulos/295words-api:v1.0.0
docker push zairbulos/295words-api:latest
docker push zairbulos/295words-api:v1.0.0

docker build -t zairbulos/295words-web:latest ./web
docker tag zairbulos/295words-web:latest zairbulos/295words-web:v1.0.0
docker push zairbulos/295words-web:latest
docker push zairbulos/295words-web:v1.0.0
```

### Script Bash

```bash
chmod +x deploy.sh
DOCKER_USER="user" DOCKER_PASS="pass" ./deploy.sh
```