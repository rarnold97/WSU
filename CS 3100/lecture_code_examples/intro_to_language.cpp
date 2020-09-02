//
// Created by root on 9/2/20.
//

#include "intro_to_language.h"

using namespace std ;

//LECTURE 1-3
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

int getValueInRange(int minV, int maxV)
{
    int value ;

    cout << "Enter a value in [" <<minV << "," << maxV << "]: ";
    cin >> value ;
    while(value<minV || value >maxV)
    {
        cout<< value << " is outside the valid range --try again" << endl;
        cout<< "Enter a value in [" <<minV << "," << maxV << "]: " ;
        cin >> value;
    }
    return value ;
}

//LECTURE 4

void getValueInRange(int& value, int minV, int maxV)
{
    cout << "Enter a value in [" <<minV << "," << maxV << "]: ";
    cin >> value ;

    while(value<minV || value >maxV)
    {
        cout<< value << " is outside the valid range --try again" << endl;
        cout<< "Enter a value in [" <<minV << "," << maxV << "]: " ;
        cin >> value;
    }

}

void swapByVal(int a, int b)
{
    int tmp = a ;
    a = b ;
    b = tmp ;

    cout<< "Inside swapByVal"<<setw(5)<<a<<setw(5)<<b<<endl;
}
void swapByRef(int& a, int& b)
{
    int tmp = a ;
    a = b;
    b = tmp;

    cout<<"inside swapByRef"<<setw(5) << a << setw(5) << endl ;
}