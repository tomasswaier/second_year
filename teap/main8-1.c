#include <stdio.h>
#include <stdlib.h>
int compare(const void *a, const void *b) { return (*(int *)a - *(int *)b); }

int main(int argc, char *argv[]) {
  int n;
  int m;
  while (scanf("%d %d", &n, &m)) {
    int *n_arr = (int *)malloc(sizeof(int) * n);
    int *m_arr = (int *)malloc(sizeof(int) * n);
    for (int i = 0; i < n; i++) {
      int num;
      scanf("%d", &num);
      n_arr[i] = num;
    }
    for (int i = 0; i < m; i++) {
      int num;
      scanf("%d", &num);
      m_arr[i] = num;
    }
  }
  return EXIT_SUCCESS;
}
