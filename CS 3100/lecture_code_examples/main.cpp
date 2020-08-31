#include <iostream>
#include <cstdlib>
#include <iomanip>
#include <fstream>
#include <cassert>
#include <string>

//template for IO_example
void IO_example() ;
void IO_manip() ;
void read_write_textFiles() ;
void assert_test();

using namespace std ;

int main() {
    std::cout << "Hello, World!" << std::endl;
    //IO_example() ;
    //IO_manip() ;
    read_write_textFiles() ;
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

void read_write_textFiles()
{
    ifstream input;
    ofstream output;

    input.open("inputs/inputData.txt");

    assert (!input.fail()) ;

    output.open("outputs/OutputData.txt");

    assert(!output.fail()) ;

    output<<fixed<<setprecision(2);

    double x ;
    int linectr = 1 ;
    while(input>>x)
    {
        output << x << endl ;
        cout<<"read line "<< linectr <<endl;

        linectr++ ;
    }
    cout<<"finished reading file."<<endl;

    input.close();
    output.close();
}

void assert_test()
{
    int i = 10 ;
    assert(i >5) ;
    cout<<"next bit of code, test passed"<<endl;

}