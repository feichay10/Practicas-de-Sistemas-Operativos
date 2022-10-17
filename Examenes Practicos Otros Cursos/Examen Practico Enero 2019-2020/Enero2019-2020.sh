#!/bin/bash

# === Parametros y constantes ===
PROGNAME=$(basename $0)
LISTADO_PROCESOS=$(ps --no-headers -eo etimes --sort=-etimes)
tiempo=""

# === Estilos ===
TEXT_BOLD=$(tput bold)
TEXT_RESET=$(tput sgr0)
TEXT_RED=$(tput setaf 1)


# === Funciones ===
#Funcion de error exit
error_exit()
{   
  echo "${PROGNAME}: ${1:-"Error desconocido"}" 1>&2        
  exit 1
}

#Función que saca un mensaje de como se usa el script
usage()
{
  echo "usage: ./Enero2019-2020.sh [-t N | -killusr M]"
}

#ps --no-headers -Ao comm,times --sort=-times | awk '{print $2}' | head -n 30
cabecera()
{
  printf
}

uno=1
tiempo_cpu()
{
  echo "  PID COMMAND         GROUP       TIME"
  for i in $LISTADO_PROCESOS; do
    if [ "$i" -gt "$tiempo" ]; then
      echo "$(ps -eo pid,comm,group,etimes | grep $i | uniq)"
    fi
  done
}

# === Menu Principal ===
if [ "$1" == "" ]; then
  echo "Introduzca alguna opcíon"
  usage
else
  while [ "$1" != "" ]; do
    case $1 in
      -t )
         shift
        if [ "$1" = "" ]; then
          tiempo=
        else
          tiempo=$1
        fi
        tiempo_cpu 
        ;;
      * )
        error_exit "La opción introducida no está disponible"
        exit 1
    esac
    shift
  done
fi
