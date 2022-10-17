#!/bin/bash

# Alummno: Cheuk Kelly Ng Pante
# Correo Institucional: alu0101364544@ull.edu.es
# Asignatura: Sistemas Operativos
# Practica Semana 4

# sysinfo - Un script que informa del estado del sistema
##### Constantes
TITLE="Información del sistema para $HOSTNAME"
RIGHT_NOW=$(date +"%x %r%Z")
TIME_STAMP="Actualizada el $RIGHT_NOW por $USER"

##### Estilos
TEXT_BOLD=$(tput bold)
TEXT_GREEN=$(tput setaf 2)
TEXT_RESET=$(tput sgr0)
TEXT_ULINE=$(tput sgr 0 1)

##### Funciones
system_info()
{
  echo "${TEXT_ULINE}Versión del sistema${TEXT_RESET}"
  uname -a
  echo
}

show_uptime()
{
  echo "${TEXT_ULINE}Tiempo de encendido del sistema${TEXT_RESET}"
  uptime
  echo 
}

drive_space()
{
  echo "${TEXT_ULINE}Espacio en el sistema de archivos${TEXT_RESET}"
  df -h
  echo
}

home_space()
{
  if [ "$USER" = "root" ]; then
    echo "${TEXT_ULINE}Espacio en home por usuarios del sistema${TEXT_RESET}"
    echo -e "Bytes \tDirectorio"
    du -s /home/* | sort -nr | tr '/' ' ' | awk '{ print $1 "\t" $3 }' # Al ejecutar este comando como usuario root no aparecen todos los directorios /home
                                                                       # Pero si se ejecuta el programa como sudo si aparecen todos los directorios /home
  elif [ "$USER" = "$USER" ]; then
    echo "${TEXT_ULINE}Espacio en home de $USER${TEXT_RESET}"
    echo -e "Bytes \tDirectorio"
    du -s /home/$USER | tr '/' ' ' | awk '{ print $1 "\t" $3 }'
  fi
}

##### Programa principal
cat << _EOF_
$TEXT_BOLD$TITLE$TEXT_RESET

$(system_info)

$(show_uptime)

$(drive_space)
  
$(home_space)

$TEXT_GREEN$TIME_STAMP$TEXT_RESET
_EOF_
