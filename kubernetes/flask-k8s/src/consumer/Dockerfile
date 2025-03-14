# Etapa 1
FROM python:3.10-alpine AS builder

# Crear un directorio de trabajo
WORKDIR /app

# Copiar el archivo de requerimientos e instalar las dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Etapa 2
FROM python:3.10-alpine

# Crear un directorio de trabajo
WORKDIR /app

# Copiar únicamente las dependencias desde la etapa builder
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages

# Copiar el archivo principal de la aplicación
COPY consumer.py .

# Crear un usuario no root y cambiar la propiedad directorio de trabajo
RUN addgroup -S myuser && adduser -S myuser -G myuser && \
    chown -R myuser:myuser /app
USER myuser

# Ejecutar la aplicación
CMD ["python", "consumer.py"]