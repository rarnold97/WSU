#include <stdio.h>
#include <iostream>
#include <vector>
#include <string>

//lecture material

//focus on producer consumer problem
#define BUFFER_SIZE 10

//start by defining shared data 
int temp1 = 0 ; // points to the next free buffer element
int *in = &temp1 ; 

int temp2 = 0  ;
int *out = &temp2; // points to first full buffer element

int count = 0; // counts the number of data items in the buffer
unsigned int N = BUFFER_SIZE ; 

typedef struct
{
    /* data */
    std::string str ; 

} item;


// Template of a process P 
// -----------------------
/*
some code here ...

wait(s);
    // critical section

signal(s);
    // remainder section
*/
// ----------------------



/* Bounded-Buffer Implementations of Producer-Consumer problem */

void Producer()
{
    while(true)
    {
        /* produce and item in next_produced */

        wait(empty) ; /*to wait until there is an empty buffer element */
        wait(mutex) ; /*to access buffer[in] and in exclusively */

        /* add the item in next_produced to buffer[in] */

        in = (in + 1) % N ; 
        signal(mutex) ; /*to release buffer[in] and in */

        signal(full) ; /*to increment to the number of filled buffer elements */ 
    }
}


void Consumer()
{
    while(true)
    {
        wait(full); /*to wait until there is a filled buffer element */
        wait(mutex); /*to access buffer[out] to next_consumed */

        /*remove an item from buffer[out] to next_consumed */

        out = (out+1) % N ; 
        signal(mutex) ; /*to release buffer[out] and out */

        signal(empty1); /* to increment the number of empty buffer elements */

        /* consume the item in next_consumed */
    }
}








