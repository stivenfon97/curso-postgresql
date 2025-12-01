# PostgreSQL

### Imagenes de docker
```
docker pull postgres:15.3
docker pull dpage/pgadmin4

```

### Al ser ejecutado en Alma Linux se deben de tomar en consideracion los siguientes permisos

```
# Crear directorios
mkdir -p ./postgres ./pgadmin

# Establecer propietarios correctos
sudo chown -R 999:999 ./postgres
sudo chown -R 5050:5050 ./pgadmin

# Establecer permisos
sudo chmod -R 700 ./postgres
sudo chmod -R 700 ./pgadmin

```