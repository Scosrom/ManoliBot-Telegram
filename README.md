# ManoliBot-Telegram

Este proyecto es un bot de Telegram desarrollado en Bash que permite ejecutar comandos en el servidor local y en hosts específicos a través de mensajes enviados desde Telegram.


## Características
- Interfaz de Telegram: ManoliBot se integra con Telegram, lo que permite a los usuarios enviar comandos desde la comodidad de la aplicación de mensajería Telegram.

- Ejecución de comandos remotos: Permite ejecutar comandos en hosts remotos a través de SSH, lo que facilita la administración y el control de múltiples servidores desde un único punto de acceso.
  
- Seguridad: El bot incluye una lista de comandos prohibidos para evitar la ejecución de acciones peligrosas. Además, solo acepta comandos de usuarios autorizados mediante su chat ID en Telegram.
  
- Gestión de hosts: Los hosts disponibles para ejecución remota se gestionan mediante un archivo de texto, lo que permite una fácil configuración y ampliación del conjunto de hosts.

## Instrucciones de Uso

Puedes interactuar con el bot enviando mensajes desde Telegram con los siguientes comandos:

- `/ayuda`: Muestra la lista de comandos disponibles.
- `/ejecutar [comando]`: Ejecuta el comando especificado en el servidor local.
- `/ejecutar_host [host] [comando]`: Ejecuta el comando especificado en un host específico.

## Requisitos

- Bash (compatible con sistemas Unix/Linux).
- Acceso a Internet para recibir y enviar mensajes desde Telegram.
- SSH configurado en los hosts remotos para ejecutar comandos de forma remota.
