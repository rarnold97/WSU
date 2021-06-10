#ifndef SHAREDRESOURCES_H
#define SHAREDRESOURCES_H

#include <thread>
#include <mutex>
#include <semaphore.h>
#include <iostream>
#include <cstdio>
#include <sys/types.h>
#include <unistd.h>
#include <pthread.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string>
#include <time.h>
#include <vector>

#include "CircularQueue.h"

#define BUFFER_SIZE 10 
#define NUM_DATA_ITEMS 100 

//filenames for semaphores
#define SEM_PRODUCER_FNAME "/myfull"
#define SEM_CONSUMER_FNAME "/myempty"

//mutexes, and semaphores 
std::mutex mutex_lock; 

sem_t sem_empty, sem_full ; 

//CircQueue<std::string> buffer(BUFFER_SIZE) ; 

int in = 0 ; 
int out = 0 ; 
std::string buffer[BUFFER_SIZE] ; 

#endif