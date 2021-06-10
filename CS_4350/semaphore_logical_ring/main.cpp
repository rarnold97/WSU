#include "SharedResources.h"
#include "CircularQueue.h"


void producer_fun()
{
    sem_wait(sem_empty) ; 
    // prevent race conditions 
    mutex_lock.lock();

    /*critical section code, add next produced item to buffer */
    std::cout <<"cuck"<<std::endl ;

    mutex_lock.unlock(); 

    sem_post(sem_full) ;
}

void consumer_fun()
{
    sem_wait(sem_full) ;

    mutex_lock.lock() ; 
    /* do critical section stuff here, i.e., consume the next item */
    std::cout<< "gulp!" <<std::endl ; 
    mutex_lock.unlock() ;

    sem_post(sem_empty) ;
}

int main(int argc, char* argv[])
{
if (argc!=1)
{
    printf("usage - %s //no args", argv[0]) ; 
}

// setup semaphores
sem_unlink(SEM_CONSUMER_FNAME) ; 
sem_unlink(SEM_PRODUCER_FNAME) ;

sem_empty = sem_open(SEM_CONSUMER_FNAME, O_CREAT, 0644, BUFFER_SIZE);
if (sem_empty == SEM_FAILED){
    perror("sem_open/consumer") ; 
    exit(EXIT_FAILURE) ; 
}

sem_full = sem_open(SEM_PRODUCER_FNAME , O_CREAT, 0644, 0);
if (sem_full == SEM_FAILED)
{
    perror("sem_open/consumer");
    exit(EXIT_FAILURE);
}

// initialize the process threads for the producer and consumer
std::thread prod_thread(producer_fun), cons_thread(consumer_fun) ; 

// activate the threads, let scheduler do its thing
prod_thread.join() ; 
cons_thread.join() ;

sem_close(sem_empty);
sem_close(sem_full) ; 

return 0 ; 
}