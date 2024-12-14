# Challenge 01

## Desafío: Despliega la Aplicación Flask "Book Library" con Nginx y Gunicorn

En este reto, desplegarás una aplicación web desarrollada en Python con el framework Flask , utilizando Nginx como proxy inverso y Gunicorn como servidor WSGI.

## Solución

1. Configuración del servidor con la distro de preferencia

Linux Lite 7.2

2. Preparación del entorno

- Instala Python 3, pip y virtualenv.
- Crea un entorno virtual para la aplicación.
- Instala Flask y otras dependencias necesarias en el entorno virtual.

```bash
sudo apt install -y python3-pip python3-venv
```

```bash
mkdir -p ~/linux-challenges/challenge-01
cd ~/linux-challenges/challenge-01
python3 -m venv venv
source venv/bin/activate
```

3. Despliegue de la aplicación

```bash
git clone -b booklibrary https://github.com/roxsross/devops-static-web.git
```

4. Instalas las dependencia de la aplicacion

```bash
pip install -r requirements.txt
```

5. Configuración de Gunicorn

- Instala Gunicorn en el entorno virtual.
- Crea un archivo de servicio systemd para Gunicorn.
- Configura Gunicorn para servir tu aplicación Flask.

```bash
pip install gunicorn
```

```bash
sudo mousepad /etc/systemd/system/library_site.service
```

```text
[Unit]
Description=Gunicorn instance to serve library_site
After=network.target

[Service]
User=zair
Group=www-data
WorkingDirectory=/home/zair/linux-challenges/challenge-01/devops-static-web
ExecStart=/home/zair/linux-challenges/challenge-01/venv/bin/gunicorn -b localhost:8000 library_site:app
Restart=always

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl start helloworld
sudo systemctl enable helloworld
```


6. Instalación y configuración de Nginx

- Instala Nginx en el servidor Ubuntu.
- Configura Nginx como proxy inverso para Gunicorn.
- Asegúrate de que Nginx esté escuchando en el puerto 80 y redirigiendo el tráfico a tu aplicación Flask.

```bash
sudo apt install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

```bash
sudo mousepad /etc/nginx/sites-available/library_site
```

```text
upstream flaskchallenge01 {
  server 127.0.0.1:8000
}

server {
  listen 80;
  listen [::]:80;

  server_name _;

  location / {
    proxy_pass http://flaskchallenge01;
  }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/library_site /etc/nginx/sites-enabled/
```

```bash
sudo systemctl restart nginx
```