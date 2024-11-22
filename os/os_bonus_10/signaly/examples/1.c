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
	signal(SIGCONT, handler);


	printf("Posielam si signal SIGSTOP\n");
	assert(kill(getpid(), SIGSTOP) == 0);
	printf("Koncim\n");
	return 0;
}
