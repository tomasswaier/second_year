#include <arpa/inet.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define PORT 8080
#define MAX_CONNECTIONS 5

void help();
int run_server();
int run_client();

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
  pid_t pid; // wpid;
  // int status = 1;
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
  } else if (strcmp(line_args[0], "help") == 0) {
    help();

  } else if (strcmp(line_args[0], "halt") == 0) {
    execute_exit_call();

  } else if (strcmp(line_args[0], "quit") == 0) {
    // execute_exit_call();

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
  char *buffer = NULL;
  size_t bufsize = 0;
  getline(&buffer, &bufsize, stdin);
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
void help() {
  printf("Autor:Tomáš Meravý Murárik\nThis program should be used as "
         "normal shell\ncommands: cd,ls,help,quit,halt\n");
}

int main(int argc, char *argv[]) {
  if (argc > 1) {
    if (strcmp(argv[1], "-h") == 0) {
      help();
      return EXIT_SUCCESS;
    } else if (strcmp(argv[1], "-s") == 0) {
      return run_server();
    } else if (strcmp(argv[1], "-c") == 0) {
      return run_client();
    }
  }

  return run_server();
}

int run_server() {
  int server_fd, new_socket;
  struct sockaddr_in address;
  int opt = 1;
  int addrlen = sizeof(address);

  if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
    perror("socket failed");
    exit(EXIT_FAILURE);
  }

  if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt,
                 sizeof(opt))) {
    perror("setsockopt");
    exit(EXIT_FAILURE);
  }

  address.sin_family = AF_INET;
  address.sin_addr.s_addr = INADDR_ANY;
  address.sin_port = htons(PORT);

  if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
    perror("bind failed");
    exit(EXIT_FAILURE);
  }

  if (listen(server_fd, MAX_CONNECTIONS) < 0) {
    perror("listen");
    exit(EXIT_FAILURE);
  }

  printf("Server running on port %d\n", PORT);

  if ((new_socket = accept(server_fd, (struct sockaddr *)&address,
                           (socklen_t *)&addrlen)) < 0) {
    perror("accept");
    exit(EXIT_FAILURE);
  }

  dup2(new_socket, STDIN_FILENO);
  dup2(new_socket, STDOUT_FILENO);

  main_loop();

  close(new_socket);
  close(server_fd);
  return EXIT_SUCCESS;
}

int run_client() {
  int sock = 0;
  struct sockaddr_in serv_addr;
  if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
    perror("socket creation error");
    return EXIT_FAILURE;
  }
  serv_addr.sin_family = AF_INET;
  serv_addr.sin_port = htons(PORT);

  if (inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr) <= 0) {
    perror("invalid address");
    return EXIT_FAILURE;
  }
  if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
    perror("connection failed");
    return EXIT_FAILURE;
  }
  printf("Connected to server\n");
  pid_t pid = fork();
  if (pid == 0) {
    char buf[1024];
    while (1) {
      if (fgets(buf, sizeof(buf), stdin)) {
        write(sock, buf, strlen(buf));
      }
    }
  } else {
    char resp[1024];
    while (1) {
      ssize_t n = read(sock, resp, sizeof(resp) - 1);
      if (n > 0) {
        resp[n] = '\0';
        printf("%s", resp);
        fflush(stdout);
      }
    }
  }
  close(sock);
  return EXIT_SUCCESS;
}
