#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

int main() {
  int n;

  while (scanf("%d", &n) > 0) {
    int a, b, result = 0;
    int *t_i = (int *)malloc(sizeof(int) * n);

    for (int i = 0; i < n; i++) {
      scanf("%d", &t_i[i]);
    }

    scanf("%d %d", &a, &b);

    bool *myArr = (bool *)calloc(b + 1, sizeof(bool));

    for (int i = 0; i <= b; i++) {
      for (int j = 0; j < n; j++) {
        if (i - t_i[j] >= 0 && !myArr[i - t_i[j]]) {
          myArr[i] = true;
          break;
        }
      }
    }

    for (int i = a; i <= b; i++) {
      if (myArr[i]) {
        result++;
      }
    }

    printf("result:%d\n", result);

    free(myArr);
    free(t_i);
  }
  return 0;
}
