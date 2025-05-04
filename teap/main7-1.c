#include <stdio.h>
#include <string.h>

int matcharr[10][10];
int result[10][1024][10];
int recursive(int i, int j, int k, int K, int N, int M) {
  if (k == K) {
    return 1;
  }
  if (i == N) {
    return 0;
  }
  if (result[i][j][k] != -1) {
    return result[i][j][k];
  }

  int combinations;
  combinations = recursive(i + 1, j, k, K, N, M);
  for (int p = 0; p < M; p++) {

    if (((j >> p) & 1) == 0 && matcharr[i][p] == 1)
      combinations += recursive(i + 1, j | (1 << p), k + 1, K, N, M);
  }
  result[i][j][k] = combinations;
  return combinations;
}
int main() {
  int K;
  int N;
  int M;
  while (scanf("%d %d %d", &K, &N, &M) > 0) {
    getchar();
    for (int i = 0; i < N; i++) {
      for (int j = 0; j < M; j++) {
        char input_char = getchar();
        // printf(".%s.", &input_char);
        matcharr[i][j] = (input_char == 'Y') ? 1 : 0;
      }
      getchar();
    }
    // for (int i = 0; i < N; i++) {
    //   for (int j = 0; j < M; j++) {
    //     printf("%d", matcharr[i][j]);
    //   }
    //   printf("\n");
    // }
    memset(result, -1, sizeof(result));
    printf("%d\n", recursive(0, 0, 0, K, N, M));
  }

  return 1;
}
