#include <stdio.h>
#include <stdlib.h>

int sortCondition(const void* a, const void* b) { return (*(int*)b - *(int*)a); }

int main()
{

    int n = 0;

    while(scanf("%d", &n) > 0)
    {
        int k = 0;
        int m = 0;

        scanf("%d %d", &k, &m);

        int* arr = (int*)calloc(m, sizeof(int));

        for(int i = 0; i < m; i++)
            scanf("%d", &arr[i]);

        qsort(arr, m, sizeof(int), sortCondition);

        int result = 0;

        for(int i = 0; i < k; i++)
            result += arr[i];

        printf(result <= n ? "Ano\n" : "Nie\n");

        free(arr);
    }

    return 0;
}