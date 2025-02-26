// uloha-4-2.c -- Murárik Tom Meravý, 2025-02-22 09:06
// EI?RQQ?A?WWQ?I?QRQ?A?QRQ?I?WQR?A?RWR?E?WQR?E?QRR
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

  int helperValueVowel = 1;
  int helperValueNotVowel = 1;
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
      if (usedCountNotVowel > 0) {
        questionMarkCount += usedQuestionMarkCount;
      }
    } else if (expectedValue == -1) {
      requiredCount = 5;
      usedCountVowel = currentCountVowel;
      currentCountVowel = 0;
      usedCountNotVowel += currentCountNotVowel;
      currentCountNotVowel = 0;
      if (usedCountNotVowel > 0) {
        questionMarkCount += usedQuestionMarkCount;
      }
    } else if (i == 0 && expectedValue == 0) {
      requiredCount = 3;
    } else {
      usedCountVowel += currentCountVowel;
      helperValueVowel = currentCountVowel;
      currentCountVowel = 0;
      usedCountNotVowel += currentCountNotVowel;
      helperValueNotVowel = currentCountNotVowel;
      currentCountNotVowel = 0;
    }
    usedQuestionMarkCount = questionMarkCount;
    questionMarkCount = 0;

    int j;
    for (j = i; inputString[j] != '\0'; j++) {

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
            if (helperValueVowel == 2 && questionMarkCount == 1) {

              usedCountVowel = 0;
              currentCountVowel = 0;
              inputString[j - 1] = 'X';
              questionMarkCount = 0;
              j = j - 1;
              break;
            }
            usedCountVowel = 0;
            currentCountVowel = 0;
          } else if (currentLetterValue == 1) {
            if (helperValueNotVowel == 4 && questionMarkCount == 1) {
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
          } else if (currentLetterValue == -1) {
            currentCountVowel = 0;
          } else {
            questionMarkCount = usedQuestionMarkCount;
            usedQuestionMarkCount = 0;
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
  } else {
    printf("nepaci\n");
  }
  fflush(stdout);
}

int main() {
  char *inputString = NULL;
  size_t size = 0;
  ssize_t length = 0;
  while ((length = getline(&inputString, &size, stdin)) != -1) {
    inputString[strcspn(inputString, "\r\n")] = '\0';
    if (strlen(inputString) == 0)
      continue;
    meow(inputString);
  }
}
