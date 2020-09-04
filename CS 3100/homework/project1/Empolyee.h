//Employee.h provided by Dr. Meilin Liu in Fall 2020, and you can modify it if you want.

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
    ~Employee();
    void setFirstName(string first);
    void setLastName(string last);
    void setID(int IdNum);
    int getID() const;
    std::string getFirstName() const;
    std::string getLastName() const;

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