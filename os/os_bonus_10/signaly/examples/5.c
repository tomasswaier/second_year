#include <assert.h>
#include <errno.h>
#include <stdatomic.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>
#include <unistd.h>

int number_of_signals;

void handler(int sig)
{
	//dprintf(1, "Dostal som signal: ");
	//dprintf(1, "%s(%d)", strsignal(sig), sig);
	//dprintf(1, "\n");
	number_of_signals++;
}

int main()
{
	assert(sigaction(SIGUSR1, &(struct sigaction){.sa_handler = handler, .sa_flags = SA_NODEFER,}, NULL) == 0);
	int i, j;

	for (i = 0; i < 100; ++i) {
		if (!fork()) {
			sleep(1);
			for (j = 0; j < 100; ++j) {
				printf("posielam signal\n");
				assert(kill(getppid(), SIGUSR1) == 0);
			}
			return 0;
		}
	}


	while (wait(NULL) != -1 || errno != ECHILD)
	{ ; }

	printf("Zachytil som %d signalov\n", number_of_signals);


	return 0;
}
