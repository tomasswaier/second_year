#include <stdio.h>
#include <stdlib.h>

void print_arr(int *arr, int size) {
  for (int i = 0; i < size; i++) {
    printf("%d ", arr[i]);
  }
  printf("\n");
}
int condition(const void *a, const void *b) { return (*(int *)a - *(int *)b); }
int main() {
  int car_count = 0;
  while (scanf("%d", &car_count) > 0) {
    int *box_arr = (int *)calloc(car_count, sizeof(int));
    int size = 0;
    // print_arr(box_arr, size);
    for (int i = 0; i < car_count; i++) {
      int new_num = 0;
      scanf(" %d", &new_num);
      box_arr[i] = new_num;
      size++;
    }
    qsort(box_arr, size, sizeof(int), condition);
    // print_arr(box_arr, size);
    int result = 0;
    for (int i = 0; i < size - 1; i++) {
      for (int j = size - 1; j > i; j--) {
        // print_arr(box_arr, size);
        if (box_arr[j] == 0) {
          continue;
        } else if (box_arr[i] + box_arr[j] <= 300) {
          result++;
          box_arr[i] = 0;
          box_arr[j] = 0;
          break;
        }
      }
    }
    // print_arr(box_arr, size);
    for (int i = 0; i < size; i++) {
      if (box_arr[i] != 0) {
        result++;
      }
    }
    printf("%d\n", result);
    free(box_arr);
  }

  return 1;
}
