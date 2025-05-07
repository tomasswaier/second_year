// uloha7-2.c

#include <stdio.h>
#include <string.h>

int mod;
int length;
long long arr[10][1000];

int getCenter() { return length / 2; }
int getExtCenter() { return (length - 1) / 2; }

unsigned long long new_pow(int base, int exponent) {
  unsigned long long result = 1;
  while (exponent > 0) {
    result *= base;
    exponent--;
  }
  return result;
}

void solution(int depth) {

  if (depth > getExtCenter())
    return;

  for (int i = depth == getExtCenter(), remainder = 0; i < 10; i++) {

    remainder = ((new_pow(10, getExtCenter() - depth) * i) % mod +
                 ((new_pow(10, getCenter() + depth) * i) % mod)) %
                mod;

    for (int j = 0; j < mod; j++)
      arr[depth][(remainder + j) % mod] += arr[depth - 1][j];
  }
  solution(depth + 1);
}

int main() {

  int n;
  scanf("%d", &n);

  for (int i = 0; i < n; i++) {
    scanf("%d %d", &mod, &length);

    for (int i = 0 == getExtCenter(); i < 10; i++)
      arr[0][(((new_pow(10, getCenter()) * i) +
               (!(length % 2) ? (new_pow(10, getCenter() - 1) * i) : (0))) %
              mod)] += 1;

    solution(1);
    printf("%lld\n", arr[getExtCenter()][0]);

    memset(arr, 0, sizeof(arr));
  }
  return 0;
}
