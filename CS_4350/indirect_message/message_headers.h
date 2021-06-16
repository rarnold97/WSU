#include <iostream>
#include <sys/types.h>
#include <sys/msg.h>
#include <sys/ipc.h>
#include <string.h>
#include <string>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <time.h>
#include <sys/wait.h>
#include <iomanip>

#define KEY 1234
#define KEY2 2234
#define MSG_SIZE 128
#define NUM_ITEMS 100


struct mymsg 
{
    long int msg_type ; 
    char mtext[MSG_SIZE] ; 
} ;
typedef struct mymsg message_body; 