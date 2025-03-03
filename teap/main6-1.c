// uloha-6-1.c -- Tomáš Meravý Murárik, 2025-02-27 15:26
#include <stdio.h>
void recursion(int n, int k, int current_num) {
  if (n <= 0) {
    printf("%d\n", current_num);
    return;
  }
  current_num *= 10;
  for (int i = 1; i <= k; i++) {
    recursion(n - 1, k, current_num + i);
  }
}

int main() {
  int n, k;
  scanf("%d %d", &n, &k);

  return 1;
}
