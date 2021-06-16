#include "message_headers.h"

int main(void)
{
    int msgid, msgid2 ; 
    message_body body ; 
    long int msg_to_rcv = 1 ; 
    size_t buff_len ; 

    // first setup message queue

    msgid = msgget((key_t)KEY, 0666 | IPC_CREAT) ; // receive
    //msgid2 = msgget((key_t)KEY, 0666 | IPC_CREAT) ; // send

    if (msgid == -1 )
    {
        fprintf(stderr, "msgget failed with error %d\n", errno) ; 
        exit(EXIT_FAILURE) ; 
    }

    // messages are retrieved from the queue until an end indicator is reached
    // then the message queue is deleted

    std::cout << "Loading Messages ..." << std::endl ; 
    std::cout << std::endl ; // tidy output stream

    while(true)
    {

        if (msgrcv(msgid, (void *)&body, sizeof(body), msg_to_rcv, 0)==-1)
        {
            fprintf(stderr, "msgrcv failed with error %d\n", errno) ; 
            exit(EXIT_FAILURE) ; 
        }
        
        if (strncmp(body.mtext, "end", 3)== 0)
        {
            break ; 
        }

        std::cout << "Producer Wrote: " << body.mtext << std::endl ; 

    }

    std::cout << std::endl ; //tidy output stream
    std::cout << "All messages received" << std::endl ; 

    if (msgctl(msgid, IPC_RMID, 0) == -1)
    {
        fprintf(stderr, "msgctl(IPC_RMID) failed\n") ; 
        exit(EXIT_FAILURE) ; 
    }

    exit(EXIT_SUCCESS) ; 

}