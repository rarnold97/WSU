#include <stdio.h>
#include <stdlib.h>
#include <time.h>


inline int GenerateRandInt()
{	
	// return random integer between 1 and 100
	return rand() % 100 + 1; 
}
