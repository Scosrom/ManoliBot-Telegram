#!/bin/bash

# Replace 'Escribe-tu-token' with your actual Telegram bot token
TELEGRAM_TOKEN="Escribe-tu-token"

# Replace 'Escribe-tu-chat-id' with your actual bot chat ID
BOT_CHAT_ID="Escribe-tu-chat-id"

# Nombre del archivo donde se guardarán los mensajes
mensaje_file="/opt/ManoliBot/inf/MensajesManoli.txt"

# Ruta del archivo que contiene los comandos prohibidos
forbidden_commands_file="/opt/ManoliBot/control/forbidden_commands.txt"

# Archivo que contiene los IDs de chat permitidos
allowed_chat_ids_file="/opt/ManoliBot/adm/allowed_chat_ids.txt"

# Archivo que contiene los hosts disponibles para ejecución remota
hosts_file="/opt/ManoliBot/hosts/hosts.txt"

# Función para enviar mensajes de respuesta
send_message() {
    local chat_id="$1"
    local message="$2"
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" -d "chat_id=${chat_id}&text=${message}"
}

# Función para verificar si el ID de chat está permitido
is_chat_id_allowed() {
    local chat_id_to_check="$1"
    grep -Fxq "$chat_id_to_check" "$allowed_chat_ids_file"
}

# Función para ejecutar comandos y enviar el resultado como mensaje
execute_command() {
    local chat_id="$1"
    local command="$2"
    local result

    # Verificar si el ID de chat está permitido
    if is_chat_id_allowed "$chat_id"; then
        # Verificar si el comando está en la lista de comandos prohibidos
        if grep -Fxq "$command" "$forbidden_commands_file"; then
            send_message "$chat_id" "El comando '$command' está prohibido y no se puede ejecutar."
        else
            result=$(eval "$command" 2>&1)
            send_message "$chat_id" "Resultado de ejecución del comando: $result"
        fi
    else
        send_message "$chat_id" "Lo siento, no tienes permiso para ejecutar comandos."
    fi
}

# Función para ejecutar comandos en hosts específicos
execute_command_on_host() {
    local host="$1"
    local command="$2"
    local result

    result=$(ssh "$host" "$command" 2>&1)
    send_message "$BOT_CHAT_ID" "Resultado de ejecución del comando en $host: $result"
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
            # Obtener el ID de chat del remitente
            chat_id=$(jq -r '.message.chat.id' <<< "$update")

            # Verificar si es un mensaje de chat y no una actualización de entrega
            if [[ "$type" == "private" ]]; then
                # Obtener el texto del mensaje
                text=$(jq -r '.message.text' <<< "$update")

                # Guardar el mensaje en el archivo junto con el ID del chat
                echo "ID de Chat: $chat_id" >> "$mensaje_file"
                echo "Mensaje: $text" >> "$mensaje_file"

                # Procesar el comando recibido
                case "$text" in
                    "/start")
                        if is_chat_id_allowed "$chat_id"; then
                            send_message "$chat_id" "¡Hola! Soy un bot de Telegram. Puedes enviarme comandos para ejecutar en el servidor."
                        else
                            send_message "$chat_id" "Lo siento, no tienes permiso para ejecutar el comando /start."
                        fi
                        ;;
                    "/ayuda")
                        send_message "$chat_id" "Lista de comandos disponibles:
/ayuda - Muestra la ayuda
/ejecutar - Ejecutar [comando] en el servidor local
/ejecutar_host [host] [comando] - Ejecutar [comando] en un host específico
/start - Empezar a ejecutar comandos"
                        ;;
                    # Comando para ejecutar comandos en el servidor local
                    "/ejecutar "*)
                        command_to_execute="${text#/ejecutar }"
                        execute_command "$chat_id" "$command_to_execute"
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
