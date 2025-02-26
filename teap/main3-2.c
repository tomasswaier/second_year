#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *ARRAY[] = {"1",
                 "101",
                 "11001",
                 "1111101",
                 "1001110001",
                 "110000110101",
                 "11110100001001",
                 "10011000100101101",
                 "1011111010111100001",
                 "111011100110101100101",
                 "100101010000001011111001",
                 "10111010010000111011011101",
                 "1110100011010100101001010001",
                 "1001000110000100111001110010101",
                 "101101011110011000100000111101001",
                 "11100011010111111010100100110001101",
                 "10001110000110111100100110111111000001",
                 "1011000110100010101111000010111011000101",
                 "110111100000101101101011001110100111011001",
                 "100010101100011100100011000001001000100111101",
                 "10101101011110001110101111000101101011000110001",
                 "1101100011010111001001101011011100010111011110101"};

char *make_range_copy(char *string, int start, int end) {

  char *str_cp = (char *)malloc(end - start + 1); // +1 for null terminator
  if (!str_cp)
    return NULL;

  strncpy(str_cp, string + start, end - start);
  str_cp[end - start] = '\0';

  return str_cp;
}
bool is_pow_of_five(char *string) {

  /*
  while (*string == '0' && *(string + 1) != '\0') {
    string++;
  }
  */
  for (int i = 0; i <= 21; i++) {
    // printf("Comparing: %s == %s\n", string, ARRAY[i]);
    if (strcmp(string, ARRAY[i]) == 0) {
      return true;
    }
  }

  return false;
}

int recursive_find(char *input_binary, int size, int end_pos, int result,
                   int smallest_found) {
  if (end_pos == size) {
    return result;
  }
  int found_min = -1;

  for (int i = size; i > end_pos; i--) {
    char *str_cp = make_range_copy(input_binary, end_pos, i);
    if (result > smallest_found && found_min != -1) {
      break;
    }
    // printf("%s ,%d\n", str_cp, result);
    if (is_pow_of_five(str_cp)) {
      int new_result =
          recursive_find(input_binary, size, i, result + 1, smallest_found);
      if (new_result != -1 && (found_min == -1 || found_min > new_result)) {
        found_min = new_result;
      }
      if (new_result != -1 &&
          (smallest_found == -1 || smallest_found > new_result)) {
        smallest_found = new_result;
      }
    } else {
      // printf("not pow of five\n");
    }
    free(str_cp);
  }
  return found_min;
}

int main() {

  char input_string[50];
  while (scanf("%s", input_string) > 0) {
    int size = strlen(input_string);
    int result = recursive_find(input_string, size, 0, 0, -1);
    printf("%d\n", result);
    // printf("%d\n", result);
  }
}

/*
3
1
-1
3
-1
5
1
-1
-1
50
4
7
4
22
10

*/
