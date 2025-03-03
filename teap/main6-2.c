#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>

typedef struct node {
  int x;
  int y;
  int *path;
  struct node *next;
} Node;

void printArray(int *array, int size) {
  printf("%d\n", array[size]);
  for (int i = 0; i < size; i++) {
    printf("%d ", array[i]);
  }
}

bool isInArray(int number, int size, int *arr) {
  for (int i = 0; i < size; i++) {
    if (arr[i] == number) {
      return true;
    }
  }
  return false;
}

bool arrayPositionExists(int y, int x, int n) {
  return !(y < 0 || y >= n || x < 0 || x >= n);
}

int *copyArray(int size, int *arr) {
  int *arrCopy = (int *)malloc(sizeof(int) * (size + 1));
  for (int i = 0; i <= size; i++) {
    arrCopy[i] = arr[i];
  }
  return arrCopy;
}

int *recursive(int **houses, int *arr, int y, int x, int n, int index,
               int row) {
  if (index >= n) {
    return arr;
  }

  int sides[4][2] = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}};
  int *foundBestPath = NULL;

  for (int i = 0; i < 4; i++) {
    int yModifier = sides[i][0];
    int xModifier = sides[i][1];

    if (arrayPositionExists(y + yModifier, x + xModifier, n) &&
        !isInArray(houses[y + yModifier][x + xModifier], n, arr) &&
        houses[y + yModifier][x + xModifier] <= n) {

      int *newArr = copyArray(n, arr);
      newArr[index] = houses[y + yModifier][x + xModifier];
      newArr[n] += houses[row][newArr[index] - 1];

      // printArray(newArr, n);

      int *foundPath = recursive(houses, newArr, y + yModifier, x + xModifier,
                                 n, index + 1, newArr[index] - 1);

      if (foundPath) {
        if (!foundBestPath || foundPath[n] < foundBestPath[n]) {
          if (foundBestPath) {
            free(foundBestPath);
          }
          foundBestPath = copyArray(n, foundPath);
          // printArray(foundBestPath, n);
        }
        free(foundPath);
      } else {
        free(newArr);
      }
    }
  }
  return foundBestPath;
}

int main() {
  Node *root = NULL;
  Node *walker = root;
  int n;
  scanf("%d", &n);

  int **houses = (int **)malloc(sizeof(int *) * n);
  for (int i = 0; i < n; i++) {
    houses[i] = (int *)malloc(sizeof(int) * n);
    for (int j = 0; j < n; j++) {
      int inputNum;
      scanf("%d", &inputNum);
      houses[i][j] = inputNum;
      if (inputNum == 1) {
        Node *newNode = (Node *)malloc(sizeof(Node));
        newNode->y = i;
        newNode->x = j;
        newNode->path = calloc(n + 1, sizeof(int));
        newNode->path[0] = 1;
        newNode->next = NULL;

        if (!root) {
          root = newNode;
          walker = root;
        } else {
          walker->next = newNode;
          walker = newNode;
        }
      }
    }
  }

  int *foundBestPath = NULL; // Initialize foundBestPath to NULL

  while (root) {
    Node *temp = root;
    int *foundPath = recursive(houses, root->path, root->y, root->x, n, 1, 0);

    if (foundPath) {
      if (!foundBestPath || foundPath[n] < foundBestPath[n]) {
        foundBestPath = foundPath;
      } else {
        printf("no path found\n");
        free(foundPath);
      }
    }

    free(root->path);
    root = root->next;
    free(temp);
  }

  if (foundBestPath) {
    printArray(foundBestPath, n);
  } else {
    printf("No valid path was found overall.\n");
  }

  for (int i = 0; i < n; i++) {
    free(houses[i]);
  }
  free(houses);

  return 0;
}
