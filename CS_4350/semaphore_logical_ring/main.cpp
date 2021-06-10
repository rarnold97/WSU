#include "SharedResources.h"
#include "CircularQueue.h"

std::string GetRandomFileID()
{

    std::string fileArr[10] = {
        "10101010A,xml",
        "10101010B.xml",
        "20202020A.xml",
        "20202020B.xml",
        "30303030A.xml",
        "30303030B.xml",
        "40404040A.xml",
        "40404040B.xml",
        "50505050A.xml",
        "50505050B.xml"
    } ; 

    int index = rand() % 10 ; 

    return (fileArr[index]) ;
    
}

void producer()
{
    // random seed initiation for producing randomly selected file identifiers
    srand(time(NULL)) ; 

    // item declaration 
    std::string producedFileID; 

    for (int i = 0; i < NUM_DATA_ITEMS; i++)
    { 
        // produce item
        producedFileID = GetRandomFileID() ;

        // synchronize using semaphores
        sem_wait(&sem_empty) ; 
        // protect critical section
        mutex_lock.lock();

            /*critical section code, add next produced item to buffer */
            
            buffer[in] = producedFileID ; 
            in = (in + 1) % BUFFER_SIZE ; 

            std::cout <<"Producer Thread: Inserted Item -> "<< producedFileID << " at Item Number -> " << i + 1 << std::endl ; 
            prod_log <<"Producer Thread: Inserted Item -> "<< producedFileID << " at Item Number -> " << i + 1 << std::endl ; 

        mutex_lock.unlock(); 
        sem_post(&sem_full) ;

    }
}

void consumer()
{
    for (int j = 0; j < NUM_DATA_ITEMS ; j++)
    {
        // wait until buffer has empty spot 
        sem_wait(&sem_full) ;
        // protect critical section 
        mutex_lock.lock() ; 

            /* do critical section stuff here, i.e., consume the next item */
            std::string consumedFileName = buffer[out] ; 
            out = (out+1) % BUFFER_SIZE ; 
            
            std::cout<< "Consumer Thread: Removed Item -> "<< consumedFileName << " at item Number -> " << j + 1 << std::endl ; 
            cons_log<< "Consumer Thread: Removed Item -> "<< consumedFileName << " at item Number -> " << j + 1 << std::endl ; 

        mutex_lock.unlock() ;
        sem_post(&sem_empty) ;
    
    }
}

int main(int argc, char* argv[])
{

    if (argc!=1)
    {
        printf("usage - %s //no args", argv[0]) ; 
    }

    // setup semaphores
    sem_init(&sem_empty, 0, BUFFER_SIZE) ; 
    sem_init(&sem_full, 0, 0) ; 


    // open log files for data dumpting 
    prod_log.open("producer_log.txt") ; 
    cons_log.open("consumer_log.txt") ; 

    // initialize the process threads for the producer and consumer
    std::thread prod_thread(producer), cons_thread(consumer) ; 

    // activate the threads, let scheduler do its thing
    prod_thread.join() ; 
    cons_thread.join() ;

    // destroy the semaphores for housekeeping
    sem_destroy(&sem_empty) ; 
    sem_destroy(&sem_full) ; 

    // close the log file streams
    prod_log.close();
    cons_log.close();

    // pause console window
    //std::cin.get();

    return 0 ; 
}