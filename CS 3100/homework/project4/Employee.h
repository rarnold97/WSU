/*
CS 3100 Data Structures and Algorithms
Ryan Arnold
Dr.Meilin Liu
December. 1, 2020
Project 4: Binary Search Tree
*/

#ifndef _Employee_
#define _Employee_

#include <cstdlib>
#include <iostream>
#include <string>

using namespace std;

class Employee{

public:
    Employee(int IdNum = 11111, std::string last = " lastname", std::string first = "firstname");
    Employee(const Employee &person);
    ~Employee() = default;
    void setFirstName(string first);
    void setLastName(string last);
    void setID(int IdNum);
    inline int getID() const {return ID;}
    inline std::string getFirstName() const {return firstname;}
    inline std::string getLastName() const {return lastname;}

    friend std::istream& operator>>(std::istream &ins, Employee &person);

private:
    int ID;
    string lastname;
    string firstname;


};

std::ostream& operator<<(std::ostream &outs, const Employee &person);
bool operator==(const Employee& p1, const Employee& p2); // test if two employees are the same.
bool operator<(const Employee& p1, const Employee& p2); // test if one employee's ID is less than another employee's.

#endif