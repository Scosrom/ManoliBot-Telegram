# ManoliBot-Telegram

![ManoliBot](/Guia/img/ManoliBot.jepg)

ManoliBot es un bot de Telegram programado en Bash diseñado para simplificar la gestión y control de servidores a través de la ejecución remota de comandos. Al integrarse con la plataforma de mensajería Telegram, ManoliBot proporciona una interfaz accesible y fácil de usar que permite a los usuarios enviar comandos y recibir resultados de forma rápida y conveniente.

## Características

**- Interfaz de Telegram:** ManoliBot se integra con Telegram, lo que permite a los usuarios enviar comandos desde la comodidad de la aplicación de mensajería Telegram.

**- Ejecución de comandos remotos:** Permite ejecutar comandos en hosts remotos a través de SSH, lo que facilita la administración y el control de múltiples servidores desde un único punto de acceso.
  
**- Seguridad:** El bot incluye una lista de comandos prohibidos para evitar la ejecución de acciones peligrosas. Además, solo acepta comandos de usuarios autorizados mediante su chat ID en Telegram.
  
**- Gestión de hosts:** Los hosts disponibles para ejecución remota se gestionan mediante un archivo de texto, lo que permite una fácil configuración y ampliación del conjunto de hosts.

## Instrucciones de Uso

Puedes interactuar con el bot enviando mensajes desde Telegram con los siguientes comandos:

- `/ayuda`: Muestra la lista de comandos disponibles.
- `/ejecutar [comando]`: Ejecuta el comando especificado en el servidor local.
- `/ejecutar_host [host] [comando]`: Ejecuta el comando especificado en un host específico.

## Requisitos

- Bash (compatible con sistemas Unix/Linux).
- Acceso a Internet para recibir y enviar mensajes desde Telegram.
- SSH configurado en los hosts remotos para ejecutar comandos de forma remota.


## Instalación:

- [Crear un bot de Telegram](Guia/crearbot.md)
- [Instalación ManoliBot](Guia/instalacion.md)
- [Configuración](Guia/configuracion.md)

## DLC


Los DLC son extensiones independientes diseñadas para complementar y ampliar las funcionalidades de ManoliBot en la gestión y control de servidores a través de Telegram. Pueden ser instalados y utilizados de manera autónoma, sin necesidad de depender del bot principal.

Cada DLC proporciona características adicionales específicas, permitiendo a los usuarios personalizar y adaptar el bot según sus necesidades y requisitos particulares de administración de servidores.

- [Alertas con Suricata](https://github.com/Scosrom/Suricata-Telegram)

## Licencia

<p align="center">
  <img src="/Guia/img/88x31.png" alt="licencia">
</p>

