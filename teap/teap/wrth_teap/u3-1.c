#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

char indent[10000];

typedef struct FIVE_POW {

	short num;
	short isPow;
	struct FIVE_POW* left;
	struct FIVE_POW* right;
    unsigned long long value;

} FIVE_TREE;

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

FIVE_TREE* newNode(short num, short isPow)
{
	FIVE_TREE* node = (FIVE_TREE*)malloc(sizeof(FIVE_TREE));

	node->num = num;
	node->left = NULL;
	node->right = NULL;
	node->isPow = isPow;

	return node;
}

FIVE_TREE* getDigitPos(short digit, FIVE_TREE* prev)
{
	FIVE_TREE* node = NULL;

	if (digit == 0)
	{
		if (prev->left == NULL)
		{
			node =
				prev->left = newNode(digit, 0);
		}
		else
			node = prev->left;
	}
	else
	{
		if (prev->right == NULL)
		{
			node =
				prev->right = newNode(digit, 0);
		}
		else
			node = prev->right;
	}
	return node;
}

FIVE_TREE* checkNumDigit(short digit, FIVE_TREE* prev)
{
    return digit == 0 ? prev->left : prev->right;
}

void addNumberToTree(FIVE_TREE* head, unsigned long long num)
{
	short one = 0;
	FIVE_TREE* prev = head;

	for (int i = sizeof(num) * 8 - 1; i >= 0; i--)
	{
		short result = (num >> i) & 1;

		if (result == 0 && one == 0)
			continue;

		if (result == 1 && one == 0)
		{
			one = 1;
			continue;
		}
		prev = getDigitPos(result, prev);
        prev->value = num;
		one = 1;
	}
	prev->isPow = 1;
}

int main()
{
	int result = 0;
	char buffer[50 + 2];

	FIVE_TREE* find = NULL;
	FIVE_TREE* head = newNode(1, 1);

    head->value = 1;
	
	for (int i = 1; i <= 25; i++)
	{
		unsigned long long fivePow = (unsigned long long)new_pow((double)5, (double)i);
		addNumberToTree(head, fivePow);
	}

	while (scanf("%s", buffer) > 0)
	{
		result = 0;

		for (int i = 0; i < strlen(buffer); i++)
		{

            if(buffer[i] == '0')
            {
                result = -1;
                break;
                // continue;
            }

            int checkPoint = -1;

            find = head;

		    for (int j = i + 1; j < strlen(buffer); j++)
		    {

		    	find = checkNumDigit(buffer[j] - 48, find);

		    	if (find == NULL)
		    		break;

		    	if (find->isPow == 1)
                    checkPoint = j;
		    }

		    if (checkPoint != -1)
		    {
                
                // for(int f = i; f <= checkPoint; f++)
                    // printf("%c", buffer[f]);

                // printf(" %d %d\n", i, checkPoint);

		    	i = checkPoint;
		    	result++;
		    }
            else
                result++;
        }
		printf("Normal: %d\n", result == 0 ? -1 : result);

        int prev_res = result;

        for (int i = strlen(buffer) - 1; i != -1; i--)
		{

            if(buffer[i] == '0')
                continue;


            int checkPoint = -1;

            find = head;

		    for (int j = i + 1; j < strlen(buffer); j++)
		    {

		    	find = checkNumDigit(buffer[j] - 48, find);

		    	if (find == NULL)
		    		break;

		    	if (find->isPow == 1)
                    checkPoint = j;
		    }

		    if (checkPoint != -1)
		    {
                result++;

                for(int f = i; f <= checkPoint; f++)
                    printf("%c", buffer[f]);

                printf(" | ", i, checkPoint);
                
                if(checkPoint == strlen(buffer) - 1)
                    result = 1;
            }
            else
                result++;
        }

        // if(prev_res != -1)
            // result = prev_res;


        printf("%d\n", result == 0 ? -1 : result);

		// printf("\nReversed: %d\n", result == 0 ? -1 : result);
	}

	return 0;
}


//


// 11111011111010111100001
// 1 | 1 | 1 | 1 | 1011111010111100001

