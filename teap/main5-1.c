// uloha-5-1.c -- Murárik Tom Meravý, 2025-02-26 18:14

#include <stdio.h>
#include <stdlib.h>

int get_index(int num, int *arr) {
  int i = 0;
  while (arr[i] != num) {
    i++;
  }

  return i;
}
int getNumOfSteps(int indexStart, int indexEnd) {
  int result = 0;
  // printf("iST:%d iED:%d
  if ((indexEnd - indexStart) % 2 == 1) {
    result += 1;
    indexEnd -= 1;
  }
  result += (indexEnd - indexStart) / 2;
  return result;
}
int checker(int foundMin, int foundMax, int *arr) {
  int indexFoundMin = get_index(foundMin, arr);
  int indexFoundMax = get_index(foundMax, arr);
  int indexMin;
  int indexMax;
  if (indexFoundMax > indexFoundMin) {
    // bad uwu
    indexMax = indexFoundMax;
    indexMin = indexFoundMin;
  } else {
    indexMin = indexFoundMax;
    indexMax = indexFoundMin;
  }
  int result = 1;
  if (indexMin != 0) {
    result += getNumOfSteps(0, indexMin);
  }
  // printf("%d %d %d\n", 0, indexMin, result);
  result += getNumOfSteps(indexMin, indexMax);
  // printf("%d %d %d\n", indexMin, indexMax, result);
  return result;
}
int cheating(int size, int *arr, int k) {
  int foundMin = 1 << 29;
  int foundMax = 0;
  int minimini = -1;
  for (int i = 0; i < size; i += 2) {
    if (foundMin > arr[i]) {
      foundMin = arr[i];
    }
    if (foundMax < arr[i]) {
      foundMax = arr[i];
    }

    if (foundMax - foundMin >= k && minimini == -1) {
      minimini = i / 2 + 1;
      break;
    }
  }
  // printf("miniminimini %d %d\n", foundMin, foundMax);
  foundMin = 1 << 29;
  foundMax = 0;
  for (int i = 1; i < size; i += 2) {
    if (foundMin > arr[i]) {
      foundMin = arr[i];
    }
    if (foundMax < arr[i]) {
      foundMax = arr[i];
    }

    if (foundMax - foundMin >= k &&
        (minimini > foundMax - foundMin || minimini == -1)) {
      minimini = (i + 1) / 2 + 1;
      break;
    }
  }
  // printf("miniminimini %d %d\n", foundMin, foundMax);

  return minimini == -1 ? 1 << 29 : minimini;
}

int finder(int size, int k, int *array) {
  int foundMax = array[0];
  int foundMin = array[0];
  int *minArr = (int *)malloc(sizeof(int) * size);
  int *maxArr = (int *)malloc(sizeof(int) * size);
  for (int i = 0; i < size; i++) {
    if (array[i] < foundMin) {
      foundMin = array[i];
    }
    if (array[i] > foundMax) {
      foundMax = array[i];
    }
    minArr[i] = foundMin;
    maxArr[i] = foundMax;
  }
  int result = size;
  for (int i = 0; ((i - i % 2) / 2) < result + 3 && i < size; i++) {
    // printf("min:%d max:%d\n", minArr[i], maxArr[i]);
    if (maxArr[i] - minArr[i] >= k) {
      // printf("im in here min:%d max:%d\n", minArr[i], maxArr[i]);
      int foundNum = checker(minArr[i], maxArr[i], array);
      result = foundNum < result ? foundNum : result;
    }
  }
  int cheater = cheating(size, array, k);
  // printf("cheater : %d\n", cheater);

  if (result == 1 << 29) {
    return size;
  }
  result = cheater < result ? cheater : result;

  return result;
}

int main() {

  int n;
  int k;

  while (scanf("%d %d\n", &n, &k) > 0) {

    int *t_i = (int *)malloc(sizeof(int) * n);

    for (int i = 0; i < n; i++) {
      scanf("%d", &t_i[i]);
    }
    printf("%d\n", finder(n, k, t_i));
  }

  return 1;
}
