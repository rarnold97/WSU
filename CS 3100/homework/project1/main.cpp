#include <iostream>
#include <fstream>
//#include <vector>
//#include <sstream>
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
 * @fun main function, entry point to program assignment 1.
 * @return int 0 for success 1 for failure.
 */
int main(int argc, char *argv[]) {
    Menu choice ;
    Employee person ;
    //std::vector<Employee> people ;
    std::string filename ;

    // check to see if input arguments were provided to main
    if (argc>0)
    {
        filename = std::string(argv[0]) ;
    }
    else
    {
        filename = "inputs/Small-Database.txt" ;
    }

    do
    {
        choice = displayMenu() ;

        if (choice == INPUT_RECORD)
        {
            std::ofstream fileOut ;

            fileOut.open(filename, std::ios_base::app) ;

            std::cin >> person ;

            fileOut << person;

            fileOut.close() ;


        }
        else if (choice == INPUT_NUMBER_OF_RECORDS)
        {
            int nRecords ;

            while(true)
            {
                std::cout << "Enter the Number of Records.  Allowed Range: 1-99."<<std::endl;
                std::cin >> nRecords ;

                /// make sure a whole number was entered.
                if (nRecords % 1 != 0 )
                {
                    nRecords = (int)nRecords ;
                }

                if (nRecords <1 || nRecords > 99)
                {
                    std::cout << "Please enter a whole number within the range 1-99 : " <<std::endl;
                }
                else
                {
                    break ;
                }
            }

            std::ofstream fileOut ;
            fileOut.open(filename, std::ios_base::app) ;

            for (int i = 0 ; i < nRecords; i++)
            {
                Employee p ;
                std::cin >> p ;
                fileOut << p ;
                std::cout << p ;
                //people.push_back(p) ;
            }

            fileOut.close() ;
        }
        else if (choice == TWO_RECORDS_TEST_EMPLOYEE)
        {
            Employee p1, p2 ;

            std::cin >> p1 ;
            std::cin >> p2 ;

            if (p1 == p2)
            {
                std::cout<< "The two employees are the same/equal."<<std::endl;
            }
            else
            {
                std::cout<< "The two employees are NOT the same/equal."<<std::endl;
            }

        }
        else if (choice == TWO_RECORDS_TEST_ID)
        {
            Employee p1, p2, testEmployee ;

            std::cin >> p1 ;
            std::cin >> p2 ;

            if (p1<p2)
            {
                std::cout << "Employee: " << p1.getFirstName() << " " << p1.getLastName()
                << " has an ID number of " << p1.getID() << " Which is LESS than " <<
                "Employee: "<<p2.getFirstName() << " " << p2.getLastName() << " who has an ID number of: "
                <<p2.getID() << std::endl;
            }
            else
            {
                std::cout << "Employee: " << p1.getFirstName() << " " << p1.getLastName()
                << " has an ID number of " << p1.getID() << " Which is GREATER than " <<
                "Employee: "<<p2.getFirstName() << " " << p2.getLastName() << " who has an ID number of: "
                <<p2.getID() << std::endl;
            }

            /*
            std::ifstream fileIn ;
            fileIn.open(filename) ;
            std::string line ;
            std::vector<std::string> entries ;
            const char delim = ' ' ;

            while(fileIn)
            {
                std::getline(fileIn, line) ;
                // split the string using the delimiter " "
                std::stringstream data(line) ;
                std::string s ;
                while(std::getline(data,s, delim))
                {
                    entries.push_back(s) ;
                }
                testEmployee.setLastName(entries[0]) ;
                testEmployee.setFirstName(entries[1]) ;
                std::stringstream idStream(entries[2]) ;

                int id ;
                idStream >> id ;
                testEmployee.setID(id) ;

            }

             fileIn.close();
             */
        }
        else if (choice == INVALID_ENTRY)
        {
            std::cout<<"Please enter a valid option choice in the range: 0-4" << std::endl;
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
    std::cout << "1 - Read a number of employee records from database file, "
                 "then display to screen and write to output text file." << std::endl ;
    std::cout << "2 - Read two employee records from keyboard to test if they are equal." <<std::endl;
    std::cout << "3 - Read two employee records from keyboard to compare their ID numbers." << std::endl;
    std::cout << "4 - QUIT."<< std::endl;

    //read in user choice
    std::cin >> userChoice ;

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