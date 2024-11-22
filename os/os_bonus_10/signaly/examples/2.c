#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <signal.h>
#include <unistd.h>

void handler(int sig)
{
	printf("Dostal som signal: %s(%d)\n", strsignal(sig), sig);
}

int main()
{
	int i;
	for (i = 1; i <= SIGSYS; ++i)
		signal(i, handler);

	printf("Zabi ma!\n");
	while (1)
		sleep(1);

	return 0;
}
