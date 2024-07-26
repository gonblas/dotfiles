#!/bin/bash

# Verifica el estado actual de dunst
current_state=$(dunstctl is-paused)

if [ "$1" == "1" ]; then
  # Click izquierdo - Alternar estado de las notificaciones
  if [ "$current_state" = "false" ]; then
    dunstctl set-paused true
  else
    dunstctl set-paused false
  fi
fi

# Obtiene el estado actual después del clic
current_state=$(dunstctl is-paused)

# Muestra el ícono adecuado basado en el estado
if [ "$current_state" = "true" ]; then
  echo "󰂛"  # Ícono para notificaciones pausadas
else
  echo "󰂚"  # Ícono para notificaciones activas
fi

