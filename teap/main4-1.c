#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

void print_arr(int ***arr, int y, int x) {
  for (int i = 0; i <= y; i++) {
    for (int j = 0; j <= x; j++) {
      printf("%d ", (*arr)[i][j]);
    }
    printf("\n");
  }
  printf("\n");
}

void elper(int d, int max, int ***calc_array, int ***res_array) {
  // print_arr(calc_array, max, d);

  for (int i = 1; i < d - max + 1; i++) {
    for (int j = 1; j <= max; j++) {
      int count = 0;
      count += (*calc_array)[j - 1][i - 1];
      count += (*calc_array)[j][i - 1];
      if (j < max)
        count += (*calc_array)[j + 1][i - 1];
      if (j == max)
        (*res_array)[j][i] = count;

      count = (count % 100000007);
      (*calc_array)[j][i] = count;
    }
  }
  // print_arr(calc_array, max, d);
  for (int i = max - 1; i <= d; i++) {
    for (int j = 1; j < max; j++) {
      int count = 0;
      if (i > 1 || j > 1)
        count += (*res_array)[j - 1][i - 1];
      count += (*res_array)[j][i - 1];
      count += (*res_array)[j + 1][i - 1];
      count = (count % 100000007);

      (*res_array)[j][i] = count;
    }
  }
  // print_arr(res_array, max, d);
}

int main() {
  int n;
  scanf("%d", &n);
  for (int i = 0; i < n; i++) {
    int d, v;
    scanf("%d %d", &d, &v);
    int **calc_array = (int **)malloc(sizeof(int *) * (1 + v));
    int **res_array = (int **)malloc(sizeof(int *) * (v + 1));
    for (int i = 0; i <= v; i++) {
      calc_array[i] = (int *)calloc(d + 1, sizeof(int));
      res_array[i] = (int *)calloc(d + 1, sizeof(int));
    }
    calc_array[0][0] = 1;
    elper(d, v, &calc_array, &res_array);
    printf("%d\n", res_array[1][d - 1] % 100000007);
    for (int i = 0; i <= v; i++) {
      free(calc_array[i]);
      free(res_array[i]);
    }
    free(calc_array);
    free(res_array);
  }
  return 1;
}
