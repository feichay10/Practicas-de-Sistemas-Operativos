# Alummno: Cheuk Kelly Ng Pante
# Correo Institucional: alu0101364544@ull.edu.es
# Asignatura: Sistemas Operativos
# Tema: Laboratorio III - Redirecciones de Entrada/Salida y Control de Trabajo
# Entregable: Semana 3, Entregable sobre Redirecciones y Control de Trabajo

#!/bin/bash

# === Estilos ===
TEXT_BOLD=$(tput bold)
TEXT_RESET=$(tput sgr0)
TEXT_YELLOW=$(tput setaf 3)

# 1. Contar el número de procesos en nuestra sesión que están ejecutandose en segundo plano
echo -e "${TEXT_YELLOW}${TEXT_BOLD}1. Contar el número de procesos en nuestra sesión que están ejecutandose en segundo plano: "${TEXT_RESET}
jobs | awk '{ print $4 }' | grep "&" | wc -l  
echo

# 2. Contar el numero de procesos que están en estado detenidos entre los de nuestra sesión
echo -e "${TEXT_YELLOW}${TEXT_BOLD}2. Contar el número de procesos que están en estado detenidos entre los de nuestra sesión: "${TEXT_RESET}
jobs -s | wc -l   
echo

# 3. Mostrar el nombre de los procesos que se están ejecutando en segundo plano
echo -e "${TEXT_YELLOW}${TEXT_BOLD}3. Mostrar el nombre de los procesos que se están ejecutando en segundo plano "${TEXT_RESET}
jobs -r | grep "&" | awk '{ print $3 }'
echo

# 4. Contar el numero total de procesos que estamos ejecutando
echo -e "${TEXT_YELLOW}${TEXT_BOLD}4. Contar el número total de procesos que estamos ejecutando: "${TEXT_RESET}
ps --no-headers ux | wc -l
echo

# 5. Sacar un listado de todos los directorios que hay en nuestro directorio actual.
echo -e "${TEXT_YELLOW}${TEXT_BOLD}5. Sacar un listado de todos los directorios que hay en nuestro directorio actual: "${TEXT_RESET}
ls -la | grep ^d
echo

# 6. Contar el numero de programas alojados en nuestro directorio actual donde el grupo "otros" tiene permisos de ejecución.
echo -e "${TEXT_YELLOW}${TEXT_BOLD}6. Contar el numero de programas alojados en nuestro directorio actual: "${TEXT_RESET}
ls -la | grep ^- | cut -f 1 -d " " | grep "x$" | wc -l    #Suponemos que "programas" se refiere a ficheros regulares con los permisos de ejecución activados para "otros"