#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <signal.h>
#include <unistd.h>

void handler(int sig)
{
	printf("Dostal som signal: %s(%d)\n", strsignal(sig), sig);

	if (sig == SIGSEGV)
		exit(0);
}

int main()
{
	signal(SIGSEGV, handler);
	signal(SIGCHLD, handler);
	
	if (!fork())
		return 0;

	sleep(1);

	*(int *)NULL = 42;

	return 0;
}
