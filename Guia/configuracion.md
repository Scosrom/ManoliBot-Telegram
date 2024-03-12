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

Para permitir que ciertos usuarios ejecuten comandos en tu servidor a través de ManoliBot, necesitas agregar sus IDs de chat al archivo allowed_chat_ids.txt.

```
sudo nano /opt/ManoliBot/adm/allowed_chat_ids.txt
```

Puedes obtener tu ID de chat enviando el mensaje /getid a IDBot en Telegram. Cada ID que agregues será un nuevo administrador que puede ejecutar comandos en tu servidor.

Agrega los ID de chat como se muestra a continuación:

![image](https://github.com/Scosrom/ManoliBot-Telegram/assets/114906778/bb74a404-c601-4a63-884c-91efdebbe65a)

Si deseas agregar varios ID de chat, la configuración se verá como se muestra a continuación:

![image](https://github.com/Scosrom/ManoliBot-Telegram/assets/114906778/e75befb8-226b-412a-a0c2-06da802e5390)

2. Modificar el archivo `/opt/ManoliBot/control/forbidden_commands.txt`

El archivo forbidden_commands.txt contiene una lista de comandos que no se permiten ejecutar en el servidor a través de ManoliBot. Puedes modificar esta lista según sea necesario.

Aquí hay una lista predeterminada de comandos que se consideran peligrosos:

![image](https://github.com/Scosrom/ManoliBot-Telegram/assets/114906778/ba4aa650-e19b-4624-9eca-a9786beed263)


3. Modificar el archivo `/opt/ManoliBot/hosts/hosts.txt`

El archivo hosts.txt se utiliza para enumerar los hosts que serán gestionados por ManoliBot. Puedes agregar tanto IPs como nombres de host.

A continuación, se muestra un ejemplo de cómo se vería el archivo:
![image](https://github.com/Scosrom/ManoliBot-Telegram/assets/114906778/0ca53d5e-cfbd-4673-9a42-61b5653b80ca)


**Es importante proporcionar la clave pública de SSH al host para poder gestionarlo de manera efectiva.**

4. En el archivo `/opt/ManoliBot/inf/MensajesManoli.txt` se mantiene un registro detallado de todos los comandos ejecutados a través de ManoliBot, junto con la ID desde la cual se realizaron las ejecuciones.
