#include "server_client_headers.h"


int main()
{
    // declare constants 
    int client, server ; 
    bool exitFlag = false ; 
    char buffer[BUFFER_SIZE] ; 

    // initialize a server socket address structure
    struct sockaddr_in server_address ; 
    socklen_t addrSize;

    client = socket(AF_INET, SOCK_STREAM, 0) ;
    
    if (client < 0)
    {
        std::cout<< "Error establishing connection." << std::endl;
        exit(1) ; 
    }

    std::cout << "Server Socket connection created..." << std::endl; 

    server_address.sin_family = AF_INET ; 
    server_address.sin_addr.s_addr = htons(INADDR_ANY) ; 
    server_address.sin_port = htons(PORT_NUMBER) ; 

    //attempting to bind socket
    if (bind(client, (struct sockaddr*)&server_address, sizeof(server_address)) < 0)
    {
        std::cout<<" Error binding socket..." << std::endl ; 
        exit(1) ; 
    }

    addrSize = sizeof(server_address) ;
    std::cout << "Searching for clients..." << std::endl;

    // listening socket, wait for client
    listen(client, 1) ; 
    
    server = accept(client, (struct sockaddr*)&server_address, &addrSize) ; 

    if (server < 0)
    {
        std::cout << "Error on accepting..." << std::endl ; 
        exit(1) ; 
    }

    while (server > 0 )
    {
        // send confirmation to the client that the server accepted the client
        strcpy(buffer, "[Server] Server Connected...\n") ; 
        send(server, buffer, sizeof(buffer), 0) ; 

        std::cout << "Connected with client!" << std::endl; 
        std::cout << std::endl ; 
        std::cout << "Client Message(s): " << std::endl
        <<"_______________________" << std::endl; 

        do{

            recv(server, buffer, sizeof(buffer), 0);
            if (*buffer == '#')
            {
                exitFlag = true ; 
            }
            else
            {
                std::cout<<"[Client]: " << buffer << std::endl;
            }

        } while(!exitFlag) ;

        strcpy(buffer, "[Server] Job Finished...\n") ; 
        send(server, buffer, sizeof(buffer), 0) ; 

        std::cout<< std::endl ; 
        std::cout << "Job Finished!" << std::endl;
        std::cout << "Connection terminated..." << std::endl;
        std::cout << "Exiting Program ..." << std::endl; 
        exitFlag = false; 
        exit(1) ; 
    }

    close(client) ; 
    return 0 ;
}