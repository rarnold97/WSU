#include "message_headers.h"


std::string GetRandomFileID()
{

    std::string fileArr[10] = {
        "AAAA,xml",
        "BBBB.xml",
        "CCCC.xml",
        "DDDD.xml",
        "EEEE.xml",
        "FFFF.xml",
        "GGGG.xml",
        "HHHH.xml",
        "IIII.xml",
        "JJJJ.xml"
    } ;

    int index = rand() % 10 ;

    return (fileArr[index]) ;
}


int main(void)
{

    message_body body ;
    char buffer[MSG_SIZE] ; 
    int msgid, msgid2 ; 
    long int msg_to_rcv ; 
    std::string tmp_filename ; 
    size_t buff_len  ; 

    msgid = msgget((key_t)KEY, 0666 | IPC_CREAT) ; // receive
    //msgid = msgget((key_t)KEY2, 0666 | IPC_CREAT) ; // send

    if (msgid == -1)
    {
        fprintf(stderr, "msget failed with error: %d\n", errno) ; 
        exit(EXIT_FAILURE) ; 
    }

    srand(time(NULL)) ; 

    body.msg_type = 1 ;

    std::cout << "Sending Messages ..." << std::endl ; 
    std::cout << std::endl ; // tidy output stream

    for (int i; i<NUM_ITEMS; i++)
    {
        usleep(3) ; 
        tmp_filename = GetRandomFileID() ; 
        strcpy(body.mtext, tmp_filename.c_str()) ; 

        buff_len = strlen(body.mtext) + 1 ; 

        if (msgsnd(msgid, (void *)&body, buff_len, 0) == -1)
            {
                fprintf(stderr, "msgsnd failed\n") ; 
                exit(EXIT_FAILURE) ; 
            }
        else
        {
            std::cout << "Sending Item " << std::setw(3) << i+1 <<": " << tmp_filename << std::endl ; 
        }
    }

    strcpy(body.mtext, "end") ; 

    buff_len = strlen(body.mtext) + 1 ;

    if (msgsnd(msgid, (void *)&body, buff_len, 0) == -1)
        {
            fprintf(stderr, "msgsnd failed\n") ; 
            exit(EXIT_FAILURE) ; 
        }

    std::cout << std::endl ; // tidy output stream
    std::cout << "finished sending messages" << std::endl ; 

    exit(EXIT_SUCCESS) ; 
     
}