// uloha-7-2.c -- Tomáš Meravý Murárik, 2025-05-04 09:42
#include <stdio.h>
#include <string.h>
long long long_pow(int base, int exponent) {
  unsigned long long result = 1;
  while (exponent--)
    result *= base;

  return result;
}

void solution(int max_depth, int center, int current_depth, int mod,
              long long dp[10][1000]) {

  if (current_depth > max_depth)
    return;

  int start_digit = (current_depth == max_depth) ? 1 : 0;

  for (int digit = start_digit; digit < 10; digit++) {

    long long left_contribution =
        (long_pow(10, max_depth - current_depth) * digit) % mod;
    long long right_contribution =
        (long_pow(10, center + current_depth) * digit) % mod;
    int combined_remainder = (left_contribution + right_contribution) % mod;

    for (int prev_remainder = 0; prev_remainder < mod; prev_remainder++) {
      int new_remainder = (combined_remainder + prev_remainder) % mod;
      dp[current_depth][new_remainder] += dp[current_depth - 1][prev_remainder];
    }
  }
  solution(max_depth, center, current_depth + 1, mod, dp);
}
int main() {
  int mod;
  int length;
  long long arr[10][1000];

  int n;
  scanf("%d", &n);

  for (int i = 0; i < n; i++) {
    scanf("%d %d", &mod, &length);
    int center = length / 2;
    int sm_center = (length - 1) / 2;

    for (int i = 0 == sm_center; i < 10; i++) {
      unsigned long long temp = (long_pow(10, center) * i);
      if (length % 2 == 0) {
        temp += (long_pow(10, center - 1) * i);
      }
      temp = temp % mod;

      arr[0][temp] += 1;
    }

    solution(sm_center, center, 1, mod, arr);
    printf("%lld\n", arr[sm_center][0]);

    memset(arr, 0, sizeof(arr));
  }

  return 0;
}
