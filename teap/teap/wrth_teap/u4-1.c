#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define true 1
#define false 0
#define bool int

typedef struct
{
    long long accept;
    long long decline;

} Hill;

int main()
{
    int n;
    int d;
    int v;

    scanf("%d", &n);

    
    for(int i = 0; i < n; i++)
    {
        scanf("%d %d", &d, &v);

        Hill* current = (Hill*)calloc(v + 2, sizeof(Hill));
        Hill* prev = (Hill*)calloc(v + 2, sizeof(Hill));

        if (v == 1)
            prev[1].accept = 1;
        else
            prev[1].decline = 1;


        for (int j = 1; j < d - 1; j++) 
        {
            int k = 1;

            while(true)
            {
                if (k == v) 
                {
                    current[k].accept = prev[k - 1].accept + prev[k].accept + prev[k - 1].decline;
                    break;
                }
                current[k].accept = (prev[k - 1].accept + prev[k].accept + prev[k + 1].accept) % 100000007;
                current[k].decline = (prev[k - 1].decline + prev[k].decline + prev[k + 1].decline) % 100000007;

                k++;
            }
            memcpy(prev, current, (v + 2) * sizeof(Hill));
        }
        printf("%lld\n", current[1].accept);

        free(prev);
        free(current);
    }
    return 0;
}