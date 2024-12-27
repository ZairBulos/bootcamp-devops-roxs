# Challenge 03

## Diseñar un Script automatizado en bash - shell que permita la construccion de una aplicacion en python usando el framework Flask

## Instrucciones

1. Clona el repositorio

```bash
git clone -b devops-automation-python https://github.com/roxsross/devops-static-web.git
```

2. Crear un script con el nombre **automation.sh** y les dejo el modelo en el repo, que contendra lo siguiente

```bash
chmod u+x automation.sh
```

- Que Permita crear una carpeta temporal llamada "tempdir" y a los subdirectorios tempdir/templates y tempdir/static

- Dentro de la carpeta "tempdir" Copiar la carpeta static/ , templates/ y la aplicación desafio2_app.py
  
- Que el script permita construir un Dockerfile y estara ubicado en la carpeta temporal "tempdir"

- Que informacion debe tener el dockerfile

  ```bash
    FROM python
    RUN pip install flask
    COPY ./static /home/myapp/static/
    COPY ./templates /home/myapp/templates/
    COPY desafio2_app.py /home/myapp/
    EXPOSE 5050
    CMD python3 /home/myapp/desafio2_app.py
  ```

### Opcional prueba del script

- El mismo script debe permitir la contrucción de la aplicación con 

  ```bash
  docker build -t nombreapp .
  ```

- Ademas que quede iniciando la aplicación con

  ```bash
  docker run -t -d -p 5050:5050 --name nombreapprunning nombreapp
  ```

- Y como ultimo paso del script que tenga salida

  ```bash
  docker ps -a
  ```

- Si la construccion es correcta, recomiendo miren los logs con

  ```bash
  docker logs "CONTAINER ID"
  ```

- Pueden validar en el navegador con http://localhost:5050 o revisen el ip con docker inspect

  ```bash
  docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id
  ```

## Solución

```bash
chmod u+x automation.sh
sudo ./automation.sh
```