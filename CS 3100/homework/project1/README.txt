CS 3100
Data Structures and Algorithms
Ryan Arnold
Dr. Meilin Liu
Date: 9/17/20

Project 1

Instructions:

This program logs employee info to a database text file.  The main pieces of employee information include:

-firstname
-lastname
-ID number

Input is primarily read in through the keyboard, but there are options to read entries from the database text file
depending on the input.  Data can be written to the database file and compared.

When running the code, make sure the "Small-Database.txt" file is added in the projects working directory.
Otherwise, place the file in the build folder where the built executable is deployed.

The main entry point is through main.cpp, while the employee onject module is contained in Employee.cpp

Upon compiling and running the program, a menu will appear with the following user-entered options:

0- Reads employee record from the keyboard and tests if they are the same.  Displays on screen and writes to text file.
    -> this will read in the entry from the keyboard and append it to the database file

1- Read a specified number of employees from the keyboard and enter them to the text file at the same time 
    -> writes each employee to the database based on a number: n from 1-99

2- Reads two employee records from the keybaord and tests if they are the same.
    -> user enters employee info and the program compares lastname, firstname, and ID numbers

3- Reads two employees from the input file and prints which one has a greater ID number
    -> Reads adjacent employee pairs from the file.  Will read all employees in the same while loop.
       Detects when eof is reached, and if the main loop is still executing, then the pointer will restart at the beginning of the file.
4- Quit
    -> exits the main control loop and terminates the program.

