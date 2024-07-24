#!/usr/bin/env bash

# Inicia un escaneo de SSIDs disponibles
nmcli dev wifi rescan

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CAMPOS=SSID,SECURITY
POSICION=3
YOFF=25
XOFF=-5
FUENTE="JetBrains 10"

if [ -r "$DIR/config" ]; then
    source "$DIR/config"
elif [ -r "$HOME/.config/rofi/applets/bin/wifi-menu" ]; then
    source "$HOME/.config/rofi/wifi"
else
    echo "ADVERTENCIA: ¡archivo de configuración no encontrado! Usando valores predeterminados."
fi

LISTA=$(nmcli --fields "$CAMPOS" device wifi list | sed '/^--/d')
ANCHO=$(($(echo "$LISTA" | head -n 1 | awk '{print length($0); }')+10))
NUM_LINEAS=$(echo "$LISTA" | wc -l)
CONOCIDAS=$(nmcli connection show)
ESTADO_CON=$(nmcli -fields WIFI g)

SSID_ACTUAL=$(LANGUAGE=C nmcli -t -f active,ssid dev wifi | awk -F: '$1 ~ /^yes/ {print $2}')

if [[ ! -z $SSID_ACTUAL ]]; then
    LINEA_ALTA=$(echo  "$(echo "$LISTA" | awk -F "[  ]{2,}" '{print $1}' | grep -Fxn -m 1 "$SSID_ACTUAL" | awk -F ":" '{print $1}') + 1" | bc )
fi

if [ "$NUM_LINEAS" -gt 8 ] && [[ "$ESTADO_CON" =~ "enabled" ]]; then
    NUM_LINEAS=8
elif [[ "$ESTADO_CON" =~ "disabled" ]]; then
    NUM_LINEAS=1
fi

if [[ "$ESTADO_CON" =~ "enabled" ]]; entonces
    CAMBIO="desactivar"
elif [[ "$ESTADO_CON" =~ "disabled" ]]; entonces
    CAMBIO="activar"
fi

SELECCION=$(echo -e "$CAMBIO\nmanual\n$LISTA" | uniq -u | rofi -dmenu -p "SSID Wi-Fi: " -lines "$NUM_LINEAS" -a "$LINEA_ALTA" -location "$POSICION" -yoffset "$YOFF" -xoffset "$XOFF" -font "$FUENTE" -width -"$ANCHO")
SSID=$(echo "$SELECCION" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $1}')

if [ "$SELECCION" = "manual" ] ; entonces
    MANUAL=$(echo "ingrese el SSID de la red (SSID,contraseña)" | rofi -dmenu -p "Entrada Manual: " -font "$FUENTE" -lines 1)
    PASS=$(echo "$MANUAL" | awk -F "," '{print $2}')

    if [ "$PASS" = "" ]; entonces
        nmcli dev wifi con "$MANUAL"
    else
        nmcli dev wifi con "$MANUAL" password "$PASS"
    fi

elif [ "$SELECCION" = "activar" ]; entonces
    nmcli radio wifi on

elif [ "$SELECCION" = "desactivar" ]; entonces
    nmcli radio wifi off

else

    if [ "$SSID" = "*" ]; entonces
        SSID=$(echo "$SELECCION" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $3}')
    fi

    if [[ $(echo "$CONOCIDAS" | grep "$SSID") = "$SSID" ]]; entonces
        nmcli con up "$SSID"
    else
        if [[ "$SELECCION" =~ "WPA2" ]] || [[ "$SELECCION" =~ "WEP" ]]; entonces
            WIFIPASS=$(echo "si la conexión está guardada, presione enter" | rofi -dmenu -p "contraseña: " -lines 1 -font "$FUENTE" )
        fi
        nmcli dev wifi con "$SSID" password "$WIFIPASS"
   

