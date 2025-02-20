#include <stdio.h>
#include <stdlib.h>

void solve(int size, int n, int k, int** arr)
{
    if(n == 0)
    {
        for(int i = 0; i < size; i++)
            printf("%d ", (*arr)[i]);

        printf("\n");

        return;
    }

    for(int i = 1; i <= k; i++)
    {
        (*arr)[size - n] = i;
        solve(size, n - 1, k, arr);
    }
}

int main()
{
    int n;
    int k;

    scanf("%d %d", &n, &k);

    int* arr = (int*)calloc(n, sizeof(int));
    solve(n, n, k, &arr);

    free(arr);

    return 0;
}