/**
 * @author Ryan Arnold
 * CS 3100 : Data Structures and Algorithms
 * Dr. Meilin Liu
 * 17 September 2020
 * Programming Assignment #1
 */

#include <utility>

# include "Employee.h"

/// Default Constructor
Employee::Employee(int IdNum, std::string last, std::string first)
{
    ID = IdNum ;
    lastname = std::move(last) ;
    firstname = std::move(first) ;
}
/// Copy Constructor
Employee::Employee(const Employee &person)
{
    this->ID = person.ID ;
    this->lastname = person.lastname ;
    this->firstname = person.firstname ;
}

/// Getters and Setters.
void Employee::setFirstName(string first){firstname = std::move(first);}
void Employee::setLastName(string last) {lastname = std::move(last);}
void Employee::setID(int IdNum) {ID = IdNum;}

/// operator overloading

/**
 * @brief allows the STL library to print employee objects to the screen.
 * @param outs outputstream (i.e., cout)
 * @param person the employee instance.
 * @return returns the STL output stream object.
 */
std::ostream& operator<<(std::ostream &outs, const Employee &person)
{
    outs << person.getID() << " " << person.getLastName() << " " <<
        person.getFirstName() << std::endl;

    return outs ;
}
/**
 * @brief checks to see if the objects have equal values (rather than addresses).
 * @param p1 employee 1
 * @param p2 employee 2
 * @return returns if the two are equal or not (true or false).
 */
bool operator==(const Employee& p1, const Employee& p2)
{
    return p1.getID() == p2.getID()
    && p1.getLastName() == p2.getLastName()
    && p1.getFirstName() == p2.getFirstName() ;
}

/**
 * @brief checks to see if person 1's id number is less than person 2's
 * @param p1 employee object 1.
 * @param p2 employee object 2.
 * @return returns if the p1 id number is less than p2 (true or false).
 */
bool operator<(const Employee& p1, const Employee& p2)
{
    return p1.getID() < p2.getID() ;
}

/**
 * @brief the STL insertion operator is a friend to allow modification of the employee object attributes.
 * @param ins STL insertion operator
 * @param person employee object instance
 * @return returns the STL insertion object
 */
std::istream& operator>>(std::istream &ins, Employee &person)
{
    std::cout<<"Enter Employee ID: " ;
    ins >> person.ID ;
    std::cout<<std::endl;
    std::cout<<"Enter Employee's Last Name: " ;
    ins>>person.lastname ;
    std::cout<<std::endl;
    std::cout<<"Enter Employee's First Name: ";
    ins>>person.firstname ;

    return ins ;
}
