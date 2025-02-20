#include <stdio.h>
#include <stdlib.h>

#define true 1
#define false 0
#define bool int

int compare(const void* a, const void* b)
{
    if(*(int*)a > *(int*)b)
        return -1;

    else if(*(int*)a == *(int*)b)
        return 0;

    else
        return 1;
}

void deallocate(int** arr)
{
    if(*arr == NULL)
        return;

    free(*arr);
    *arr = NULL;
}

int main()
{
	int n;
    int m;

    int* n_arr = NULL;
    int* m_arr = NULL;
    bool checker = false;


	while (scanf("%d %d", &n, &m) > 0)
	{
        checker = false;
        
        // deallocate(&n_arr);
        // deallocate(&m_arr);

        n_arr = (int*)calloc(n, sizeof(int));
        m_arr = (int*)calloc(m, sizeof(int));

        for(int i = 0; i < n; i++)
            scanf("%d", &n_arr[i]);

        for(int i = 0; i < m; i++)
            scanf("%d", &m_arr[i]);

        qsort(n_arr, n, sizeof(int), compare);
        qsort(m_arr, m, sizeof(int), compare);


        if(n_arr[0] > m)
        {
            printf("0\n");
            continue;
        }

        for(int i = 0; i < n; i++)
        {
            for(int j = 0; j < n_arr[i]; j++)
            {
                if (m_arr[j] == 0) 
                {
                    checker = true;
                    break;
                }

                m_arr[j]--;
            }

            if (checker)
                break;

            qsort(m_arr, m, sizeof(int), compare);
        }
        printf(checker ? "0\n" : "1\n");
	}
}