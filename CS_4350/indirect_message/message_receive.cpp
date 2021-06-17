#include "message_headers.h"

int main(void)
{
    int msgid, msgid2 ; // mailbox message ids
    message_body body ; // data structure holding message
    long int msg_to_rcv = 1 ; 
    size_t buff_len ; 

    // first setup message queue

    msgid = msgget((key_t)KEY, 0666 | IPC_CREAT) ; // receive
    //msgid2 = msgget((key_t)KEY, 0666 | IPC_CREAT) ; // send

    if (msgid == -1 )  // handle errors and notify user
    {
        fprintf(stderr, "msgget failed with error %d\n", errno) ; 
        exit(EXIT_FAILURE) ; 
    }// message type to receive from sender

    // loop until all items have been taken off the queue
    while(true)
    {
        // attempt to read the system message queue
        if (msgrcv(msgid, (void *)&body, sizeof(body), msg_to_rcv, 0)==-1)
        {
            // error state, warn user
            fprintf(stderr, "msgrcv failed with error %d\n", errno) ; 
            exit(EXIT_FAILURE) ; 
        }
        
        // check to see if end of message indicator has been reached
        if (strncmp(body.mtext, "end", 3)== 0)
        {
            // exit main loop
            break ; 
        }

        // print message sent over by producer
        std::cout << "Producer Wrote: " << body.mtext << std::endl ; 

    }
// message type to receive from sender
    {
        // removal operation failed, warn user
        fprintf(stderr, "msgctl(IPC_RMID) failed\n") ; 
        exit(EXIT_FAILURE) ; 
    }

    // everything went smoothly, exit normally
    exit(EXIT_SUCCESS) ; 

}