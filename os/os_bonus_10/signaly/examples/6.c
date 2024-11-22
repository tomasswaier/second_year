#include <assert.h>
#include <errno.h>
#include <stdatomic.h>
#include <stdio.h>
#include <semaphore.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>
#include <unistd.h>

int number_of_signals;
sem_t guard;

void handler(int sig)
{
        sem_wait(&guard);
	dprintf(1, "Dostal som signal: ");
	dprintf(1, "%s(%d)", strsignal(sig), sig);
	dprintf(1, "\n");
	number_of_signals++;
        sem_post(&guard);
}

int main()
{
	assert(sigaction(SIGUSR1, &(struct sigaction){.sa_handler = handler, .sa_flags = SA_NODEFER,}, NULL) == 0);
	int i, j;
	sem_init(&guard, 0, 1);

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
