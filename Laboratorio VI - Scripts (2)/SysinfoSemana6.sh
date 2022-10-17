#!/bin/bash

# Alummno: Cheuk Kelly Ng Pante
# Correo Institucional: alu0101364544@ull.edu.es
# Asignatura: Sistemas Operativos
# Entregable: Semana 6 Sysinfo

# sysinfo - Un script que informa del estado del sistema

##### Constantes
TITLE="Información del sistema para $HOSTNAME"
RIGHT_NOW=$(date +"%x %r%Z")
TIME_STAMP="Actualizada el $RIGHT_NOW por $USER"
PROGNAME=$(basename $0)
WHOAMI=$(whoami)

##### Variables
opcion=
opcion2=
filename=
interactive=

##### Estilos
TEXT_BOLD=$(tput bold)
TEXT_GREEN=$(tput setaf 2)
TEXT_RESET=$(tput sgr0)
TEXT_ULINE=$(tput sgr 0 1)
TEXT_RED=$(tput setaf 1)
TEXT_YELLOW=$(tput setaf 3)
TEXT_BLUE_CYAN=$(tput setaf 6)
TEXT_PURPLE=$(tput setaf 5)

##### Funciones
error_exit()
{
  echo "${PROGNAME}: ${1:-"Error desconocido"}" 1>&2
  exit 1
}

usage()
{
  echo "${TEXT_BOLD}${TEXT_RED}usage: sysinfo [-f file_name] [-i] [-h]${TEXT_RESET}"
  echo [-f file_name]: poner nombre del fichero de salida de la informacion del sistema
  echo [-i]: modo interactivo del script 
}

system_info()
{
  echo "${TEXT_ULINE}${TEXT_BOLD}${TEXT_YELLOW}Versión del sistema${TEXT_RESET}"
  uname -a
  echo
}

show_uptime()
{
  echo "${TEXT_ULINE}${TEXT_BOLD}${TEXT_YELLOW}Tiempo de encendido del sistema${TEXT_RESET}"
  uptime
  echo 
}

drive_space()
{
  echo "${TEXT_ULINE}${TEXT_BOLD}${TEXT_YELLOW}Espacio en el sistema de archivos${TEXT_RESET}"
  df -h
  echo
}

home_space()
{
  #Solo el superusuario puede obtener esta informacion
  echo "${TEXT_ULINE}${TEXT_BOLD}${TEXT_YELLOW}Espacio en home por usuarios del sistema${TEXT_RESET}"
  printf "%s\t" "Usado" "Directorio"
  echo
  if [ "$WHOAMI" == "root" ]; then
    printf "%s" "$(du -s /home/* | sort -nr | tr '/' ' ' | awk '{ print $1 "\t" $3 }')"  # Al ejecutar este comando como usuario root no aparecen todos los directorios /home
                                                                                         # Pero si se ejecuta el programa como sudo si aparecen todos los directorios /home
  elif [ "$USER" == "$USER" ]; then
    printf "%s" "$(du -s /home/$USER | tr '/' ' ' | awk '{ print $1 "\t" $3 }')"
  fi
}

interactive()
{
  echo "${TEXT_BOLD}${TEXT_BLUE_CYAN}Mostrar el informe del sistema en pantalla (S/N): ${TEXT_RESET}"
  read opcion
  echo
  # Se podria hacer con un case, pero preferí hacerlo con un if por si el usuario introduce las opciones en MAYUSCULA o minuscula
  if [ $opcion == "S" ] || [ $opcion == "s" ]; then
    write_page
    exit 0
  elif [ $opcion == "N" ] || [ $opcion == "n" ]; then
    echo "${TEXT_BOLD}${TEXT_BLUE_CYAN}Introduzca el nombre del archivo [~/sysinfo.txt]: ${TEXT_RESET}"
    read filename

    if [ "$filename" == "" ]; then
      filename=~/sysinfo.txt
      write_page > $filename
    else
      write_page > $filename
    fi

    # El script comprobara si el archivo donde guardar el informe ya exite. Si ya existe,
    # preguntará al usuario si desea sobreescribirlo
    if [ -f $filename ]; then
      echo "${TEXT_BOLD}${TEXT_BLUE_CYAN}El archivo de destino existe. ¿Sobreescribir? (S/N)${TEXT_RESET}"
      read opcion2
      if [ "$opcion2" == "S" ] || [ "$opcion2" == "s" ]; then
        write_page > $filename
        exit 0
      elif [ "$opcion2" == "N" ] || [ "$opcion2" == "n" ]; then
        echo "No se va sobreescribir el fichero..."
        exit 0
      else
        error_exit "Opción introducida no disponible"
      fi
    else
      echo "No existe, lo creamos: "
      write_page > $filename
    fi

  else
    error_exit "${TEXT_BOLD}${TEXT_RED}Opción introducida no disponible${TEXT_RESET}"
  fi
}

##### Programa principal
write_page()
{
cat << _EOF_
$TEXT_BOLD$TEXT_PURPLE$TITLE$TEXT_RESET
$(system_info)

$(show_uptime)

$(drive_space)

$(home_space)

$TEXT_GREEN$TIME_STAMP$TEXT_RESET

_EOF_
}

#Procesar la línea de comandos del script para leer las opciones
if [ "$1" == "" ]; then
  echo "${TEXT_BOLD}${TEXT_RED}Escribiendo la información del sistema en ~/sysinfo.txt${TEXT_RESET}"
  filename=~/sysinfo.txt
  write_page > $filename
  exit 0
fi

while [ "$1" != "" ]; do
  case $1 in
    -f | --file )
      shift
      if [ "$1" == "" ]; then
        error_exit "${TEXT_BOLD}${TEXT_RED}Introduzca un nombre de fichero${TEXT_RESET}"
      else
        filename=$1
        write_page > $filename
      fi
      ;;
    -i | --interactive )
      interactive=1
      ;;
    -h | --help )
      usage
      exit 0
      ;;
    * )
      usage
      echo
      error_exit "${TEXT_BOLD}${TEXT_RED}La opción introducida no está disponible${TEXT_RESET}"
      exit 1
  esac
  shift
done

if [ "$interactive" == 1 ]; then
  interactive
fi