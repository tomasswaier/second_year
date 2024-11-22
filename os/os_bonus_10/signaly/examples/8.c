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
atomic_int number_of_signals_atomic;

void handler(int sig)
{
	dprintf(1, "Dostal som signal: ");
	dprintf(1, "%s(%d)", strsignal(sig), sig);
	dprintf(1, "\n");
	number_of_signals++;
	atomic_fetch_add(&number_of_signals_atomic, 1);
}

int main()
{
	sigset_t mask;
	sigfillset(&mask);
	assert(sigaction(SIGUSR1, &(struct sigaction){.sa_handler = handler, .sa_flags = SA_NODEFER, .sa_mask = mask,}, NULL) == 0);
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
	printf("Zachytil som %d signalov\n", number_of_signals_atomic);


	return 0;
}
