/*
CS 3100 Data Structures and Algorithms
Ryan Arnold
Dr.Meilin Liu
December. 4, 2020
Bonus Project: Hash Table
*/

#include <iostream>
#include <fstream>
#include <string>
#include "HashTable.h"

using namespace std;

// helper function to read data into hash table 
int readInputFile(HashTable& ht, std::string filename);
//enum to clarify the menu options
enum menuOptions { INSERT, DELETE, SEARCH, LOGFILE, SUMMARY, QUIT };
// helper function to display menu and collect menu choice from the user 
menuOptions displayMenu();

int main()
{
    HashTable HT(88001); // defaulting to prime number of hash buckets
    // set filename to match input file
    std::string filename = "all.last.txt"; 
    // read input file to the hash table 
    int linesRead = readInputFile(HT, filename); 
    // control variable
    bool quit = false; 
    menuOptions choice; 
    std::ofstream fileOut;
    // variable to allow user to enter a key
    std::string keyChoice;

    while (!quit)
    {
        choice = displayMenu(); // collect choice from the user 

        switch (choice)
        {
            case INSERT:
                // have user insert ID to hash table
                std::cout << "Enter a last name to store in Hash Table: "; 
                std::cin >> keyChoice;
                HT.insert(keyChoice);
                std::cout<<std::endl; 
                break;

            case DELETE:
                // delete element from hash table 
                std::cout << "Enter a last name to remove from Hash Table: ";
                std::cin >> keyChoice; 
                HT.deleteEntry(keyChoice);
                std::cout << std::endl;
                break;
            case SEARCH:
                // search for entry in hash table 
                std::cout << "Enter a last name to search for in Hash Table: ";
                std::cin >> keyChoice;
                HT.search(keyChoice);
                std::cout << std::endl;
                break;
            case LOGFILE:
                // save a log file of hash table data
                std::cout << "Writing Log File ..." << std::endl;
                fileOut.open("all_last_hash_table.txt"); 
                HT.saveLogFile(fileOut);
                fileOut.close();
                std::cout << "Finished writing file!" << std::endl;
                break;
            case SUMMARY:
                // print summary of hash table metrics 
                HT.printSummary();
                break;
            case QUIT:
                // quit the main event loop 
                quit = true;
                break;
            default:
                std::cout << "Invalid option chosen ... Exiting Program!" << std::endl;
                // error encountered
                return 1;
        }

    }
	// program terminates successfully
	return 0; 
}

int readInputFile(HashTable& ht, std::string filename)
{
    std::string line;
    std::ifstream fin;
    fin.open(filename);

    int n_lines = 0;
    // read line by line from data file and insert in a hash table object 
    while (std::getline(fin, line))
    {
        ht.insert(line);
        n_lines++;
    }

    fin.close();
    return n_lines;
}

menuOptions displayMenu()
{
    // display menu options to screen and collect user input 

    //enum used to record the choice of the user 
    menuOptions choice;
    int choiceNumber;
    bool doMenu = true; // control variable 
    // loop until user enters a valid entry
    while (doMenu)
    {
        std::cout << "Please Enter one of the following options:" << std::endl;
        std::cout << std::endl; 
        std::cout << "1 - Insert New Entry via Keyboard." << std::endl;
        std::cout << "2 - Delete an Entry." << std::endl;
        std::cout << "3 - Search for an Entry." << std::endl;
        std::cout << "4 - Save Table to log File." << std::endl; 
        std::cout << "5 - Print Hash Table Summary." << std::endl;
        std::cout << "0 - Exit." << std::endl;
        std::cout << std::endl;

        std::cin >> choiceNumber;
        // seitch based on selection and break the loop after unless invalid option is entered
        switch (choiceNumber)
        {
        case 1:
            choice = INSERT; 
            doMenu = false;
            break;
        case 2:
            choice = DELETE;
            doMenu = false;
            break;
        case 3:
            choice = SEARCH;
            doMenu = false;
            break; 
        case 4:
            choice = LOGFILE;
            doMenu = false; 
            break;
        case 5:
            choice = SUMMARY;
            doMenu = false;
            break;
        case 0:
            choice = QUIT; 
            doMenu = false;
            break;
        default:
            // keep looping and have the user try again 
            std::cout << choiceNumber << " is not a valid option, try again ..." << std::endl;
        }
        
    }
    return choice; // return selction
}