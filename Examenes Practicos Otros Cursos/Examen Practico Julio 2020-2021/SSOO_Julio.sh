#!/bin/bash

#variables
var=2
usuario=$(ps --no-headers -Ao user | sort | uniq)
grupo="0"
re='^[0-9]+$'

#funciones
error_exit()
{
	echo "${PROGNAME}: ${1:-"Error"}" 1>&2
	exit 1
}

usage()
{
    printf "\t\tMANUAL DE USO\n"
    printf "SYNOPSIS\n"
    printf "\t $0 [OPCIONES]\n\n"

    printf "DESCRIPCION\n"
    printf "\tMuestra la lista de todos‌ ‌los‌ ‌archivos‌ ‌de‌ ‌directorios‌ ‌y‌ ‌subdirectorios‌ ‌de‌ ‌los‌ ‌usuarios‌ ‌que‌‌ están‌‌ actualmente‌ ‌conectados‌ ‌en‌ ‌el‌ ‌sistema‌ ‌con‌ ‌un‌ ‌tamaño‌ ‌mayor‌ ‌que‌‌N \n"

    printf "OPCIONES\n"
    printf "\t[-s]       Permite al usuario elegir el tamaño N"
    printf "\t[-usr]     Permite establecer el usuario con el cual se muestra la lista"
    printf "\t[-grp]     Permite establecer el grupo con el cual se muestra la lista"
    printf "\t[-h]       Muestra esta ayuda\n"
}

Funcionamiento()
{
    if [[ grupo == "0" ]] ; then

        if [[ "$2" == "c" ]] ; then
            var=$1
            printf "\t[-h]       Muestra esta ayuda 1\n"
            ls -laS | awk '$5 > $var { print $0 }' | awk '$3 == "$usuario"'
        elif [[ "$2" == "k" ]] ; then
            var=$(($1 * 1024))
            printf "\t[-h]       Muestra esta ayuda 2\n"
            ls -laS | awk '$5 > $var { print $0 }' | awk '"$3" == "$usuario"'
        elif [[ "$2" == "m" ]] ; then
            var=$(($1 * 1048576))
            printf "\t[-h]       Muestra esta ayuda 3\n"76
            ls -laS | awk '$5 > $var { print $0 }' | awk '"$3" == "$usuario"'
        fi
    else
        if [[ "$2" == "c" ]] ; then
            var=$1
            printf "\t[-h]       Muestra esta ayuda 1\n"
            ls -laS |awk '$5 > $var { print $0 }'|awk '$4 == "$grupo"'
        elif [[ "$2" == "k" ]] ; then
            var=$(($1 * 1024))
            printf "\t[-h]       Muestra esta ayuda 2\n"
            ls -laS |awk '$5 > $var { print $0 }'|awk '$4 == "$grupo"'
        elif [[ "$2" == "m" ]] ; then
            var=$(($1 * 1048576))
            printf "\t[-h]       Muestra esta ayuda 3\n"
            ls -laS |awk '$5 > $var { print $0 }'|awk '$4 == "$grupo"'
        fi
    fi
}

#Main
if [ "$1" == "" ]; then
    Funcionamiento    
else   
    case $1 in

        -s )
            shift
            if ! [[ "$1" =~ $re ]] ; then
                error_exit
            else
                Funcionamiento $1 $2
            fi
            ;;
        -usr )
            shift
            usuario="$1"
            Funcionamiento
            ;;
        -grp )
            shift
            grupo="$1"
            Funcionamiento
            ;;
        * )
            usage
            error_exit
            ;;
    esac
fi