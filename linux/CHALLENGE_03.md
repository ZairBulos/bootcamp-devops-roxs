# Challenge 03

## Ejercicio de Linux para DevOps

Este ejercicio cubre todos los conceptos básicos necesarios para familiarizarte con Linux como DevOps.

## Solución

1. Inicia sesión en el servidor como superusuario y realiza lo siguiente

- Crear usuarios y establecer contraseñas: user1, user2, user3
- Crear grupos: devops, aws
- Cambiar el grupo primario de user2 y user3 al grupo ‘devops’
- Agregar el grupo ‘aws’ como grupo secundario a ‘user1’
- Crear la estructura de archivos y directorios especificada
- Cambiar el grupo de /dir1, /dir7/dir10, y /f2 al grupo “devops”
- Cambiar la propiedad de /dir1, /dir7/dir10, y /f2 al usuario “user1”

```bash
sudo useradd user1
sudo passwd user1

sudo useradd user2
sudo passwd user2

sudo useradd user3
sudo passwd user3
```

```bash
sudo groupadd devops
sudo groupadd aws
```

```bash
sudo usermod -g devops user2
sudo usermod -g devops user3
```

```bash
sudo usermod -aG aws user1
```

```bash
sudo mkdir -p /dir1 /dir7/dir10 /f2
```

```bash
sudo chgrp devops /dir1
sudo chgrp devops /dir7/dir10
sudo chgrp devops /f2
```

```bash
sudo chown user1:user1 /dir1   
sudo chown user1:user1 /dir7/dir10
sudo chown user1:user1 /f2
```

2. Inicia sesión como user1 y realiza lo siguiente

- Crear usuarios y establecer contraseñas: user4, user5
- Crear grupos: app, database

```bash
su - user1
```

```bash
sudo useradd user4
sudo passwd user4

sudo useradd user5
sudo passwd user5
```

```bash
sudo groupadd app
sudo groupadd database
```

3. Inicia sesión como ‘user4’ y realiza lo siguiente

- Crear directorio: /dir6/dir4
- Crear archivo: /f3
- Mover el archivo de “/dir1/f1” a “/dir2/dir1/dir2”
- Renombrar el archivo ‘/f2’ a ‘/f4’

```bash
su - user4
```

```bash
sudo mkdir -p /dir6/dir4
```

```bash
sudo touch /f3
```

```bash
sudo mv /dir1/f1 /dir2/dir1/dir2
```

```bash
sudo mv /f2 /f4
```

4. Inicia sesión como ‘user1’ y realiza lo siguiente

- Crear directorio: /home/user2/dir1
- Cambiar al directorio “/dir2/dir1/dir2/dir10” y crear el archivo “/opt/dir14/dir10/f1” usando el método de ruta relativa.
- Mover el archivo de “/opt/dir14/dir10/f1” al directorio home de user1
- Eliminar recursivamente el directorio “/dir4”
- Eliminar todos los archivos y directorios bajo “/opt/dir14” usando un solo comando
- Escribir el texto “Linux assessment for an DevOps Engineer!! Learn with Fun!!” en el archivo /f3 y guardarlo

```bash
su - user1
```

```bash
sudo mkdir -p /home/user2/dir1
```

```bash
cd /dir2/dir1/dir2/dir10
touch ../../../../opt/dir14/dir10/f1
```

```bash
sudo mv /opt/dir14/dir10/f1 /home/user1/
```

```bash
sudo rm -rf /dir4
```

```bash
sudo rm -rf /opt/dir14/*
```

```bash
echo "Linux assessment for a DevOps Engineer!! Learn with Fun!!" > sudo tee /f3
```

5. Inicia sesión como ‘user2’ y realiza lo siguiente

- Crear archivo: /dir1/f2
- Eliminar /dir6
- Eliminar /dir8
- Reemplazar el texto “DevOps” por “devops” en el archivo /f3 sin usar un editor
- Usando Vi-Editor, copiar la línea 1 y pegarla 10 veces en el archivo /f3
- Buscar el patrón “Engineer” y reemplazarlo por “engineer” en el archivo /f3 usando un solo comando
- Eliminar /f3

```bash
su - user2
```

```bash
sudo touch /dir1/f2
```

```bash
sudo rm -rf /dir6
```

```bash
sudo rm -rf /dir8
```

```bash
sudo sed -i 's/DevOps/devops/g' /f3
```

```bash
sudo vi /f3
```

```bash
sudo sed -i 's/Engineer/engineer/g' /f3
```

```bash
sudo rm -f /f3
```

6. Inicia sesión como ‘root’ y realiza lo siguiente

- Buscar el archivo ‘f3’ en el servidor y listar todas las rutas absolutas donde se encuentra el archivo f3
- Mostrar el conteo de archivos en el directorio ‘/’
- Imprimir la última línea del archivo ‘/etc/passwd’
- Crear un sistema de archivos en un nuevo volumen EBS simulado y montarlo en el directorio /data
- Verificar la utilización del sistema de archivos usando ‘df -h’
- Crear un archivo ‘f1’ en el sistema de archivos /data

```bash
su - root
```

```bash
sudo find / -name f3
```

```bash
sudo find / -type f | wc -l 
```

```bash
tail -n 1 /etc/passwd
```

```bash
sudo mkfs.ext4 /dev/xvdf
sudo mkdir /data
sudo mount /dev/xvdf /data
```

```bash
df -h
```

```bash
sudo touch /data/f1
```

7. Inicia sesión como ‘user5’ y realiza lo siguiente

- Eliminar /dir1
- Eliminar /dir2
- Eliminar /dir3
- Eliminar /dir5
- Eliminar /dir7
- Eliminar /f1 y /f4
- Eliminar /opt/dir14

```bash
su - user5
```

```bash
sudo rm -rf /dir1
```

```bash
sudo rm -rf /dir2
```

```bash
sudo rm -rf /dir3
```

```bash
sudo rm -rf /dir5
```

```bash
sudo rm -rf /dir7
```

```bash
sudo rm -f /f1 /f4
```

```bash
sudo rm -rf /opt/dir14
```

8. Inicia sesión como ‘root’ y realiza lo siguiente

- Eliminar usuarios: user1, user2, user3, user4, user5
- Eliminar grupos: app, aws, database, devops
- Eliminar directorios home de todos los usuarios si aún existen
- Desmontar el sistema de archivos /data
- Eliminar el directorio /data

```bash
su - root
```

```bash
sudo userdel -r user1
sudo userdel -r user2
sudo userdel -r user3
sudo userdel -r user4
sudo userdel -r user5
```

```bash
sudo groupdel app
sudo groupdel aws
sudo groupdel database
sudo groupdel devops
```

```bash
sudo rm -rf /home/user1
sudo rm -rf /home/user2
sudo rm -rf /home/user3
sudo rm -rf /home/user4
sudo rm -rf /home/user5
```

```bash
sudo umount /data
```

```bash
sudo rm -rf /data
```