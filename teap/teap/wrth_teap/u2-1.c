#include <stdio.h>
#include <stdlib.h>

#define true 1
#define false 0
#define bool int


int main()
{
    int n;
    int a;
    int b;
    int out;

	while (scanf("%d", &n) > 0)
	{
        a = 
        b = 
        out = 0;

        int* accepted_moves = (int*)calloc(n, sizeof(int));

        for(int i = 0; i < n; i++)
            scanf("%d", &accepted_moves[i]);

        scanf("%d", &a);
        scanf("%d", &b);

        bool* winning = (bool*) calloc(b + 1, sizeof(bool));

        winning[0] = false;

        for (int i = 1; i <= b; i++) 
        {
            bool prev_result = winning[i-1];

            if(prev_result == false)
            {
                winning[i] = true;
                continue;
            }

            for (int j = 1; j < n; j++) 
            {
                if (accepted_moves[j] > i) 
                    continue;

                winning[i] = !winning[i - accepted_moves[j]];

                if (winning[i])
                    break;
            }
        }

    
        for (int i = a; i <= b; i++) 
        {
            if (winning[i] == false)
                continue;

            out++;
        }

        free(winning);
        free(accepted_moves);
        printf("%d\n", out);
	}
}