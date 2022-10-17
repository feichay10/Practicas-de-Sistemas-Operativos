#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <iostream>

int main(int argc, char *argv[])
{

  if (argc == 0)
  {
    std::cout << "Introduzca algun parametro" << std::endl;
    return -1;
  }

  pid_t hijo = fork();

  if (hijo == 0) //Procesos hijo
  {
    std::cout << "Soy el proceso hijo" << std::endl;
    std::cout << "Voy a ejecutar el comando 'ps'" << std::endl;

    execl("/usr/bin/ps", "ps", argv[1], argv[2], NULL);

    fprintf(stderr, "Error (%d) al ejecutar el programa: %s\n", errno, strerror(errno));
    return -1;
  }
  else if (hijo > 0) //Proceso padre
  {
    std::cout << "Soy el proceso padre" << std::endl;
    std::cout << "Voy a esperar a que mi hijo termine...." << std::endl;

    int status;
    wait(&status);
    std::cout << "Padre: El valor de salida de mi hijo fue: " << WEXITSTATUS(status) << std::endl;

    return 0;
  }
  else
  {
    // Aquí solo entra el padre si no pudo crear el hijo
    fprintf(stderr, "Error (%d) al crear el proceso: %s\n", errno, strerror(errno));
    return 3;
  }
}
