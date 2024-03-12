# Configuración de ManoliBot.

ManoliBot se instala en `/opt/ManoliBot` y consta de la siguiente estructura:

## Estructura de Carpetas y Archivos

### Carpetas y Archivos

- `/opt`
  - `/ManoliBot`
      - `/inf`
      
          - MensajesManoli.txt: Archivo donde se guardarán los mensajes.
      - `/control`

          - forbidden_commands.txt: Archivo que contiene los comandos prohibidos.
      - `/hosts`
      
          - hosts.txt: Archivo que contiene los hosts disponibles para ejecución remota.
      - `/adm`
        
          - allowed_chat_ids.txt: Archivo que contiene los IDs de chat permitidos.
    - `last_update_id.txt`: Archivo para guardar el último ID de actualización procesado.


## Configuración

1. Modificar el archivo `/opt/ManoliBot/adm/allowed_chat_ids.txt`

```
sudo nano /opt/ManoliBot/adm/allowed_chat_ids.txt
```

Añadimos nuestro chatID que podemos obtener en Telegram, abriendo una conversacion con IDBot y escribiendo `/getid`

![image](https://github.com/Scosrom/ManoliBot-Telegram/assets/114906778/bb74a404-c601-4a63-884c-91efdebbe65a)

Puedes añadir tantos ID como quieras. Cada ID que introduzcas es un nuevo administrador que puede ejecutar comandos en tu servidor, debes tener cuidado con esto. 

Con varios ID`s quedaria así:

![image](https://github.com/Scosrom/ManoliBot-Telegram/assets/114906778/e75befb8-226b-412a-a0c2-06da802e5390)

2. Modificar el archivo `/opt/ManoliBot/control/forbidden_commands.txt`



