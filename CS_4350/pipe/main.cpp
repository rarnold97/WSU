#include <sys/types.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <iostream>
#include <string>
#include <time.h>
#include <stdexcept>
#include <sys/wait.h>
#include <iomanip>

#define BUFFER_SIZE 100
#define NUM_ITEMS 100 

#define READ_END 0
#define WRITE_END 1

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

void producer(FILE *pipe_write_end)
{
    std::string producedFileItem ; 
    srand(time(NULL)) ; 

    for (int i = 0; i < NUM_ITEMS; i++)
    {   
        usleep(1); 
        producedFileItem = GetRandomFileID() ; 
        std::cout << "Producing item " << std::setw(3) << i+1 << " : " << producedFileItem << std::endl; 
        fprintf(pipe_write_end, "%s\n", producedFileItem.c_str());
    }

    fclose(pipe_write_end) ; 

    // force a newline to make output look neater for demonstration
    std::cout << "\n" ;

    exit(0) ; 
}

void consumer(FILE *pipe_read_end)
{
    char text[BUFFER_SIZE] ; 
    int success ; 
    unsigned int count = 1; 

    while(!feof(pipe_read_end))
    {
        success = fscanf(pipe_read_end, "%s\n", text) ; 
        std::string consumed_item = text ; 

        if (success)
            std::cout << "Consumed File ID item " << std::setw(3) << count << " : " << consumed_item << std::endl;
        else
            break ; 

        count++ ; 

    }

    fclose(pipe_read_end) ; 
    exit(0) ; 
}

int main()
{

    pid_t producer_id, consumer_id ; 
    int fd[2] ; 
    FILE *pipe_write_end, *pipe_read_end ; 

    if (pipe(fd) == -1)
    {
        throw std::system_error() ; 
    }

    pipe_read_end = fdopen(fd[READ_END], "r") ; 
    pipe_write_end = fdopen(fd[WRITE_END], "w") ; 

    producer_id = fork() ; 
    if (producer_id == 0)
    {
        //fclose(pipe_read_end);
        close(fd[READ_END]) ; 
        
        producer(pipe_write_end) ;  

        close(fd[WRITE_END]) ; 

    }

    consumer_id = fork() ; 
    if (consumer_id == 0)
    {
        //fclose(pipe_write_end) ; 
        close(fd[WRITE_END]) ; 

        consumer(pipe_read_end) ;

        close(fd[READ_END]) ;
    }
         

    fclose(pipe_read_end) ; 
    fclose(pipe_write_end) ; 

    wait(NULL);
    wait(NULL) ; 


    return 0 ; 
}