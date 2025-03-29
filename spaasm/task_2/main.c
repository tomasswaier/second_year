#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

int execute_args(char **line_args) {
  pid_t pid, wpid;
  int status = 1;
  pid = fork();

  return 1;
}
char **devide_line(char *line_read, int *index) {
  char *token;
  char **tokens = (char **)malloc(32 * sizeof(char *));

  if (!tokens) {
    perror("allocation error");
    exit(1);
  }
  token = strtok(line_read, " ");
  *index = 0;
  while (token != NULL) {
    tokens[*index] = token;
    (*index)++;
    token = strtok(NULL, " ");
  }
  return tokens;
}

char *read_line() {
  char *buffer;
  size_t bufsize = 0;
  size_t characters;
  characters = getline(&buffer, &bufsize, stdin);

  return buffer;
}
void main_loop() {
  char *line_read;
  char **line_args;
  int status = 1;
  while (status) {
    printf(">");
    line_read = read_line();
    int number_of_args;
    line_args = devide_line(line_read, &number_of_args);
  }
}

int main(int argc, char *argv[]) {

  main_loop();

  return EXIT_SUCCESS;
}
