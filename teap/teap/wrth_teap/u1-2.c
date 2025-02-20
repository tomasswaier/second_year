#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>

int sortCondition(const void* a, const void* b) { return (*(int*)a - *(int*)b); }

int main()
{
	int n = 0, x = 0;

	while (scanf("%d", &n) > 0)
	{
		int result = 0, size = 0, counter = 0;
		int* arr = (int*)calloc(n, sizeof(int));

		for (int i = 0; i < n; i++)
		{
			scanf("%d", &x);

			if (x >= 200)
			{
				result++;
				continue;
			}
			arr[size++] = x;
		}

		arr = realloc(arr, (size) * sizeof(int));
		qsort(arr, size, sizeof(int), sortCondition);

		int* taken = calloc(size, size * sizeof(int));

		for (int i = size - 1; i != -1; i--)
		{

			for (int j = counter; j < i; j++)
			{
				if (taken[j] == 1)
					continue;

				if (arr[i] + arr[j] <= 300)
				{
					result++;
					counter++;
					taken[i] = taken[j] = 1;
					break;
				}
			}
		}

		for (int i = 0; i < size; i++)
		{
			if (taken[i] == 0)
				result++;
		}

		free(arr);
		free(taken);

		printf("%d\n", result);
	}
}