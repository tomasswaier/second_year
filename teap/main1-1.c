// uloha-1-1.c -- Murárik Tom Meravý, 2025-02-16 12:43

#include "stdbool.h"
#include <stdio.h>
#include <stdlib.h>

void print_contents(int N, int K, int M, int h[]) {
  printf("N:%d K:%d M:%d:", N, K, M);
  for (int i = 0; i < M; i++) {
    printf(" %d", h[i]);
  }
}
int condition(const void *a, const void *b) { return (*(int *)b - *(int *)a); }
bool check_condition(int N, int K, int M, int h[]) {
  if (K > M || M > 9) {
    return false;
  }
  int together = 0;
  qsort(h, M, sizeof(int), condition);
  for (int i = 0; i < K; i++) {
    together += h[i];
  }
  if (together > N) {
    return false;
  }

  return true;
}

int main() {

  int N = 0;
  while (scanf("%d", &N) > 0) {
    int K = 0;
    int M = 0;
    scanf("%d %d", &K, &M);
    int *h = (int *)malloc(sizeof(int) * M);
    for (int i = 0; i < M; i++) {
      int h_i;
      scanf("%d", &h_i);
      h[i] = h_i;
    }
    // print_contents(N, K, M, h);
    bool result = check_condition(N, K, M, h);
    if (result) {
      printf("Ano\n");
    } else {
      printf("Nie\n");
    }
  }
  return 0;
}
/*Ano
Nie
Ano
Nie
Ano
Ano
Ano
Ano
Ano
Ano
Ano
Nie
Ano
Ano
Ano
Ano
Ano
Nie
Ano
Ano
*/
