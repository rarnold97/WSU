#include <iostream>
#include <fstream>
#include "LinkedSortedList.h"

using namespace std ;

void skipLines(std::istream & is, size_t n, char delim);
int readInputFile(LinkedSortedList &lsl, bool skip, std::string filename);


int main() {
    string filename = "all.last.txt" ;

    LinkedSortedList list1 ;
    int nread1 = readInputFile(list1, false, filename) ;
    list1.print();

    LinkedSortedList list2;
    int nread2 = readInputFile(list2, true, filename) ;
    list2.print();

    return 0;
}


int readInputFile(LinkedSortedList &lsl, bool skip, std::string filename)
{
    int n_names ;

    while(true)
    {
        try
        {
            std::cout << "Enter the number of names to be read: "<<std::endl;
            std::cin >> n_names ;
            // 88799 is the max number of lines in the file
            if (n_names > 88799) throw(n_names);
            break;
        }
        catch(int n_names)
        {
            std::cout<<n_names<<" is greater than file capacity try agian..." <<std::endl ;
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
        lsl.insert(line) ;
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