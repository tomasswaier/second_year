#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int check_array_emptyness(int *arr, int size) {
  for (int i = 0; i < size; i++) {
    if (arr[i] != -1) {
      return 0;
    }
  }
  return 1;
}
int find(int sum_now, int *nums_left, int size, int count) {
  if (sum_now < 0) {
    return -1;
  } else if (sum_now == 0 && check_array_emptyness(nums_left, size) == 1) {
    return count;
  }
  int *nums_left_cp = (int *)malloc(sizeof(int) * size);
  for (int i = 0; i < size; i++) {
    nums_left_cp[i] = nums_left[i];
  }
  int curr_num = 0;
  int multiplier = 1;
  int final_result = -1;
  for (int i = 0; i < size; i++) {
    if (nums_left_cp[i] == -1) {
      continue;
    }

    curr_num += nums_left_cp[i] * multiplier;
    nums_left_cp[i] = -1;
    int result;
    result = find(sum_now - curr_num, nums_left_cp, size, count + 1);
    if (result != -1) {
      if (final_result > result || final_result == -1) {
        final_result = result;
      }
    }
    multiplier *= 10;
  }
  free(nums_left_cp);
  return final_result;
}

int main() {
  char iwannakms[11];
  int result;

  while (scanf("%10s %d", iwannakms, &result) == 2) {
    int size = strlen(iwannakms);

    int *array = (int *)malloc(sizeof(int) * size);

    for (int i = 0; i < size; i++) {
      array[i] = iwannakms[size - 1 - i] - '0';
    }

    result = find(result, *(&array), size, 0);
    if (result < 0) {
      printf("IMPOSSIBLE\n");
    } else if (result == 0) {
      printf("%d\n", result);
    } else {
      printf("%d\n", result - 1);
    }
  }
}
