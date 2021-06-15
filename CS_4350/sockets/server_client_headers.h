#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <unistd.h>
#include <iostream>
#include <netinet/in.h>
#include <string.h>
#include <arpa/inet.h>
#include <string>
#include <time.h>
#include <iomanip>

#define BUFFER_SIZE 128
#define PORT_NUMBER 15000
#define NUM_ITEMS 100