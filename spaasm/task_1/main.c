#include <stdio.h>

int main() {
  char riadok[50];
  char prevRiadok[50];
  while (scanf("%s", riadok) > 0) {
    for (int i = 0; riadok[i] != '\0' && prevRiadok[i] != '\0'; i++) {
      if (riadok[i] != prevRiadok[i]) {
        printf("output:%s\n", riadok);
        break;
      }
    }
    int i;
    for (i = 0; riadok[i] != '\0'; i++) {
      prevRiadok[i] = riadok[i];
    }
    prevRiadok[i] = '\0';
  }
}
