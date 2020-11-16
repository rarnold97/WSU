//
// Created by ryanm on 11/12/2020.
//

#include "BinarySearchTree.h"
#include <sstream>

using namespace std;

int main()
{
    //read entries from database file
    int nRecords;
    // break while loop after condition
    while (true) {
        // prompt user
        std::cout << "Enter the Number of Records.  Allowed Range: 20-50." << std::endl;
        std::cin >> nRecords;

        /// make sure a whole number was entered.
        if (nRecords % 1 != 0) {
            nRecords = (int) nRecords;
        }
        // define bounds of number of records
        if (nRecords < 20 || nRecords > 50)
        {
            std::cout << "Please enter a whole number within the range 20-50 : " << std::endl;
        }
        else
        {
            break; // exit the while
        }
    }

    //Create a Binary Search Tree Object
    BinarySearchTree bsTree;


    string filename = "Small-Database.txt" ;
    char nLine ;

    fstream fileIn ;
    fileIn.open(filename.c_str()) ;

    Employee E ;
    int ctr = 0 ;

    while (ctr < nRecords)
    {
        string first, last, idNum;
        fileIn>>first;
        fileIn>>last;
        fileIn>>idNum;
        fileIn>>nLine;
        //create string stream object to convert to integer
        std::stringstream idNum_stream(idNum) ;

        //convert to integer
        int id ;
        idNum_stream>>id ;

        E.setLastName(last);
        E.setFirstName(first);
        E.setID(id) ;

        bsTree.insert(E) ;

        ctr++;
    }

    //begin testing methods

    //show results of tree build
    bsTree.print() ;
    cout<<endl;

    //add another employee record from keyboard
    Employee E_keyboard ;
    std::cin >> E_keyboard ;

    bsTree.insert(E_keyboard);
    bsTree.print() ;
    cout<<endl;


}