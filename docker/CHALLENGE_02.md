# Challenge 01

## Desafío: Crear un Contenedor Nginx

### Objetivo

En este desafío, vas a crear un contenedor Docker que ejecute Nginx y sirva contenido web desde una carpeta específica. El contenedor será accesible desde http://localhost:9999.

### Instrucciones

1. Crear el contenedor Nginx:

- Utiliza Docker para crear un contenedor llamado bootcamp-web.
- Configura el contenedor para que ejecute Nginx y sea accesible desde http://localhost:9999.

2. Clonar el repositorio:

- Desde tu máquina local, clona el siguiente repositorio que contiene el contenido web:
  ```bash
  git clone -b devops-simple-web https://github.com/roxsross/devops-static-web.git
  ```

3. Copiar el contenido al contenedor:

- Copia el contenido de la carpeta `bootcamp-web` del repositorio clonado a la ruta del contenedor Nginx donde se sirven los archivos web, generalmente `/usr/share/nginx/html`.

4. Verificar la copia de archivos:

- Ejecuta `ls` desde fuera del contenedor para asegurarte de que los archivos se han copiado correctamente a la ruta del servidor Nginx.

5. Acceder al sitio web:

- Abre tu navegador y accede a http://localhost:9999 para ver el contenido servido por Nginx desde tu contenedor.

## Solución

```bash
git clone -b devops-simple-web https://github.com/roxsross/devops-static-web.git
cd devops-static-web
```

```bash
docker run -d --name bootcamp-web -v $PWD/bootcamp-web:/usr/share/nginx/html:ro -p 9999:80 nginx:alpine
```

```bash
docker exec -it bootcamp-web sh
ls /usr/share/nginx/html
```

```bash
http://localhost:9999
```