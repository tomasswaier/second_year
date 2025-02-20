#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
  char input_string[50];
  while (scanf("%s", input_string) > 0) {
    int size = strlen(input_string);

    int *array = (int *)malloc(sizeof(int) * size);

    double result_num = 0;
    for (int i = 0; i < size; i++) {
      array[i] = input_string[i] - '0';
      result_num += pow(2, i) * (input_string[i] - '0');
    }
    long long intfinal_num = (long long int)result_num;
    printf("%lli\n", intfinal_num);
  }
}
