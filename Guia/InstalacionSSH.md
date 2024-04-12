# Alertas sobre uso de ssh

```
mkdir /opt/ManoliBot/alertas
cd /opt/ManoliBot/alertas
```

Copiamos el siguiente script y lo pegamos en el archivo **/opt/ManoliBot/alertas/ssh-segure.sh**

```
#!/bin/bash

# Token del bot de Telegram
TELEGRAM_TOKEN="7142938203:AAFbEEpR7eSYMr6tNoDsGd_rz1r6mmFnTAs"
# ID del chat de Telegram
CHAT_ID="6485900541"

# Ruta al archivo temporal
TMP_FILE="/opt/ManoliBot/tmp.txt"
# Ruta al archivo de registro de autenticación
AUTH_LOG="/var/log/auth.log"

# Función para enviar mensajes de Telegram
send_message() {
    local message="$1"
    # Envia el mensaje utilizando cURL a la API de Telegram
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" -d "chat_id=${CHAT_ID}&text=${message}"
}

# Comprueba si el archivo de registro existe
if [ -f "$AUTH_LOG" ]; then

    # Obtiene la última línea procesada
    if [ -f "$TMP_FILE" ]; then
        last_line=$(tail -n 1 "$TMP_FILE")
    else
        last_line=""
    fi

    # Extrae las nuevas líneas que cumplan ambas condiciones del archivo de registro
    new_lines=$(grep -E "sshd.*Accepted|sshd.*Disconnected" "$AUTH_LOG" | grep "sshd" | awk -v last="$last_line" '$0 > last')

    # Verifica si hay nuevas líneas para procesar
    if [ -n "$new_lines" ]; then
        # Itera sobre las nuevas líneas
        while IFS= read -r line; do
            # Comprueba si la línea ya ha sido procesada
            if ! grep -Fxq "$line" "$TMP_FILE"; then
                # Construye el mensaje
                ip_address=$(echo "$line" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
                time=$(echo "$line" | awk '{print $1" "$2" "$3}')
                if [[ "$line" == *"Accepted"* ]]; then
                    message="Se ha iniciado una sesión SSH desde la dirección IP: ${ip_address} a las ${time}"
                elif [[ "$line" == *"Disconnected"* ]]; then
                    message="Se ha cerrado una sesión SSH desde la dirección IP: ${ip_address} a las ${time}"
                fi
                # Envía el mensaje
                send_message "$message"
                # Almacena la línea en el archivo temporal
                echo "$line" >> "$TMP_FILE"  # Cambiado de '>' a '>>' para agregar líneas al archivo temporal
            fi
        done <<< "$new_lines"  # Cambiado para iterar sobre nuevas líneas
    fi

else
    echo "Error: $AUTH_LOG no existe." >&2  # Redirigido a stderr
fi
```

Le damos los permisos necesarios y lo añadimos a una tarea en cron. 

