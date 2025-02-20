#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

double new_pow(double base, double exponent) 
{
    double result = 1.0;
    while (exponent > 0) 
    {
        result *= base;
        exponent--;
    }
    return result;
}

int extract(size_t number, int len, int left, int right) { return (number / (int)new_pow(10, right)) % (int)new_pow(10, len - left - right);  }


int main() 
{

    int target;
    char num_str[11];

    while (scanf("%10s %d", num_str, &target) > 0) 
    {

        int result = INT_MAX;
        long x = atol(num_str);
        int len = strlen(num_str);


        for (int i = 0, power = new_pow(2, len); i < power; i++) 
        {

            int out = 0;
            int ones = -1;
            int previous = 0;

            // CHATGPT helped me with this part

            for (int j = 1; j < len + 1; j++) 
            {

                if ((i >> (len - j)) & 1) 
                {
                    out += extract(x, len, previous, len - j);
                    
                    ones++;
                    previous = j;
                }
            }

            if (previous != len) 
            {
                ones++;
                out += extract(x, len, previous, 0);
            }

            if (out == target && ones < result) 
                result = ones;
        }

        if(result == INT_MAX)
            printf("IMPOSSIBLE\n");

        else
            printf("%d\n", result);

    }
    return 0;
}