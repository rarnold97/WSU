#include <iostream>
#include <fstream>
//#include <vector>
#include <sstream>
#include "Empolyee.h"

//function prototypes
/**
 * @enum MENU for the menu options.
 * @return returns an enum that defines the menu options.
 */
 enum Menu {INPUT_RECORD, INPUT_NUMBER_OF_RECORDS, TWO_RECORDS_TEST_EMPLOYEE,
         TWO_RECORDS_TEST_ID, QUIT, INVALID_ENTRY };

/**
*
* @return returns the user selected option for the menu items.
*/
Menu displayMenu() ;

/**
 * skips n lines from the beginning of a text file so that another employee can be tested.
 *
 */
void skipLines(std::istream &is, size_t n, char delim) ;

/**
 * @fun main function, entry point to program assignment 1.
 * @return int 0 for success 1 for failure.
 */
int main() {
    // initialize variables
    Menu choice ;
    Employee person ;
    std::string filename ;
    bool moreThanOneRun = false ;

    // set the name of the input file
    filename = "Small-Database.txt" ;

    // filestream operators
    std::fstream fileIn ;
    std::ofstream fileOut;

    //counter for the lines of the data base files
    size_t lineCtr = 0 ;

    do {
        // make the output look nice by inserting a newline
        // makes the terminal less cluttered
        if (moreThanOneRun) {
            std::cout << "\n";
        } else {
            moreThanOneRun = true;
        }

        // instantiate the enum for the menu choices
        choice = displayMenu();

        // switch the choice based on what the user selects based on an enum
        switch (choice)
        {
            case INPUT_RECORD :  // input a record, write to database
            {
                // open the file to insert the employees
                fileOut.open(filename, std::ios_base::app);

                std::cin >> person;

                fileOut << person;

                fileOut.close();

                break;
            }
            case INPUT_NUMBER_OF_RECORDS : // variable number of records, write to file
            {
                int nRecords;

                // break while loop after condition
                while (true) {
                    // prompt user
                    std::cout << "Enter the Number of Records.  Allowed Range: 1-99." << std::endl;
                    std::cin >> nRecords;

                    /// make sure a whole number was entered.
                    if (nRecords % 1 != 0) {
                        nRecords = (int) nRecords;
                    }
                    // define bounds of number of records
                    if (nRecords < 1 || nRecords > 99)
                    {
                        std::cout << "Please enter a whole number within the range 1-99 : " << std::endl;
                    }
                    else
                    {
                        break; // exit the while
                    }
                }

                // open the file and append to it
                fileOut.open(filename, std::ios_base::app | std::ios_base::out);

                for (int i = 0; i < nRecords; i++)
                {
                    Employee p;
                    std::cin >> p;
                    fileOut << p ;
                    std::cout << p;
                }

                fileOut.close();

                break;
            }
            case TWO_RECORDS_TEST_EMPLOYEE :
            {
                Employee p1, p2;

                std::cin >> p1;
                std::cin >> p2;

                if (p1 == p2) {
                    std::cout << "The two employees are the same/equal." << std::endl;
                } else {
                    std::cout << "The two employees are NOT the same/equal." << std::endl;
                }

                break;
            }
            case TWO_RECORDS_TEST_ID :
            {
                Employee p1, p2, testEmployee;
                char nLine ;

                fileIn.open(filename.c_str()) ;
                skipLines(fileIn, lineCtr,'\n') ;

                std::string first1, first2, last1, last2, idNum1, idNum2 ;
                if (!(fileIn >> last1))
                    {
                        //clear file buffer
                        fileIn.clear();
                        //go back to beginning of file
                        fileIn.seekg(0);
                        lineCtr =0 ;

                        fileIn>>last1 ;
                    }

                fileIn >> first1 ;
                fileIn >> idNum1 ;

                if (!(fileIn >> last2))
                {
                    //clear file buffer
                    fileIn.clear();
                    //go back to beginning of file
                    fileIn.seekg(0);
                    lineCtr =0 ;

                    fileIn >> last2 ;
                }

                fileIn >> first2 ;
                fileIn >> idNum2 ;

                fileIn >> nLine ;

                lineCtr++ ;

                std::stringstream id1_str(idNum1);
                std::stringstream id2_str(idNum2);

                int id1, id2 ;

                id1_str >> id1 ;
                id2_str >> id2 ;

                p1.setLastName(last1);
                p1.setFirstName(first1);
                p1.setID(id1) ;

                p2.setLastName(last2) ;
                p2.setFirstName(first2);
                p2.setID(id2) ;

                if (p1 < p2) {
                    std::cout << "Employee: " << p1.getFirstName() << " " << p1.getLastName()
                              << " has an ID number of " << p1.getID() << " Which is LESS than " <<
                              "Employee: " << p2.getFirstName() << " " << p2.getLastName()
                              << " who has an ID number of: "
                              << p2.getID() << std::endl;
                } else {
                    std::cout << "Employee: " << p1.getFirstName() << " " << p1.getLastName()
                              << " has an ID number of " << p1.getID() << " Which is GREATER than " <<
                              "Employee: " << p2.getFirstName() << " " << p2.getLastName()
                              << " who has an ID number of: "
                              << p2.getID() << std::endl;
                }

                fileIn.close() ;
                break;
            }
            case INVALID_ENTRY :
            {
                std::cout << "Please enter a valid option choice in the range: 0-4" << std::endl;
            }

        }
    }
    while (choice != QUIT) ;

    return 0;
}

Menu displayMenu()
{
    //instantiate the menu choice enum
    Menu choice ;
    int userChoice;

    // display menu items
    std::cout << "Please enter one of the following options: " << std::endl;
    std::cout << "0 - Enter an employee record and write to text file." << std::endl;
    std::cout << "1 - Read a number of employee records from keyboard, "
                 "then display to screen and write to output database file." << std::endl ;
    std::cout << "2 - Read two employee records from keyboard to test if they are equal." <<std::endl;
    std::cout << "3 - Read two employee records from database file to compare their ID numbers." << std::endl;
    std::cout << "4 - QUIT."<< std::endl;

    //read in user choice
    std::cin >> userChoice ;

    // enumerate choice based on entered number
    switch(userChoice)
    {
        case 0:
            choice = INPUT_RECORD ;
            break;
        case 1:
            choice = INPUT_NUMBER_OF_RECORDS;
            break;
        case 2:
            choice = TWO_RECORDS_TEST_EMPLOYEE;
            break ;
        case 3:
            choice = TWO_RECORDS_TEST_ID;
            break;
        case 4:
            choice = QUIT;
            break;
        default:
            choice = INVALID_ENTRY ;
            break;
    }
    // return what the user selected.
    return choice ;
}


void skipLines(std::istream & is, size_t n, char delim)
{
    // declare the size of the file based on input
    size_t i = 0 ;
    while(i++ < n)  // skip n lines
    {
        // skip number of lines with a buffer of 80 characters
        // will stop skipping at newline delimiter
        is.ignore(80, delim) ;
    }
}