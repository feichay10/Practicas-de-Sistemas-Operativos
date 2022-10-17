#!/bin/bash

## Constante
PROGNAME=$(basename $0)

## Variables
pides=$(ps --no-header -o pid)

## Funciones
# Funcion que devuelve un error
error_exit()
{
  echo "${PROGNAME}: ${1:-"Error desconocido"}" 1>&2 # Imprimimos $1 si existe o si no, el texto indicado, el echo imprime por la salida de error
  exit 1
}

# Función que contiene la cabecerá del comando.
header()
{
  #printf "user\t egroup\t    uid\t   pid\t  time\t  etimes\n"
  printf "$(ps -o user,egroup,uid,pid,time,etimes | head -n 1 )\n"
}

# Función que muestra como se usa el scrip.
usage(){
  echo "Opciones:
  -t N
  -killusr M
  -sortUsuario 
  -R -sortUsuario"
}

# Función que ejecuta el comando con las variables dadas.
cuerpo()
{
  for i in $(echo $pides); do
    for j in $(echo ps -p $i -o etimes | awk '{printf("%i\n", $1/60)}'); do
      if [ $k -ge "$j" ]; then
        printf "$(ps --no-header -p $i -o user,egroup,uid,pid,time,etimes | sort -k 4)\n"
      fi
    done
  done
}

# Función que mata un proceso si pasa un cierto tiempo.
kill_ps()
{
  for i in $(echo $pides); do
    for j in $(echo ps -p $i-o etimes | awk '{printf("%i\n", $1/60)}'); do
      if [ $k -ge "$j" ]; then
        printf "$(kill $i)"
      fi
    done
  done
}

## Principal
case $1 in
  -t)
    case $2 in
      "")
        k="1"
        header
        cuerpo
      ;;

      *)
        k=$2
        header
        cuerpo
      ;;

    esac
  ;;

  -Killusr)
    case $2 in
      *)
        kill_ps
      ;;

      "")
        error_exit "Error. Faltan argumentos. Prueba con '$0 -h | --help'.\n"
      ;;
    esac
  ;;

  -R)
    case $2 in 
      -sortUsuario)
        case $3 in
          *)
            k=$3
            header
            cuerpo
          ;;

          "")
            error_exit "Error. Faltan argumentos. Prueba con $0 '-h | --help'.\n"
          ;;
          
        esac
      ;;
      
      "")
        error_exit "Error. Faltan argumentos. Prueba con $0 '-h | --help'.\n"
      ;;
    esac
  ;;

  -sortUsuario)
    case $2 in
      *)
        k=$2
        header
        cuerpo
      ;;

      "") 
       error_exit "Error. Faltan argumentos. Prueba con $0 '-h | --help'.\n"
      ;;
    esac
  ;;

  -h | --help )
    case $2 in
      "" )
        usage
      ;;

      * )
        error_exit "Opcion desconocida utilice $0 '-h | --help'.\n"
      ;;
    esac
  ;;

  -*)
    error_exit "Opcion desconocida utilice $0 '-h | --help'.\n"
  ;;
  
  "")
    error_exit "Faltan algurmentos. Utilice $0' -h | --help'.\n"
  ;;

esac
