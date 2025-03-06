#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>

void printArray(int *array, int size) {
  printf("%d\n", array[size]);
  for (int i = 0; i < size; i++) {
    printf("%d ", array[i]);
  }
  printf("\n");
}

bool isInArray(int number, int size, int *arr) {
  for (int i = 0; i < size; i++) {
    if (arr[i] == number) {
      return true;
    }
  }
  return false;
}

void recursive(int **houses, int *arr, int n, int index, int row, int *bestCost,
               int *bestPath) {
  if (index >= n) {
    if (arr[n] < *bestCost) {
      *bestCost = arr[n];
      for (int i = 0; i < n; i++) {
        bestPath[i] = arr[i];
      }
      bestPath[n] = arr[n];
    }
    return;
  }
  for (int i = 0; i < n; i++) {
    if (!isInArray(i + 1, index, arr)) {
      int temp = arr[index];
      int oldCost = arr[n];
      arr[index] = i + 1;
      arr[n] += houses[row][i];
      if (arr[n] < *bestCost) {
        recursive(houses, arr, n, index + 1, i, bestCost, bestPath);
      }
      arr[index] = temp;
      arr[n] = oldCost;
    }
  }
}

int main() {
  int n;
  scanf("%d", &n);
  int **houses = malloc(sizeof(int *) * n);
  for (int i = 0; i < n; i++) {
    houses[i] = malloc(sizeof(int) * n);
    for (int j = 0; j < n; j++) {
      scanf("%d", &houses[i][j]);
    }
  }
  int *startPath = calloc(n + 1, sizeof(int));
  startPath[0] = 1;
  // tu som dostal pomoc od chatgpt
  int bestCost = 1 << 30;
  int *bestPath = calloc(n + 1, sizeof(int));
  recursive(houses, startPath, n, 1, 0, &bestCost, bestPath);
  if (bestCost < (1 << 30)) {
    printArray(bestPath, n);
  } else {
    printf("debug");
    printf("No valid path was found overall.\n");
  }
  free(startPath);
  free(bestPath);
  for (int i = 0; i < n; i++) {
    free(houses[i]);
  }
  free(houses);
  return 0;
}
