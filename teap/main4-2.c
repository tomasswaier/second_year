#include <stdbool.h>
#include <stdio.h>
#include <string.h>
// I do not like being alive.Please make it stop why is this even a taks I want
// to kill my self

char SAMOHLASKY[] = {'A', 'E', 'I', 'O', 'U'};

int isVowel(char letter) {
  for (int i = 0; i < 5; i++) {
    if (SAMOHLASKY[i] == letter)
      return 1;
  }
  if (letter == '?')
    return 0;
  return -1;
}

void meow(char *inputString) {
  bool unknown = false;
  int i = 0;
  // mimimiii why do u have so many weird vairable BECAUSE ITS DIGSTUGINGLY
  // BRAINDEAD TASK GO KYS RETARD
  int currentCountVowel = 0;
  int usedCountVowel = 0;
  int currentCountNotVowel = 0;
  int usedCountNotVowel = 0;
  int requiredCount = 0;
  int questionMarkCount = 0;
  int usedQuestionMarkCount = 0;
  while (inputString[i] != '\0') {
    int expectedValue = isVowel(inputString[i]);
    if (expectedValue == 1) {
      requiredCount = 3;
      usedCountVowel += currentCountVowel;
      currentCountVowel = 0;
      usedCountNotVowel = currentCountNotVowel;
      currentCountNotVowel = 0;
    } else if (expectedValue == -1) {
      requiredCount = 5;
      usedCountVowel = currentCountVowel;
      currentCountVowel = 0;
      usedCountNotVowel += currentCountNotVowel;
      currentCountNotVowel = 0;
    } else if (i == 0 && expectedValue == 0) {
      requiredCount = 3;
    } else {
      usedCountVowel = currentCountVowel;
      currentCountVowel = 0;
      usedCountNotVowel = currentCountNotVowel;
      currentCountNotVowel = 0;
    }
    usedQuestionMarkCount = questionMarkCount;
    questionMarkCount = 0;

    int j;
    for (j = i; inputString[j] != '\0'; j++) {
      printf(" curStr:%c countVowel:%d cVU:%d countNVowel:%d cNVU:%d "
             "qMarkCount:%d "
             "usedQmarkCount:%d ,required:%d, i:%d j:%d \n",
             inputString[j], currentCountVowel, usedCountVowel,
             currentCountNotVowel, usedCountNotVowel, questionMarkCount,
             usedQuestionMarkCount, requiredCount, i, j);

      int currentLetterValue = isVowel(inputString[j]);
      if (currentLetterValue == expectedValue) {
        if (currentLetterValue == 0) {
          questionMarkCount++;

          if (currentCountNotVowel + usedCountNotVowel + usedQuestionMarkCount +
                      questionMarkCount >=
                  requiredCount ||
              currentCountVowel + usedCountVowel + usedQuestionMarkCount +
                      questionMarkCount >=
                  requiredCount) {
            // printf("one\n");
            unknown = true;
          }
        } else if (currentLetterValue == -1) {
          currentCountNotVowel++;
          if (currentCountNotVowel >= requiredCount) {
            printf("paci\n");
            return;
          }
          if (currentCountNotVowel + usedCountNotVowel + usedQuestionMarkCount +
                  questionMarkCount >=
              requiredCount) {
            // printf("two\n");
            unknown = true;
          }
        } else if (currentLetterValue == 1) {
          currentCountVowel++;
          if (currentCountVowel >= requiredCount) {
            printf("paci\n");
            return;
          }
          if (currentCountVowel + usedCountVowel + usedQuestionMarkCount +
                  questionMarkCount >=
              requiredCount) {
            // printf("three\n");
            unknown = true;
          }
        }
      } else {
        if (expectedValue == 0) {
          // this code is so ungodly shit I can not
          if (currentLetterValue == -1) {
            /*
            printf("expectedValue=0 :curStr:%c countVowel:%d cVU:%d "
                   "countNVowel:%d "
                   "cNVU:%d "
                   "qMarkCount:%d "
                   "usedQmarkCount:%d ,required:%d, i:%d j:%d \n",
                   inputString[j], currentCountVowel, usedCountVowel,
                   currentCountNotVowel, usedCountNotVowel, questionMarkCount,
                   usedQuestionMarkCount, requiredCount, i, j);
                   */
            if (usedCountVowel >= 2 && questionMarkCount == 1) {
              // printf("nig\n");

              usedCountVowel = 0;
              currentCountVowel = 0;
              inputString[j - 1] = 'X';
              // printf("%c\n", inputString[j - 1]);
              questionMarkCount = 0;
              j = j - 1;
              break;
            }
            usedCountVowel = 0;
            currentCountVowel = 0;
          } else if (currentLetterValue == 1) {
            if (usedCountNotVowel >= 4 && questionMarkCount == 1) {
              currentCountNotVowel = 0;
              usedCountNotVowel = 0;
              inputString[j - 1] = 'A';
              questionMarkCount = 0;

              j = j - 1;
              break;
            }
            currentCountNotVowel = 0;
            usedCountNotVowel = 0;
          }
          break;
        } else {
          if (currentLetterValue == 1) {
            currentCountNotVowel = 0;
          } else {
            currentCountVowel = 0;
          }
        }
        break;
      }
    }
    i = j;
  }
  if (unknown) {
    printf("neviem\n");
    return;
  }

  printf("nepaci\n");
}

int main() {
  char inputString[50];
  while (fgets(inputString, sizeof(inputString), stdin)) {
    inputString[strcspn(inputString, "\n")] = 0; // Remove newline
    meow(inputString);
  }
}
/*nepaci
paci
neviem
nepaci
paci
nepaci
nepaci
neviem
neviem
neviem
neviem
neviem
neviem

    int max = 0;
    if (lookingForVowel == 1) {
      max = 3;
      if (question_mark_count == 1 && i > 1) {
        max -= question_mark_count;
      }
    } else if (lookingForVowel == -1) {
      max = 5;
      if (question_mark_count == 1 && i > 1) {
        max -= question_mark_count;
      }
    } else {
      question_mark_count = 1;
      max = 3;
    }
    question_mark_count = 0;

    for (int j = i; inputString[j] != '\0'; j++) {
      // printf("%c", inputString[j]);
      int found_letter = isVowel(inputString[j]);
      if (found_letter == lookingForVowel && found_letter != 0) {
        used_question_marks += question_mark_count;
        question_mark_count = 0;
        max -= 1;
        if (max <= 0) {
          printf("paci\n");
          return;
        }
        // printf("%d -%d\n", max, used_question_marks);
        if (max - used_question_marks <= 0) {
          neviem = true;
          continue;
        }
      } else if (found_letter == 0) {
        question_mark_count += 1;
        // printf("%d\n", max - question_mark_count);
        if (max - question_mark_count - used_question_marks <= 0) {
          neviem = true;
          continue;
        }
      } else if (found_letter != lookingForVowel &&
                 lookingForVowel == 0) {
        lookingForVowel = found_letter;
        used_question_marks = question_mark_count;
        break;
      } else if (found_letter != lookingForVowel) {
        i = j - 1;
        used_question_marks = 0;
        break;
      }
    }
    i += 1;
    // printf("\n");
  }
  i += 1;
  if (neviem) {
    printf("neviem\n");
    return;
  }
*/
