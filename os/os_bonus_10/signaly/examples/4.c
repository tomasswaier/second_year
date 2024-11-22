#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <signal.h>
#include <unistd.h>

#define PGALIGN(addr)  ((typeof(addr))(((uintptr_t)addr)&(~((uintptr_t)getpagesize()-1))))

void handler(int sig, siginfo_t *info, void *_)
{
	printf(">>>>>>>>>>>>>>>>>>>>>>>>\n");
	printf("Signal handler\n");
	printf("Dostal som signal: %s(%d)\n", strsignal(sig), sig);
	printf("Error on address %p\n", info->si_addr);
	printf("Alokujem stranku %p\n", PGALIGN(info->si_addr));
	printf("<<<<<<<<<<<<<<<<<<<<<<<<<\n");
	assert((void *)mmap(PGALIGN(info->si_addr), getpagesize(), PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_FIXED, -1, 0) != (void *)-1);
}

int main()
{
	assert(sigaction(SIGSEGV, &(struct sigaction){.sa_sigaction = handler, .sa_flags = SA_NODEFER|SA_SIGINFO,}, NULL) == 0);
	int i;
	int *addr;
	for (i = 0; i < 100; ++i) {
//		if (i)
//		    addr = (int *)(rand()+getpagesize());
//		else
//		    addr = NULL;

		addr = (int *)rand();
		printf("Adresa: %p\n", addr);
		printf("Pred: %d\n", *addr);
		*addr = 42;
		printf("Po: %d\n", *addr);
	}

	return 0;
}
