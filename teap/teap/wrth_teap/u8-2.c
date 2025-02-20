#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_ARRAY_SIZE 100
#define MAX_MATRIX_SIZE MAX_ARRAY_SIZE*4 + 2


typedef struct STACK_ELEMENT 
{
    int data;
    struct STACK_ELEMENT* next;
} STACK;


STACK* stack = NULL;
int static matrix[MAX_MATRIX_SIZE][MAX_MATRIX_SIZE];


void push(int data) 
{
    
    if (stack == NULL) 
    {

        stack = (STACK*) malloc(sizeof(STACK));
        stack->data = data;
        stack->next = NULL;

        return;
    }

    STACK* head = (STACK*) malloc(sizeof(STACK));

    head->data = data;
    head->next = stack;
    stack = head;
}


int pop() 
{

    int data;
    STACK* toPop;

    toPop = stack;
    data = toPop->data;
    stack = toPop->next;

    free(toPop);

    return data;
}


int BFS(int* prev) 
{

    int visited[MAX_MATRIX_SIZE] = {0};

    stack = NULL;
    visited[0] = 1;

    push(0);

    while (stack != NULL) 
    {

        int u = pop();

        for (int i = 0; i < MAX_MATRIX_SIZE; i++) 
        {

            if(matrix[u][i] == 0 || visited[i] == 1)
                continue;

            prev[i] = u;
            visited[i] = 1;

            if (i == MAX_MATRIX_SIZE - 1) 
                return 1;

            push(i);
        }
    }

    return 0;
}


int fordFulkerson() 
{

    int maxFlow = 0;
    int prev[MAX_MATRIX_SIZE] = {-1};

    while (BFS(prev)) 
    {

        int v;

        maxFlow++;
        v = MAX_MATRIX_SIZE - 1;

        while (v != 0) 
        {

            int u = prev[v];

            matrix[u][v] = 0;
            matrix[v][u] = 1;

            v = u;
        }
    }

    return maxFlow;
}

int main()
{
    int n;
    int f;
    int d;

    while(scanf("%d %d %d", &n, &f, &d) > 0)
    {

        for(int i = 0; i < n; i++)
        {
            int fi;
            int di;

            scanf("%d %d", &fi, &di);

            for(int j = 0, food = 0; j < fi; j++)
            {
                scanf("%d", &food);
                matrix[food][MAX_ARRAY_SIZE + 1 + i] = 1;
            }

            for(int j = 0, drink = 0; j < di; j++)
            {
                scanf("%d", &drink);
                matrix[MAX_ARRAY_SIZE * 2 + 1 + i][MAX_ARRAY_SIZE * 3 + drink] = 1;
            }
        }

        for(int i = 0; i < MAX_ARRAY_SIZE; i++)
        {
            matrix[0][1 + i] = 
            matrix[MAX_ARRAY_SIZE*3 + 1 + i][MAX_MATRIX_SIZE - 1] = 
            matrix[MAX_ARRAY_SIZE + 1 + i][MAX_ARRAY_SIZE*2 + 1 + i] = 1;
        }
        
        printf("%d\n", fordFulkerson());
        memset(matrix, 0, sizeof(matrix));
    }
    return 0;
}