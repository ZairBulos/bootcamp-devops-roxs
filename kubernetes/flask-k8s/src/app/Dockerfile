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