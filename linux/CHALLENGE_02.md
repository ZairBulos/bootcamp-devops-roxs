# Challenge 02

## Desafío: Despliegue de Aplicaciones con PM2

La empresa ZERO Technology ha lanzado un nuevo proyecto que requiere la implementación de múltiples aplicaciones en un servidor. El objetivo es desplegar tanto el frontend como varios servicios backend utilizando PM2 para gestionar los procesos.

## Solución

1. Preparación del Servidor

- Asegúrate de tener acceso a un servidor Ubuntu (o la distribución de tu elección).
- Actualiza el sistema y prepara el servidor para la instalación de las herramientas necesarias.

Linux Lite 7.2

```bash
sudo apt update
sudo apt -y upgrade
```

2. Instalación de Dependencias

- Instala Node.js y npm si no están instalados.
- Version Node 18.
- Instala PM2 globalmente.

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.bashrc
```

```bash
nvm list-remote
nvm install v18.20.5
nvm use v18.20.5
```

```bash
npm install pm2@latest -g
```

3. Configuración de Aplicaciones

- Clona el repositorio.
- Configuración de Aplicaciones.

```bash
git clone -b ecommerce-ms https://github.com/roxsross/devops-static-web.git
```

```bash
cd frontend
npm install

cd merchandise
npm install

cd products
npm install

cd shopping-cart
npm install
```

4. Despliegue de Aplicaciones

- Utiliza PM2 para iniciar cada aplicación.
- Verifica que las aplicaciones estén corriendo.

```bash
pm2 start npm --name "frontend" --cwd ./frontend -- start -- --port 3000

pm2 start npm --name "products" --cwd ./products -- start -- --port 3001

pm2 start npm --name "shopping-cart" --cwd ./shopping-cart -- start -- --port 3002

pm2 start npm --name "merchandise" --cwd ./merchandise -- start -- --port 3003
```

```bash
pm2 list
```

5. Configuración del Servidor Web (opcional)

- Si decides configurar un servidor web como Nginx para gestionar el tráfico, instala y configura Nginx para redirigir el tráfico a las aplicaciones.
- Configura los bloques de servidor en Nginx para redirigir el tráfico a los puertos de las aplicaciones.

```bash
sudo apt install nginx
```

```bash
sudo mousepad /etc/nginx/sites-available/frontend
```
```text
server {
  listen 80;
  server_name frontend.localhost;

  location / {
    proxy_pass http://localhost:3000;
  }
}
```

```bash
sudo mousepad /etc/nginx/sites-available/products
```
```text
server {
  listen 80;
  server_name products.localhost;

  location / {
    proxy_pass http://localhost:3001;
  }
}
```

```bash
sudo mousepad /etc/nginx/sites-available/shopping-cart
```
```text
server {
  listen 80;
  server_name shopping-cart.localhost;

  location / {
    proxy_pass http://localhost:3002;
  }
}
```

```bash
sudo mousepad /etc/nginx/sites-available/merchandise
```
```text
server {
  listen 80;
  server_name merchandise.localhost;

  location / {
    proxy_pass http://localhost:3003;
  }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/frontend /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/products /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/shopping-cart /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/merchandise /etc/nginx/sites-enabled/
```

```bash
sudo systemctl reload nginx
```

6. Automatización y Monitoreo

- Configura PM2 para reiniciar las aplicaciones automáticamente al reiniciar el servidor.
- Guarda el estado actual de las aplicaciones para que se restauren al reiniciar el servidor.
- Considera configurar herramientas de monitoreo para verificar el estado y el rendimiento de las aplicaciones.

```bash
pm2 startup
```

```bash
pm2 save
```