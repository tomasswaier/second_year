// uloha5-1.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <math.h>

#define true 1
#define false 0
#define bool int

int main() 
{

    int n;
    int k;

    while (scanf("%d %d", &n, &k) > 0) 
    {
    

        bool flag = false;
        int best = INT_MAX;
        int* arr = (int*) calloc(n, sizeof(int));

        for (int i = 0; i < n; i++)
            scanf("%d", &arr[i]);

        if (n < 3) 
        {
            printf("%d\n", n);
            continue;
        }

        for (int i = 2; i <= n; i++) 
        {

            int max = 0;
            int* result = (int*) calloc(i, sizeof(int));

            for (int j = 0; j < i - 1; j++) 
            {
                if (abs(arr[j] - arr[i - 1]) >= k) 
                    result[max++] = j + 1;
            }

            if(max == 0)
                continue;


            for (int j = 0, temp = 0; j < max; j++) 
            {
                temp = floor(result[j] / 2) + ceil((float) (i - result[j]) / 2) + 1;

                if (temp < best) 
                    best = temp;
            }
            break;
        }
        printf("%d\n", best == INT_MAX ? n : best);
    }
    return 0;
}