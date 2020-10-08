/*
CS 3100 Data Structures and Algorithms
Ryan Arnold
Dr.Meilin Liu
October. 12, 2020
Project 2: Array Based Stack
*/

#include <iostream>
#include <fstream>
#include "SStack.h"

// function prototypes
int readInputFile(SStack &stackIn, bool skip=false, std::string filename = "all.last.txt") ;
void skipLines(std::istream & is, size_t n, char delim) ;

int main() {
    int cap = 100 ;

    std::cout <<"-----Beginning of Stack Testing-----"<<std::endl ;

    //testing constructor
    SStack names(cap);
    std::cout<<"--> Stack Constructed"<<std::endl ;

    int linesRead = readInputFile(names) ;

    std::cout <<"--> Original Stack reading in "<< linesRead << " lines from file."<<std::endl;
    names.print() ;

    std::cout<<"--> Testing .push() with last name: ARNOLD" <<std::endl;
    names.push(std::string("ARNOLD")) ;
    names.print() ;

    std::cout<<"--> Testing .top()"<<std::endl;
    std::cout<<"    Top is: "<< names.top() <<std::endl ;

    std::cout<<"--> Testing .pop() to remove ARNOLD"<<std::endl;
    names.pop();
    names.print();

    std::cout<<"--> Testing .size() and .capacity()"<<std::endl;
    std::cout<<"    Stack size is "<<names.size()<<" with capacity of "
        <<names.getCapacity()<<std::endl ;

    std::cout<<"--> Testing .IsEmpty()"<<std::endl ;

    SStack tmpStack(100) ;
    int tmpLinesRead = readInputFile(tmpStack) ;
    for (int i=0; i<tmpLinesRead; i++){std::cout<<"    emptying stack..."<<std::endl; tmpStack.pop();}

    std::cout<<"    Result of .IsEmpty on empty stack: "<<tmpStack.IsEmpty()
        <<"\n    1-(true) 0-(false)"<<std::endl;

    std::cout<<"\n--> Testing copy Constructor"<<std::endl;
    SStack copiedNames(names);

    std::cout<<"original stack:"<<std::endl;
    names.print() ;
    std::cout<<"copied stack:"<<std::endl;
    copiedNames.print();

    std::cout<<"--> Testing equals() helper function between stack1 (names) and stack2 (copiedNames)"
        <<std::endl;

    std::cout<<"    result of equals() returns: "<<equals(names, copiedNames)<<
        "\n    1-(true) 0-(false)"<<std::endl;

    std::cout<<"--> Testing '+' operator overload (e.g., union function)"<<std::endl;
    std::cout<<"    First, read in to a new stack called moreNames, the next n names in the file"
        <<std::endl;

    SStack moreNames(cap);
    int moreLinesRead = readInputFile(moreNames, true);
    std::cout <<moreLinesRead <<" lines read into new stack"<<std::endl;

    SStack mergedStack = names + moreNames ;

    std::cout<<"\nnew Stack (mergedStack) data:"<<std::endl ;
    std::cout<<"-> new capacity - " << mergedStack.getCapacity()<<std::endl ;
    std::cout<<"-> new top - " << mergedStack.size()<<std::endl;
    std::cout<<"-> data (see below):" << std::endl;
    mergedStack.print();

    std::cout <<"-----End of Stack Testing-----"<<std::endl;
    return 0;
}

int readInputFile(SStack &stackIn, bool skip, std::string filename)
{
    int n_names ;

    while(true)
    {
        try
        {
            std::cout << "Enter the number of names to be read that is less than max capacity: "
                << stackIn.getCapacity() <<std::endl;

            std::cin >> n_names ;

            if (n_names > stackIn.getCapacity()) {throw n_names;} else {break;} ;
        }
        catch(int n_names)
        {
            std::cout<<n_names<<" is greater than " << stackIn.getCapacity() << "! try agian..." <<std::endl ;
        }
    }

    std::string line ;
    std::ifstream fin ;
    fin.open(filename) ;

    if (skip) skipLines(fin,n_names,'\n') ;
    int n_lines = 0 ;

    while(n_lines < n_names && fin)
    {
        std::getline(fin, line) ;
        stackIn.push(line) ;
        n_lines++ ;
    }

    fin.close();
    return n_names ;
}

void skipLines(std::istream & is, size_t n, char delim)
{
    // declare the size of the file based on input
    size_t i = 0 ;
    while(i++ < n)  // skip n lines
    {
        // skip number of lines with a buffer of 80 characters
        // will stop skipping at newline delimiter
        is.ignore(256, delim) ;
    }
}