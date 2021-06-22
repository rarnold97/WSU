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
#include "rng.h"

#define KEY 1234 // define mailbox key for sending and receiving messages through the system
//#define KEY2 2234
#define MSG_SIZE 128 // define a message buffer size
#define NUM_ITEMS 100 // prescribe number of data items to communicate
#define MESSAGE_END 999

/**
 * message data packet structure
 */
struct mymsg 
{
    long int msg_type ; // flag/id to identify to system what message type is being passed
    //char mtext[MSG_SIZE] ; // actual message contents, passing strings in this case
    char mtext[10]; 
} ;
typedef struct mymsg message_body; 