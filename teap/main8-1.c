#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
int compare(const void *a, const void *b) { return (*(int *)a - *(int *)b); }

void printArr(int size, int *arr) {
  for (int i = 0; i < size; i++) {
    printf("%d ", arr[i]);
  }
  printf("\n");
}
bool search(int n, int m, int *n_arr, int *m_arr) {

  for (int i = n - 1; i >= 0; i--) {
    for (int j = 0; j < n_arr[i]; j++) {
      // printArr(n, n_arr);
      // printArr(m, m_arr);

      if (m_arr[m - 1 - j] == 0) {
        // printf("returning");
        return false;
      } else {
        m_arr[m - 1 - j]--;
      }
    }
    qsort(m_arr, m, sizeof(int), compare);
  }

  return true;
}
int main(int argc, char *argv[]) {
  int n;
  int m;
  while (scanf("%d %d", &n, &m) > 0) {
    int *n_arr = (int *)malloc(sizeof(int) * n);
    int *m_arr = (int *)malloc(sizeof(int) * m);
    for (int i = 0; i < n; i++) {
      int num;
      scanf("%d", &num);
      n_arr[i] = num;
    }
    qsort(n_arr, n, sizeof(int), compare);
    for (int i = 0; i < m; i++) {
      int num;
      scanf("%d", &num);
      m_arr[i] = num;
    }
    qsort(m_arr, m, sizeof(int), compare);
    if (n_arr[n - 1] > m) {
      printf("0\n");
      continue;
    } else {
      bool result = search(n, m, n_arr, m_arr);
      if (result) {
        printf("1\n");
      } else {
        printf("0\n");
      }
    }
  }
  return EXIT_SUCCESS;
}
