#include<stdio.h> 
#include<signal.h> 
  
void obsluz_signal (int sig)
{
    printf("Zachytil som signal %d\n", sig);
}


int main() 
{ 
    signal(SIGINT, obsluz_signal); 
    while (1) ;
    return 0; 
} 

