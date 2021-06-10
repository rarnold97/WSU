#include <stdio.h>
#include <iostream>
#include <vector>
#include <string>
#include <queue>
//system related libs
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <mutex>

#define BUFFER_SIZE 10 

/**************
*/
// book material 


/* Data Structures */
// ----------------------------------------------
typedef struct{
    int pid ; 
    int C ; // priority that can be used for conditional waiting 
} process ; 

typedef struct{
    bool value;
    //struct process *list ; 
    std::queue<process *> list ; 

} binary_semaphore ; 

typedef struct{
    unsigned int value ;
    std::queue<process *> list ;  
} semaphore ;

//typedef binary_semaphore mutex ; 



// ----------------------------------------------








bool test_and_set(bool *target)
{
    bool rv = *target ; 
    *target = true ;
    return rv ; 
}

int compare_and_swap(int *value, int expected, int new_value)
{
    int temp = *value ; 

    if (*value == expected)
        *value = new_value ; 
    
    return temp ;
}

void wait(semaphore *S){
    S->value-- ; // negative implies processes are queued and waiting
    if (S->value < 0){
        // add this process to S->list
        // let p be some sort of process implementation
        S->list.push(p) ; 
        block(); // suspends process
    }
}

void signal(semaphore *S)
{
    S->value++ ; // positive implies process is ready 
    process* P = NULL; 
    if (S->value <= 0)
    {
        // remove process P from S->list ; 
        P = S->list.front();
        S->list.pop() ; 

        wakeup(P) ; // resumes execution of blocked process
    }
}


void producer_example()
{

    do 
    {
        // produce an item in next_produced
        wait(empty) ;
        wait(mutex) ;

        // ...........

        /* add next_produced to the buffer */

        // ...........

        signal(mutex) ; 
        signal(full) ;
    } while (true) ;

}


/* Buffer bounded Problem*/
// ----------------------

// shared data structures

unsigned int n = BUFFER_SIZE;
semaphore mutex{.value = 1};
semaphore empty{.value = n};
semaphore full{.value = 0}; 



// ----------------------