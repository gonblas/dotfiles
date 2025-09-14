#!/bin/sh

# Verificar estado y mostrar icono
if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "yes"; then
    echo "󰍭"   # Micrófono muteado
else
    echo "󰍬"   # Micrófono activo
fi

