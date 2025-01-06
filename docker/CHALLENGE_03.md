# Challenge 03

## Desafío: Despliegue de la Aplicación "295topics" con Docker y Docker Compose

Este desafío se centra en la configuración y despliegue de la aplicación "295topics", que consta de un frontend en Node.js, un backend en TypeScript, y una base de datos MongoDB, utilizando contenedores Docker y Docker Compose.

### Arquitectura

- **Frontend en Node.js y Express**: Servirá contenido web en el puerto 3000. Deberás crear un Dockerfile para el frontend, construir la imagen y publicarla en Docker Hub.

- **Backend en TypeScript**: Se ejecutará en el puerto 5000 y se conectará a una base de datos MongoDB. Deberás crear un Dockerfile para el backend, construir la imagen y publicarla en Docker Hub.

- **Base de Datos MongoDB**: Se desplegará a través de un contenedor de MongoDB. Además, deberás configurar un archivo `mongo-init.js` para cargar datos iniciales en la base de datos al iniciar el contenedor.

### Requisitos

#### Preparación del Entorno

1. Clona el repositorio del desafío:

```bash
git clone -b ejercicio2-dockeriza https://github.com/roxsross/bootcamp-devops-2023.git
cd 295topics-fullstack
```

#### Frontend en Node.js y Express

- **Configuración**: El código fuente del frontend utiliza el puerto 3000 para exponer la aplicación.

- **Dockerfile**: Crea un Dockerfile que incluya todas las dependencias necesarias y establezca el comando de inicio.

- **Construcción y Publicación**: Construye la imagen del frontend y publícala en Docker Hub.

- **Conexión con el Backend**: Asegúrate de que el frontend consume el endpoint del backend a través de la variable API_URI:
  
  ```text
  API_URI=http://topics-api:5000/api/topics
  ```

- **Pruebas**: Verifica el funcionamiento del frontend accediendo a http://localhost:3000. Revisa los logs para solucionar posibles problemas.

#### Backend en TypeScript

- **Configuración**: El código fuente del backend utiliza el puerto 5000 y se conecta a una base de datos MongoDB.

- **Dockerfile**: Crea un Dockerfile que incluya todas las dependencias necesarias y establezca el comando de inicio.

- **Variables de Entorno**: Asegúrate de configurar las siguientes variables de entorno en el Dockerfile o en el archivo de configuración:

  ```text
  DATABASE_URL=mongodb://<tu-contenedor-mongo>:27017
  DATABASE_NAME=TopicstoreDb
  HOST=0.0.0.0
  PORT=5000
  ```

- **Construcción y Publicación**: Construye la imagen del backend y publícala en Docker Hub.

- **Pruebas**: Verifica el funcionamiento del backend accediendo a http://localhost:5000/api/topics. Revisa los logs para identificar posibles errores.

#### Base de Datos MongoDB

- **Configuración Inicial**: Utiliza el archivo `mongo-init.js` para precargar datos en la base de datos MongoDB al iniciar el contenedor.

- **Configuración del Contenedor**: Configura un contenedor Docker para MongoDB y utiliza el archivo `mongo-init.js` para la inicialización.

- **Pruebas**: Verifica que los datos se hayan cargado correctamente conectándote al contenedor MongoDB:

  ```bash
  docker exec -it <nombre-contenedor-mongo> mongosh
  > use TopicstoreDb
  > db.Topics.find()
  ```

#### Mongo Express

- **Configuración**: Configura un contenedor Docker para Mongo Express y asegúrate de que esté correctamente conectado a la base de datos MongoDB para su gestión.

#### Docker Compose

- **Configuración de Servicios**: Crea un archivo docker-compose.yml que defina los servicios para el frontend, el backend, MongoDB, y Mongo Express.

- **Dependencias de Servicios**: Asegúrate de establecer las dependencias adecuadas para que los servicios se inicien en el orden correcto.

- **Pruebas**: Verifica el correcto funcionamiento de la aplicación ejecutando docker-compose up y accediendo a los servicios correspondientes.

## Solución

### Preparación del Entorno

```bash
git clone -b ejercicio2-dockeriza https://github.com/roxsross/bootcamp-devops-2023.git
cd 295topics-fullstack
```

### Frontend en Node.js y Express

```Dockerfile
# Imagen base para Node.js
FROM node:alpine

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar los archivos de configuración de dependencias
COPY package.json ./

# Instalar las dependencias
RUN npm install

# Copiar el resto de los archivos
COPY . .

# Exponer el puerto 3000
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["node", "server.js"]
```

```bash
docker build -t zairbulos/295topics-frontend:latest ./frontend
docker tag zairbulos/295topics-frontend:latest zairbulos/295topics-frontend:v1.0.0
docker push zairbulos/295topics-frontend:latest
docker push zairbulos/295topics-frontend:v1.0.0
```

### Backend en TypeScript

```Dockerfile
# Imagen base para Node.js
FROM node:alpine

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar los archivos de configuración de dependencias
COPY package.json ./

# Instalar las dependencias
RUN npm install

# Copiar el resto de los archivos
COPY . .

# Exponer el puerto 5000
EXPOSE 5000

# Comando para iniciar la aplicación
CMD ["npm", "start"]
```

```bash
docker build -t zairbulos/295topics-backend:latest ./backend
docker tag zairbulos/295topics-backend:latest zairbulos/295topics-backend:v1.0.0
docker push zairbulos/295topics-backend:latest
docker push zairbulos/295topics-backend:v1.0.0
```

### Base de Datos MongoDB

```Dockerfile
# Imagen base para MongoDB
FROM mongo:latest

# Copiar el archivo de inicialización de la base de datos
COPY ./mongo-init.js /docker-entrypoint-initdb.d/

# Exponer el puerto 27017
EXPOSE 27017
```

```bash
docker build -t zairbulos/295topics-db:latest ./db
docker tag zairbulos/295topics-db:latest zairbulos/295topics-db:v1.0.0
docker push zairbulos/295topics-db:latest
docker push zairbulos/295topics-db:v1.0.0
```

### Docker Compose

```yaml
services:
  # MongoDB
  mongo-db:
    image: zairbulos/295topics-db:latest
    container_name: mongo-db
    ports:
      - "27017:27017"
    networks:
      - challenge-03
  
  # Mongo Express
  mongo-express:
    image: mongo-express:latest
    container_name: mongo-express
    ports:
      - "8081:8081"
    environment:
      - ME_CONFIG_MONGODB_SERVER=mongo-db
      - ME_CONFIG_MONGODB_PORT=27017
      - ME_CONFIG_MONGODB_URL=mongodb://mongo-db:27017
      - ME_CONFIG_BASICAUTH_USERNAME=admin
      - ME_CONFIG_BASICAUTH_PASSWORD=admin
    depends_on:
      - mongo-db
    networks:
      - challenge-03

  # BackEnd
  backend:
    image: zairbulos/295topics-backend:latest
    container_name: topics-api
    ports:
      - "5000:5000"
    environment:
      - DATABASE_URL=mongodb://mongo-db:27017
      - DATABASE_NAME=TopicstoreDb
      - HOST=0.0.0.0
      - PORT=5000
    depends_on:
      - mongo-db
    networks:
      - challenge-03
  
  # FrontEnd
  frontend:
    image: zairbulos/295topics-frontend:latest
    container_name: topics-web
    ports:
      - "3000:3000"
    environment:
      - API_URI=http://topics-api:5000/api/topics
    depends_on:
      - backend
    networks:
      - challenge-03

networks:
  challenge-03:
    driver: bridge
```