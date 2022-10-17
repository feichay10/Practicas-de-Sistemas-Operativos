#!/bin/bash
# Alummno: Cheuk Kelly Ng Pante
# Correo Institucional: alu0101364544@ull.edu.es
# Asignatura: Sistemas Operativos
# Practica Semana 4
# Tema: Laboratorio IV - Expansión
# Entregable: Semana 4, Entregable de practica presencial

#Pista: ls | grep -e "KK.."

#Cuente los directorios y los softlinks que hay dentro de mi directorio actual que 
# tenga activado el permiso de ejecución del usuario y el de "otros"

#Directorios:
ls -l | grep ^d | cut -f 1 -d " " | tr "r" " " | tr "w" " " | awk '{ print $2 }' | grep "x$" | wc -l

#Softlinks:
ls -l | grep ^l | cut -f 1 -d " " | tr "r" " " | tr "w" " " | awk '{ print $2 }' | grep "x$" | wc -l
