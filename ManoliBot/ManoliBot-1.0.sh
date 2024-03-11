#!/bin/bash

# Reemplaza 'Escribe-tu-token' con tu token
TELEGRAM_TOKEN="Escribe-tu-token"

# Reemplaza 'Escribe-tu-chat-id' con tu chat ID
CHAT_ID="Escribe-tu-chat-id"

# Nombre del archivo donde se guardarán los mensajes
mensaje_file="/opt/ManoliBot/inf/MensajesManoli.txt"

# Ruta del archivo que contiene los comandos prohibidos
forbidden_commands_file="/opt/ManoliBot/control/forbidden_commands.txt"

# Función para enviar mensajes de respuesta
send_message() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" -d "chat_id=${CHAT_ID}&text=${message}"
}

# Función para ejecutar comandos y enviar el resultado como mensaje
execute_command() {
    local command="$1"
    local result

    # Verificar si el comando está en la lista de comandos prohibidos
    if grep -Fxq "$command" "$forbidden_commands_file"; then
        send_message "El comando '$command' está prohibido y no se puede ejecutar."
    else
        result=$(eval "$command" 2>&1)
        send_message "Resultado de ejecución del comando: $result"
    fi
}

# Función para ejecutar comandos en hosts específicos y enviar el resultado como mensaje
execute_command_on_host() {
    local host="$1"
    local command="$2"
    local result

    # Verificar si el host está en la lista de hosts disponibles
    if grep -Fxq "$host" "/opt/ManoliBot/hosts.txt"; then
        result=$(ssh "$host" "$command" 2>&1)
        send_message "Resultado de ejecución del comando '$command' en $host: $result"
    else
        send_message "El host '$host' no está disponible. Por favor, elige uno de los siguientes hosts."
    fi
}

# Obtener el último ID de actualización procesado
get_last_update_id() {
    if [[ -f last_update_id.txt ]]; then
        cat last_update_id.txt
    else
        echo 0
    fi
}

# Guardar el último ID de actualización procesado y limpiar el archivo
save_last_update_id() {
    local update_id="$1"
    echo "$update_id" > last_update_id.txt
}

# Leer los mensajes entrantes del bot de Telegram
while true; do
    # Obtener el último ID de actualización procesado
    last_update_id=$(get_last_update_id)

    # Obtener las actualizaciones desde el último ID de actualización procesado
    updates=$(curl -s "https://api.telegram.org/bot${TELEGRAM_TOKEN}/getUpdates?offset=$((last_update_id + 1))")

    # Verificar si hay mensajes nuevos
    if [[ $(jq '.result | length' <<< "$updates") -gt 0 ]]; then
        # Leer cada mensaje nuevo
        jq -c '.result[]' <<< "$updates" | while read -r update; do
            # Obtener el tipo del mensaje
            type=$(jq -r '.message.chat.type' <<< "$update")

            # Verificar si es un mensaje de chat y no una actualización de entrega
            if [[ "$type" == "private" ]]; then
                # Obtener el texto del mensaje
                text=$(jq -r '.message.text' <<< "$update")

                # Guardar el mensaje en el archivo
                echo "$text" >> "$mensaje_file"

                # Procesar el comando recibido
                case "$text" in
                    "/start")
                        send_message "¡Hola! Soy un bot de Telegram. Puedes enviarme comandos para ejecutar en el servidor."
                        ;;
                    "/ayuda")
                        send_message "Lista de comandos disponibles:
/ayuda - Muestra la ayuda
/ejecutar - Ejecutar [comando] en el servidor local
/ejecutar_host [host] [comando] - Ejecutar [comando] en un host específico
/start - Empezar a ejecutar comandos"
                        ;;
                    # Comando para ejecutar comandos en el servidor local
                    "/ejecutar "*)
                        command_to_execute="${text#/ejecutar }"
                        execute_command "$command_to_execute"
                        ;;
                    # Comando para ejecutar comandos en hosts específicos
                    "/ejecutar_host "*)
                        command_to_execute="${text#/ejecutar_host }"
                        host=$(echo "$command_to_execute" | awk '{print $1}')
                        command=$(echo "$command_to_execute" | cut -d' ' -f2-)
                        execute_command_on_host "$host" "$command"
                        ;;
                    *)
                        # No enviar mensaje de ayuda por defecto
                        ;;
                esac
            fi
        done

        # Guardar el ID de la última actualización procesada
        last_processed_update_id=$(jq -r '.result[-1].update_id' <<< "$updates")
        save_last_update_id "$last_processed_update_id"
    fi

    # Esperar antes de verificar nuevas actualizaciones
    sleep 1
done
