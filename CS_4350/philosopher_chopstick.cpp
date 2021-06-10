#include <iostream>

typedef struct{
    int value;
    struct process *list ; 
} semaphore ; 

semaphore chopstick[5] ; /*and each chopstick[i] initialized to 1 */

// structure of Philospher i 
// use one semaphore per chopstick
// deadlock occurs when all 5 philosophers grab the left chopstick at the same time 

void Philosopheri()
{
    while(true)
    {
        wait(chopstick[i]) ; /* to grab the left chopstick */
        wait(chopstick[(i+1)%5]) ; /* to grab the right chopstick */

            /* eat for a while */

        signal(chopstick[i]) ; /* to release the left chopstick */
        signal(chopstick[(i+1)%5]) ; /* to release the right chopstick */

            /* think for  a while */

    }
}

