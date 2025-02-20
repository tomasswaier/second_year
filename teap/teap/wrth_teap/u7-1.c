#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char arr[10][11];
int result[10][1024][10];

int solve(int x, int y, int z, int k, int n, int m) 
{
    if (z == k)
        return 1;

    if (x == n)
        return 0;

    if (result[x][y][z] != -1)
        return result[x][y][z];

    int combinations;
    combinations = solve(x + 1, y, z, k, n, m);

    for (int i = 0; i < m; i++) 
    {
        if(((y >> i) & 1) == 0 && arr[x][i] == 'Y')
            combinations += solve(x + 1, y | (1 << i), z + 1, k, n, m);
    }
    return result[x][y][z] = combinations;
}

int main() 
{
    int k;
    int n;
    int m;

    while (scanf("%d %d %d", &k, &n, &m) > 0) 
    {
        for (int i = 0; i < n; i++) 
            scanf("%10s", arr[i]);

        memset(result, -1, sizeof(result));
        printf("%d\n", solve(0, 0, 0, k, n, m));
    }
    return 0;
}