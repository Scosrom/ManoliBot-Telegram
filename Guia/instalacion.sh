#!/bin/bash

# Verificar si Git está instalado y, si no, instalarlo
if ! command -v git &> /dev/null; then
    echo "Git no está instalado. Instalando Git..."
    sudo apt update
    sudo apt install git -y
fi

# Instalar curl
sudo apt install curl -y
# Clonar el repositorio de ManoliBot desde GitHub
echo "Clonando el repositorio de ManoliBot desde GitHub..."
git clone https://github.com/Scosrom/ManoliBot-Telegram.git /tmp/ManoliBot

# Mover el directorio clonado a /opt
echo "Moviendo el directorio de ManoliBot a /opt..."
sudo mv /tmp/ManoliBot/ManoliBot /opt

# Solicitar al usuario que introduzca el token de Telegram
read -p "Introduce tu token de Telegram: " TELEGRAM_TOKEN

# Solicitar al usuario que introduzca su ID de chat de Telegram
read -p "Introduce tu ID de chat de Telegram: " CHAT_ID

# Modificar el script ManoliBot-1.0.sh con los valores proporcionados por el usuario
echo "Configurando el script de ManoliBot..."
sed -i "s/Escribe-tu-token/$TELEGRAM_TOKEN/" /opt/ManoliBot/ManoliBot-1.0.sh
sed -i "s/Escribe-tu-chat-id/$CHAT_ID/" /opt/ManoliBot/ManoliBot-1.0.sh

# Otorgar permisos a los archivos y directorios necesarios
echo "Otorgando permisos..."
sudo chmod 777 /opt/ManoliBot/ManoliBot-1.0.sh
sudo chmod 777 /opt/ManoliBot/inf/MensajesManoli.txt
sudo chmod 777 /opt/ManoliBot/control/forbidden_commands.txt
sudo chmod 777 /opt/ManoliBot/hosts/hosts.txt
sudo chmod 777 /opt/ManoliBot/adm/allowed_chat_ids.txt

# Crear el servicio systemd para ManoliBot
echo "Creando el servicio systemd para ManoliBot..."
cat <<EOF | sudo tee /etc/systemd/system/manoli-bot.service > /dev/null
[Unit]
Description=ManoliBot es una persona maravillosa y vamos a salir a decirselo. 

[Service]
Type=simple
User=root
ExecStart=/opt/ManoliBot/ManoliBot-1.0.sh
RestartSec=5

[Install]
WantedBy=default.target
EOF

# Habilitar y arrancar el servicio
#sudo systemctl enable manoli-bot
sudo systemctl daemon-reload
sudo systemctl start manoli-bot

# Notificar la finalización de la instalación
echo "La instalación de ManoliBot se ha completado correctamente."
echo "Ahora puedes utilizar el Bot de Telegram."ra interactuar con tu servidor."
