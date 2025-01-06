# Challenge 01

## Desafío: Desplegar contenedores de MongoDB y Mongo Express

### Objetivo

En este desafío, vas a crear un entorno Docker que incluya dos contenedores: uno para MongoDB y otro para Mongo Express. MongoDB será protegido con un usuario y contraseña, mientras que Mongo Express te permitirá gestionar la base de datos a través de una interfaz web.

### Instrucciones

1. Crea el contenedor de MongoDB:

- Utiliza Docker para crear un contenedor de MongoDB.
- Configura el contenedor con las variables de entorno necesarias para establecer un usuario y una contraseña de acceso.

2. Configura Mongo Express:

- Despliega un segundo contenedor con Mongo Express.
- Asegúrate de que Mongo Express esté conectado al contenedor de MongoDB que creaste previamente.

3. Conéctate a Mongo Express:

- Accede a la interfaz web de Mongo Express a través de tu navegador.
- Crea una base de datos llamada Library con una colección llamada Books.

4. Importa datos en MongoDB:

- En el directorio de tu máquina, coloca el archivo books.json con el siguiente contenido:
  ```text
  [
    { "title": "Docker in Action, Second Edition", "author": "Jeff Nickoloff and Stephen Kuenzli" },
    { "title": "Kubernetes in Action, Second Edition", "author": "Marko Lukša" }
  ]
  ```
- Utiliza la interfaz de Mongo Express para importar los datos de books.json a la colección Books en la base de datos Library.

## Solución

```bash
docker network create challenge-01
```

```bash
docker run -d --name mongo-db \
  --network challenge-01 \
  -e MONGO_INITDB_ROOT_USERNAME="root" \
  -e MONGO_INITDB_ROOT_PASSWORD="example" \
  -p 27017:27017 mongo
```

```bash
docker run -d --name mongo-express \
  --network challenge-01 \
  -e ME_CONFIG_BASICAUTH_USERNAME="admin" \
  -e ME_CONFIG_BASICAUTH_PASSWORD="admin" \
  -e ME_CONFIG_MONGODB_ADMINUSERNAME="root" \
  -e ME_CONFIG_MONGODB_ADMINPASSWORD="example" \
  -e ME_CONFIG_MONGODB_SERVER="mongo-db" \
  -e ME_CONFIG_MONGODB_URL="mongodb://mongo-db:27017" \
  -p 8081:8081 mongo-express
```

```bash
http://localhost:8081
```