#include <iostream>
#include <cstdlib>
#include <iomanip>

//template for IO_example
void IO_example() ;
void IO_manip() ;

int main() {
    std::cout << "Hello, World!" << std::endl;
    /*|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/
    //IO_example() ;
    IO_manip() ;
    /*|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/
    return EXIT_SUCCESS;
}

void IO_example() {
    int i, j ;
    std::cout << "enter value of x" << std::endl ;
    std::cin >> i ;

    for (j=0; j<i; j++)
    {
        std::cout<< "Welcome to CS 3100" <<std::endl ;
    }
}

void IO_manip(){
    int x = 201 ; 
    double y = 342.123456789 ; 
    std::cout << "(" << std::setw(20) << x << ")" << std::endl;
    std::cout << std::setprecision(8);
    std::cout<<"("<<std::setw(20)<<y<<")"<<std::endl;
    std::cout<<std::fixed ;
    std::cout<<std::setprecision(2);
    std::cout<<"("<<std::setw(20)<<y<<")"<<std::endl;
    std::cout<<std::scientific;
    std::cout<<std::setprecision(2);
    std::cout<<"("<<std::setw(20)<<y<<")"<<std::endl;
}