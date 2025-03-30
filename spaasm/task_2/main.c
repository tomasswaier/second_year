#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
int change_dir_call(char **line_args) {
  if (line_args[1] == NULL) {
    perror("missing second argument");
  } else {
    if (chdir(line_args[1]) != 0) {
      perror("error while changing dir");
    }
  }

  return 1;
}
void execute_child(char **line_args) {
  //  kinder
  char *input = NULL, *output = NULL;
  char **clean_args = malloc(128 * sizeof(char *));
  int idx = 0;

  for (int i = 0; line_args[i]; i++) {
    if (strcmp(line_args[i], "<") == 0) {
      input = line_args[++i];
    } else if (strcmp(line_args[i], ">") == 0) {
      output = line_args[++i];
    } else if (strcmp(line_args[i], "") != 0) {
      clean_args[idx++] = line_args[i];
    }
  }
  clean_args[idx] = NULL;
  if (input) {
    int fd = open(input, O_RDONLY);
    if (fd == -1) {
      perror("open");
      exit(EXIT_FAILURE);
    }
    dup2(fd, STDIN_FILENO);
    close(fd);
  } else if (output) {
    int fd = open(output, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd == -1) {
      perror("open");
      exit(EXIT_FAILURE);
    }
    dup2(fd, STDOUT_FILENO);
    close(fd);
  }
  execvp(clean_args[0], clean_args);
  perror("execvp");
  free(clean_args);
  exit(EXIT_FAILURE);
}
int external_call(char **line_args) {
  pid_t pid, wpid;
  int status = 1;
  pid = fork();
  if (pid > 0) {
    // eltern
    waitpid(pid, NULL, 0);
  } else if (pid == 0) {
    execute_child(line_args);
  }
  return 1;
}
int execute_exit_call() { exit(1); }

int execute_args(char **line_args) {
  if (strcmp(line_args[0], "cd") == 0) {
    change_dir_call(line_args);
  } else if (strcmp(line_args[0], "exit") == 0) {
    execute_exit_call();

  } else {
    external_call(line_args);
  }

  return 1;
}

char **devide_line(char *line_read, int *index, char *delimiter) {
  char *token;
  char **tokens = (char **)malloc(128 * sizeof(char *));

  if (!tokens) {
    perror("allocation error");
    exit(1);
  }
  token = strtok(line_read, delimiter);
  *index = 0;
  while (token != NULL && *index < 31) {
    tokens[*index] = token;
    (*index)++;
    token = strtok(NULL, delimiter);
  }
  tokens[*index] = NULL;
  return tokens;
}

char *read_line() {
  char *buffer;
  size_t bufsize = 0;
  size_t characters;
  characters = getline(&buffer, &bufsize, stdin);
  char *ptr = buffer;
  // remove \n from the end
  buffer[strcspn(buffer, "\n")] = '\0';
  return buffer;
}
char *remove_comment(char *line_read) {
  char *pos = strchr(line_read, '#');
  char *new_line;
  if (pos != NULL) {
    new_line =
        (char *)malloc((pos - line_read + 1) * sizeof(char)); // +1 for '\0'
    if (new_line == NULL) {
      perror("Memory allocation failed");
      exit(1);
    }
    strncpy(new_line, line_read, pos - line_read);
    new_line[pos - line_read] = '\0';
  } else {
    new_line = strdup(line_read);
  }

  return new_line;
}
void main_loop() {
  char ***line_args_separated; // here are stored all lines separated by ;
  int status = 1;
  while (status) {
    printf(">");
    char *line_read;
    line_read = read_line();
    line_read = remove_comment(line_read);
    int number_of_lines;
    char **separated_lines = devide_line(line_read, &number_of_lines, ";");
    for (int i = 0; i < number_of_lines; i++) {
      int number_of_args;
      char **line_args;
      line_args = devide_line(separated_lines[i], &number_of_args, " ");
      status = execute_args(line_args);
      free(line_args);
    }
    free(separated_lines);
    free(line_read);
  }
}

int main(int argc, char *argv[]) {
  main_loop();
  return EXIT_SUCCESS;
}
