#include <stdio.h>
#include <limits.h>
#include <stdlib.h>
#include <string.h>

typedef struct FIVE_POW 
{
	short num;
	short isPow;
	struct FIVE_POW* left;
	struct FIVE_POW* right;
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
			node = prev->left = newNode(digit, 0);

		else
			node = prev->left;
            
        return node;
	}

	if (prev->right == NULL)
		node = prev->right = newNode(digit, 0);
	else
		node = prev->right;

	return node;
}

FIVE_TREE* checkNumDigit(short digit, FIVE_TREE* prev) { return digit == 0 ? prev->left : prev->right; }

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
		one = 1;
	}
	prev->isPow = 1;
}

int findSubPowInTree(FIVE_TREE* node, char buffer[], int start, int end)
{
    int checkPoint = -1;

    for (int i = start; i < end; i++)
    {

        node = checkNumDigit(buffer[i] - 48, node);

        if (node == NULL)
            break;

        if (node->isPow == 1)
            checkPoint = i;
    }

    return checkPoint;
}

int findPowInTree(int start, int end, int result, FIVE_TREE* head, char buffer[])
{
    for (int i = start, checkPoint = -1; i < end; i++, checkPoint = -1)
    {

        if(buffer[i] == '0')
        {
            result = -1;
            break;
        }

        checkPoint = findSubPowInTree(head, buffer, i + 1, end);

        if (checkPoint != -1)
            i = checkPoint;
        
        result++;
    }
    return result;
}

int main()
{
	int result = 0;
	char buffer[50 + 2];

	FIVE_TREE* find = NULL;
	FIVE_TREE* head = newNode(1, 1);
	
	for (int i = 1; i <= 25; i++)
	{
		unsigned long long fivePow = (unsigned long long)new_pow((double)5, (double)i);
		addNumberToTree(head, fivePow);
	}

	while (scanf("%s", buffer) > 0)
	{
		result = -1;
        int best = INT_MAX;

        for(int t = 0; t < strlen(buffer); t++)
        {
            result = 0;

            if(buffer[t] == '0')
                continue;

            result = findPowInTree(t, strlen(buffer), 0, head, buffer);

            if(result < 1)
                continue;

            result = findPowInTree(0, t, result, head, buffer);

            if(result > 0 && result < best)
                best = result;
        }

        if(best != INT_MAX)
            result = best;

        printf("%d\n", result == 0 ? -1 : result);
        
	}
	return 0;
}