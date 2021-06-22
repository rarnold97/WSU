#include "server_client_headers.h"
#include "rng.h"


int main()
{
    int client, server ; 
    int addrSize ; 
    bool exitFlag = false;
    char buffer[BUFFER_SIZE] ;  
    int producedItem ; 

    //std::string fileEntry ; 

    struct sockaddr_in server_address ; 

    // init socket

    client = socket(PF_INET, SOCK_STREAM, 0) ; 

    if (client < 0)
    {
        std::cout << "Error creating socket..." << std::endl;
        exit(1);
    }

    // connect to the server port 
    addrSize = sizeof(server_address) ; 
    server_address.sin_family = AF_INET ; 
    server_address.sin_port = htons(PORT_NUMBER) ; 
    inet_pton(AF_INET, "127.0.0.1", &server_address.sin_addr) ; 

    // connecting socket server
    std::cout << "Connecting to server..." << std::endl ; 

    if (connect(client, (struct sockaddr*)&server_address, addrSize) != 0)
    {
        std::cout << "client: connection operation failed, unable to connect to server port..." <<std::endl;
        exit(1) ; 
    }
    else
    {
        recv(client, buffer, sizeof(buffer), 0) ; 
        std::cout << "Connection confirmed" << std::endl ; 
        std::cout << buffer << std::endl;

        srand(time(NULL)) ; 
        for (int i = 0 ; i < NUM_ITEMS; i++)
        {
            usleep(1) ; 
            //fileEntry = GetRandomFileID() ; 
            producedItem = GenerateRandInt() ; 
            sprintf(buffer, "%d", producedItem) ; 
            std::cout<< "Producing Item "<< std::setw(3) << i+1 << ": " << buffer << std::endl;
            //strcpy(buffer, fileEntry.c_str()) ; 
            send(client, buffer, sizeof(buffer), 0 ) ; 
        }

        // for neatness
        std::cout<<std::endl;

        *buffer = '#' ;  
        send(client, buffer, sizeof(buffer), 0) ; 

        recv(client, buffer, sizeof(buffer), 0) ; 
        std::cout<< buffer ;

        std::cout << "Connection terminated..."<<std::endl;
        std::cout << "Exiting program ..." <<std::endl;

        close(client) ; 
        return 0 ; 

    }
    
}