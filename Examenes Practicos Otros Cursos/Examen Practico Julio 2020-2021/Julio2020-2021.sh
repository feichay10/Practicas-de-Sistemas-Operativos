#!/bin/bash

# === Parametros y constantes ===
usuarios_conectados=$(ps --no-headers -Ao user | sort | uniq)
parametro2=$2
parametro3=$3


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
  echo "usage: ./Julio2020-2021.sh [-s N "" | k | m]"
}

# Si queremos buscar algun archivo desde la / tenemos que cambiar el ~ por /
listado_archivos()
{
  if [ "$parametro2" == "" ]; then  #parametro2 = N
    for i in $usuarios_conectados; do
      echo "${TEXT_BOLD}${TEXT_RED}Archivos de directorios y subdirectorios de: $i${TEXT_RESET}"
      find . -user $i -type f -size 2k -exec ls -lh {} \;
      echo 
    done
  else
    if [ "$parametro3" == "" ]; then
      bytes="c"
      for i in $usuarios_conectados; do
        echo "${TEXT_BOLD}${TEXT_RED}Archivos de directorios y subdirectorios de: $i${TEXT_RESET}"
        find ~ -user $i -size $parametro2$bytes -exec ls -lh {} \;
      done
    else
      case $parametro3 in
        k )
          kilobytes="k"
          for i in $usuarios_conectados; do
            echo "${TEXT_BOLD}${TEXT_RED}Archivos de directorios y subdirectorios de: $i${TEXT_RESET}"
            find ~ -user $i -size $parametro2$kilobytes -exec ls -lh {} \;
          done
          ;;
        m )
          megabytes="M"
          for i in $usuarios_conectados; do
            echo "${TEXT_BOLD}${TEXT_RED}Archivos de directorios y subdirectorios de: $i${TEXT_RESET}"
            find ~ -user $i -size $parametro2$megabytes -exec ls -lh {} \;
          done
          ;;
        *)
          error_exit "El tamaño introducido no está disponible"
      esac
    fi
  fi
}

listado_usuarios()
{
  for i in $parametro2; do
    echo "Listado de procesos del usuario: $i"
    ps --user $i | head -n 10
    echo
  done
}

# === Menu de opciones ===
if [ "$1" == "" ]; then
  usage
  error_exit "Introduzca una opción"
else
  while [ "$1" != "" ]; do
    case $1 in
      -s )
        listado_archivos
        ;;
      -usr )
        if [ "$parametro2" == "" ]; then
          error_exit "No ha introducido los usuarios"
        else
          while [ "$parametro2" != "" ]; do
            listado_usuarios
            shift
          done
        fi
        ;;
      -grp )
        shift
        grupo="$1"
        listado_archivos
        ;;
      * )
        error_exit "La opción introducida no es válida"
    esac
    shift
  done
fi