#include <stdio.h>
#include <stdlib.h>

void print_arr(int *arr, int size) {
  for (int i = 0; i < size; i++) {
    printf("%d ", arr[i]);
  }
  printf("\n");
}
int main() {
  int n;

  while (scanf("%d", &n) > 0) {
    int a, b, result = 0;
    int *t_i = (int *)malloc(sizeof(int) * n);
    for (int i = 0; i < n; i++) {
      scanf("%d", &t_i[i]);
    }
    print_arr(t_i, n);
    scanf("%d", &a);
    scanf("%d", &b);
  }
}
