# Challenge-flask-k8s

Este ejemplo crea una API básica con flask, junto con un consumidor que accede a la API a través del servicio. Para exponer la API, se creó un servicio tipo NodePort, el cual expone un puerto en todos los nodos para que la API sea accesible desde fuera del clúster y por el consumidor desde el nodo.

![](https://github.com/roxsross/k8sonfire/raw/master/challenge-final/docs/Diagrama.png)

## Desafío

1. Crear los Dockerfile de la aplicación y del consumidor.
    - El Dockerfile de la aplicación debe contener las instrucciones necesarias para construir la imagen de la API flask.
    - El Dockerfile del consumidor debe contener las instrucciones necesarias para construir la imagen del consumidor que accederá a la API.

2. Construir las imágenes de la aplicación y del consumidor.
    - Utilizar el comando `docker build` para construir las imágenes.

3. Subir las imágenes a Docker Hub.
    - Utilizar el comando `docker push` para subir las imágenes a un repositorio en Docker Hub.

4. Crear los manifiestos de Kubernetes según el análisis del diagrama.
    - Namespace: Inicial_nombre_apellido
    - Servicio de tipo NodePort.
    - Crear un Deployment para la aplicación flask.
    - Crear un Deployment para el consumidor.
    - Crear un Service de tipo NodePort para exponer la API flask.

5. Aplicar los manifiestos en el clúster EKS.
    - Utilizar el comando `kubectl apply` para aplicar los manifiestos.

6. Tips:
    - La aplicación corre sobre el puerto 8000.
    - El consumidor necesita acceder a `http://service-flask-app`.

## Solución

1. Crear los Dockerfile de la aplicación y del consumidor.

    ```Dockerfile
    FROM python:3.10-alpine

    # Crear un directorio de trabajo
    WORKDIR /app

    # Copiar el archivo de requerimientos e instalar las dependencias
    COPY requirements.txt .
    RUN pip install --no-cache-dir -r requirements.txt

    # Copiar el resto de los archivos de la aplicación
    COPY . .

    # Crear un usuario no root y cambiar la propiedad directorio de trabajo
    RUN adduser -D myuser && chown -R myuser /app
    USER myuser

    # Exponer el puerto 8000
    EXPOSE 8000

    # Ejecutar la aplicación
    CMD ["python", "app.py"]
    ```

    ```Dockerfile
    FROM python:3.10-alpine

    # Crear un directorio de trabajo
    WORKDIR /app

    # Copiar el archivo de requerimientos e instalar las dependencias
    COPY requirements.txt .
    RUN pip install --no-cache-dir -r requirements.txt

    # Copiar el archivo principal de la aplicación
    COPY consumer.py .

    # Crear un usuario no root y cambiar la propiedad directorio de trabajo
    RUN adduser -D myuser && chown -R myuser /app
    USER myuser

    # Ejecutar la aplicación
    CMD ["python", "consumer.py"]
    ```

2. Construir las imágenes de la aplicación y del consumidor.

    ```bash
    docker build -t zairbulos/295k8s-flask ./app
    docker build -t zairbulos/295k8s-consumer ./consumer
    ```

3. Subir las imágenes a Docker Hub.

    ```bash
    docker push zairbulos/295k8s-flask
    docker push zairbulos/295k8s-consumer
    ```

4. Crear los manifiestos de Kubernetes según el análisis del diagrama.

    - Namespace: Inicial_nombre_apellido

        ```yml
        apiVersion: v1
        kind: Namespace
        metadata:
        name: inicial-zair-bulos
        ```

    - Crear un Deployment para la aplicación flask.

        ```yml
        apiVersion: apps/v1
        kind: Deployment
        metadata:
        name: deployment-flask
        labels:
            app: flask
        namespace: inicial-zair-bulos
        spec:
        replicas: 1
        selector:
            matchLabels:
            app: flask
        template:
            metadata:
            labels:
                app: flask
            spec:
            containers:
            - name: flask
                image: zairbulos/295k8s-flask
                resources:
                limits:
                    memory: "128Mi"
                    cpu: "500m"
                ports:
                - containerPort: 8000
        ```

    - Crear un Deployment para el consumidor.

        ```yml
        apiVersion: apps/v1
        kind: Deployment
        metadata:
        name: deployment-consumer
        labels:
            app: consumer
        namespace: inicial-zair-bulos
        spec:
        replicas: 1
        selector:
            matchLabels:
            app: consumer
        template:
            metadata:
            labels:
                app: consumer
            spec:
            containers:
            - name: consumer
                image: zairbulos/295k8s-consumer
                env:
                - name: SERVICE_URL
                    value: "http://service-flask-app"
                resources:
                limits:
                    memory: "128Mi"
                    cpu: "500m"
        ```

    - Crear un Service de tipo NodePort para exponer la API flask.

        ```yml
        apiVersion: v1
        kind: Service
        metadata:
        name: service-flask-app
        namespace: inicial-zair-bulos
        spec:
        type: NodePort
        selector:
            app: flask
        ports:
        - protocol: TCP
            port: 80
            targetPort: 8000
            nodePort: 30000
        ```

5. Aplicar los manifiestos en el clúster EKS.

    ```bash
    kubectl apply -f deployment/namespace.yml
    kubectl apply -f deployment/flask-deployment.yml
    kubectl apply -f deployment/consumer-deployment.yml
    kubectl apply -f deployment/flask-service.yml
    ```

## Resultados

![namespace](/kubernetes/flask-k8s/assets/namespace.png)

![consumer](/kubernetes/flask-k8s/assets/consumer.png)

![flask](/kubernetes/flask-k8s/assets/flask.png)