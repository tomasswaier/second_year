#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>


int *out = NULL;
int *idx = NULL;
int **arr = NULL;
int min = INT_MAX;

void generation(int n, int gen) 
{

    if(gen < n)
    {
        for (int i = 1; i < n; i++) 
        {
            //if we have already used this number
            //author copilot

            if ((gen > 1) && ((1 < gen && idx[1] == i) || (2 < gen && idx[2] == i) || (3 < gen && idx[3] == i) || (4 < gen && idx[4] == i) || (5 < gen && idx[5] == i) || (6 < gen && idx[6] == i) || (7 < gen && idx[7] == i) || (8 < gen && idx[8] == i))) 
                continue;

            idx[gen] = i;
            generation(n, gen + 1);
        }
        return;
    }

    int cost = 0;

    for (int i = 0; i < n - 1; i++) 
        cost += arr[idx[i]][idx[i + 1]];

    if (cost < min) 
    {
        min = cost;
        memcpy(out, idx, n * sizeof(int));
        return;
    }

    for (int i = 0; i < n; i++) 
    {
        if(idx[i] == out[i])
            continue;
        
        if (idx[i] > out[i])
            break;

        memcpy(out, idx, n * sizeof(int));
        break;
    }
}


int main() 
{

    int n;

    scanf("%d", &n);

    out = (int*) calloc(n, sizeof(int));
    idx = (int*) calloc(n, sizeof(int));
    arr = (int**) calloc(n, sizeof(int*));
    
    memset(out, -1, n * sizeof(int));
    memset(idx, -1, n * sizeof(int));
    idx[0] = 0;

    for (int i = 0; i < n; i++) 
    {
        arr[i] = (int*) calloc(n, sizeof(int));

        for (int j = 0; j < n; j++) 
            scanf("%d", &arr[i][j]);
    }

    generation(n, 1);

    printf("%d\n", min);

    for (int i = 0; i < n; i++) 
        free(arr[i]), printf("%d ", ++out[i]);

    printf("\n");

    free(arr);
    free(out);
    free(idx);

    return 0;
}