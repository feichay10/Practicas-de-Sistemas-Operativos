#!/bin/bash

ALLUSERS=$(ps --no-headers -eo user --sort=user | uniq)
INVERTUSERS=$(ps --no-headers -eo user --sort=-user | uniq)
ONUSERS=$(who | cut -d : -f 1)

opt=
users=
mem=
result=

main() 
{
  echo "A continuacion se mostraran los datos de cada usuario en concreto la suma de los porcentajes de memoria usados"

  for var in $users; do
    echo
    echo "Usuario: $var"
    echo "UID: $(id -u $var)"
    echo "GID: $(id -g $var)"
    mem=$(ps --no-headers -u $var -eo %mem,user | grep $var | awk '{print $1}')
    result=0.0
    for i in $mem; do
      result=$(echo "$result + $i" | bc)
    done
    echo "% Memoria: $result"
    echo
  done
}

usage()
{
  echo "Error: ${1:-"Error desconocido"}" 1>&2
  exit 1
}



if [ "$1" = "" ]; then
  opt=$1
  users=$ALLUSERS
  echo "Opcion seleccionada: Usuarios ordenados"
  main
fi

while [ "$1" != "" ]; do
  case $1 in
    -inv )
      opt=$1
      users=$INVERTUSERS
      echo "Opcion seleccionada: Usuarios invertidos"
    ;;
    -nodaemon )
      opt=$1
      users=$ONUSERS
      echo "Opcion seleccionada: Usuarios nodaemon"
    ;;
    * )
      opt=$1
      echo "ERROR, no se han especificado los parametros correctamente"
      usage
    ;;
  esac
  main
  shift
done