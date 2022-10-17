#!/bin/bash

# === Constantes ===
PROGNAME=$(basename $0)


# === Variables ===
usuarios_conectados=$(ps --no-headers -Ao user | sort | uniq)
parametro2=""
parametro3=""
usuario=""

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
  echo "usage: ./Enero2020-2021.sh [-s N "" | k | m]"
}

listado_archivos()
{
  echo "listado archivos"
  if [ "$parametro2" != "" ]; then
    echo "con parametro"
    if [ "$parametro3" != "" ]; then
      case $parametro3 in
        k )
          for i in $usuarios_conectados; do
            echo "Archivos en kilobytes de $i"
            find / -user $i -size $parametro2$parametro3 
            echo
          done
          exit
          ;;
        m )
          echo "Archivos en megabytes de $i"
            find / -user $i -size $parametro2$parametro3 
            echo
          exit
          ;;
        * )
          exit
        esac
      else 
        parametro3="c"
        for i in $usuarios_conectados; do
          echo "Archivos en bytes de $i"
          #echo "$parametro3"
            find / -user $i -size $parametro2 
            echo
          echo $i
        done
      fi
  else  
    for i in $usuarios_conectados; do
      echo $i
      find / -user $i -size 2k 
    done
  fi
}

procesos()
{
  echo "=== Listado de procesos ==="
  ps -u $usuario
}


# === Menu de opciones ===
if [ "$1" == "" ]; then 
  usage
  error_exit "Introduzca un parametro"
else
  while [ "$1" != "" ]; do
    case $1 in
      -h | --help)
        usage
        exit
        ;;
      -s )
        parametro2=$2
        parametro3=$3
        listado_archivos
        exit
        ;;
      -usr )
        usuario=$2
        procesos
        exit
        ;;
      -grp )
        
        exit
        ;;
      * )
        usage
        error_exit "El parametro introducido no está disponible"
        exit
      esac
      shift
  done
fi
