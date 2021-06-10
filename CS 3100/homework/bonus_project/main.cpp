/*
CS 3100 Data Structures and Algorithms
Ryan Arnold
Dr.Meilin Liu
November. 9, 2020
Project 3: Linked Sorted List
*/

#include <iostream>
#include <fstream>
#include <string>
#include "HashTable.h"

using namespace std;

int readInputFile(HashTable& ht, std::string filename);
enum menuOptions { INSERT, DELETE, SEARCH, LOGFILE, SUMMARY, QUIT };
menuOptions displayMenu();

int main()
{
    HashTable HT(88001); 
    std::string filename = "all.last.txt"; 
    int linesRead = readInputFile(HT, filename); 

    bool quit = false; 
    menuOptions choice; 
    std::ofstream fileOut;

    std::string keyChoice;

    while (!quit)
    {
        choice = displayMenu(); 

        switch (choice)
        {
            case INSERT:
                 
                std::cout << "Enter a last name to store in Hash Table: "; 
                std::cin >> keyChoice;
                HT.insert(keyChoice);
                std::cout<<std::endl; 
                break;

            case DELETE:
                std::cout << "Enter a last name to remove from Hash Table: ";
                std::cin >> keyChoice; 
                HT.deleteEntry(keyChoice);
                std::cout << std::endl;
                break;
            case SEARCH:
                std::cout << "Enter a last name to search for in Hash Table: ";
                std::cin >> keyChoice;
                HT.search(keyChoice);
                std::cout << std::endl;
                break;
            case LOGFILE:
                std::cout << "Writing Log File ..." << std::endl;
                fileOut.open("all_last_hash_table.txt"); 
                HT.saveLogFile(fileOut);
                fileOut.close();
                std::cout << "Finished writing file!" << std::endl;
                break;
            case SUMMARY:
                HT.printSummary();
                break;
            case QUIT:
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
    menuOptions choice;
    int choiceNumber;
    bool doMenu = true; 

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
            std::cout << choiceNumber << " is not a valid option, try again ..." << std::endl;
        }
        
    }
    return choice; 
}