#include <iostream>
#include <stdio.h>

#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>
#include <stdlib.h>

#define errExit(msg)    \
  do {                  \
    perror(msg);        \
    exit(EXIT_FAILURE); \
  } while (0)

static void sigintHandlerI(int sig) {
  printf("\nCaught signal SIGINT %d!\n", sig);
  printf("Exit success\n");
  exit(EXIT_SUCCESS);
}

static void sigintHandlerT(int sig) {
  printf("\nCaught signal SIGTERM %d!\n", sig);
  printf("Exit success\n");
  exit(EXIT_SUCCESS);
}

int main(int argc, char* argv[]) {

  pid_t c_pid = fork();
  // Error: devuelve menor que 0.
  // Proceso padre: devuelve mayor que 0.
  // Proceso hijo: devuelve 0.

  if (c_pid == 0) { // Aquí solo entra el proceso hijo
    std::cout << "[HIJO] ¡Soy el proceso hijo!" << std::endl;
    std::cout << "[HIJO] pid = " << getpid() << std::endl;
    //sleep(10);
    std::cout << "[HIJO] Voy a ejecutar el comando 'ps -u 'User''" << std::endl;
    //sleep(10);

    // Capturo señales
    if (signal(SIGINT, sigintHandlerI) == SIG_ERR)
      errExit("signal SIGINT");
    if (signal(SIGTERM, sigintHandlerT) == SIG_ERR){
      errExit("signal SIGTERM");
    }

    // Nombre del fichero a abrir.
    const char* file_name;
    if (argv[1] == NULL)
      file_name = "procesos.txt";
    else
      file_name = argv[1];
    std::cout << std::endl;
    std::cout << "File name: " << file_name <<std::endl; 
    
    // Nombre del usuario.
    std::string userName;
    if (argv[2] == NULL)
      userName = getenv("LOGNAME");
    else
      userName = argv[2];
    std::cout << "Username: " << userName << std::endl;
    std::cout << std::endl;

    // Comando a ejecutar.
    std::string str_command = "ps -o pid,user,cmd -u " + userName + " > " + file_name;
    const char* command = str_command.c_str();

    // Abro el fichero y compruebo.
    FILE* fichero = popen(command, "w");
    if (fichero == NULL)
      throw std::system_error (errno, std::system_category(), "No se pudo abrir el fichero.");
    else { 
      std::cout << "Fichero abierto correctamente." << std::endl;
      sleep(10);

      // Ejecuto el comando con execl.
      execl("/bin/sh","sh", "-c", command, (char *)0);

      // Cierro el fichero.
      pclose(fichero);

      fprintf(stderr, "Error (%d) al ejecutar el programa: %s\n", errno, strerror(errno) );
    return -1;
    }
  }
  else if (c_pid > 0) {
    std::cout << "[PADRE] ¡Soy el proceso padre!" << std::endl;
    std::cout << "[PADRE] pid = " << getpid() << std::endl;

    // Capturo señales
    if (signal(SIGINT, sigintHandlerI) == SIG_ERR)
      errExit("signal SIGINT");
    if (signal(SIGTERM, sigintHandlerT) == SIG_ERR)
      errExit("signal SIGTERM");
    
    int status;
    wait( &status );

    printf( "[PADRE] El valor de salida de mi hijo fue: %d\n", WEXITSTATUS(status) );
    std::cout << "[PADRE] ¡Adiós!" << std::endl;
        
    return 0;
  } 
  else {
    fprintf(stderr, "Error (%d) al crear el proceso: %s\n", errno, strerror(errno));
    return 3;
  }
}