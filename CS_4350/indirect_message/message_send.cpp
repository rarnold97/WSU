#include "message_headers.h"


int main(void)
{

    message_body body ; // data structure containing body
    char buffer[MSG_SIZE] ; // buffer to hold message and send
    int msgid, msgid2 ; // mailbox ids
    long int msg_to_rcv ; 
    std::string tmp_filename ; // randomly generated filename 
    int tmpItem ; 
    size_t buff_len  ; 

    msgid = msgget((key_t)KEY, 0666 | IPC_CREAT) ; // open and create system message queue
    //msgid = msgget((key_t)KEY2, 0666 | IPC_CREAT) ; // send

    if (msgid == -1)
    {
        //error state, warn user
        fprintf(stderr, "msget failed with error: %d\n", errno) ; 
        exit(EXIT_FAILURE) ; 
    }

    srand(time(NULL)) ; // for random number generation

    body.msg_type = 1 ; // type of data mailbox should expect

    std::cout << "Sending Messages ..." << std::endl ; 
    std::cout << std::endl ; // tidy output stream

    // loop through 100 data items
    for (int i=0; i<NUM_ITEMS; i++)
    {
        usleep(3) ; // sleep to ensure randomness
        //tmp_filename = GetRandomFileID() ; // produce data item 
        tmpItem = GenerateRandInt() ; 
        sprintf(body.mtext, "%d", tmpItem) ; 
        //strcpy(body.mtext, tmp_filename.c_str()) ; // convert to C style

        buff_len = strlen(body.mtext) + 1 ; // record length of string for buffer

        if (msgsnd(msgid, (void *)&body, buff_len, 0) == -1) // attempt to send data item
            {
                // failed to send, warn user
                fprintf(stderr, "msgsnd failed\n") ; 
                exit(EXIT_FAILURE) ; 
            }
        else
        {
            // data item sent successful, notify user each item sent in the order they were sent
            std::cout << "Sending Item " << std::setw(3) << i+1 <<": " << body.mtext << std::endl ; 
        }
    }

    // send and end indicator to tell the consumer process to stop
    //strcpy(body.mtext, "end") ; 

    //terminator integer value
    strcpy(body.mtext, "end") ; 

    buff_len = strlen(body.mtext) + 1 ;

    // send stop message
    if (msgsnd(msgid, (void *)&body, buff_len, 0) == -1)
        {   
            // failed to send stop message, warn user and exit
            fprintf(stderr, "msgsnd failed\n") ; 
            exit(EXIT_FAILURE) ; 
        }

    // let user know that the producer is finished generating and sending data
    std::cout << std::endl ; // tidy output stream
    std::cout << "finished sending messages" << std::endl ; 

    // everything went smoothly, exit program normally
    exit(EXIT_SUCCESS) ; 
     
}