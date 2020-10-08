//FILE: SStack.h
//CREATED BY: Meilin Liu, Fall 2020

//CONTENTS: Declares Class SStack, with data members, contructors and member function prototypes
//If you want, you can make minor changes to this header file

/*
CS 3100 Data Structures and Algorithms
Ryan Arnold
Dr.Meilin Liu
October. 12, 2020
Project 2: Array Based Stack
*/

#ifndef _StackClass_
#define  _StackClass_

#include <cstdlib>
#include <string>
#include <iostream>

using namespace std;

typedef std::string element;

class SStack
{
        enum {DEF_CAPACITY = 100};
    public:
            // Constructor
            SStack( int cap = DEF_CAPACITY);
            // Copy Constructor
            SStack(const SStack& s );
            ~SStack( ); //destructor

            // The member function push: Precondition:  the stack is not full.
            void push ( const std::string s);

            // The member function pop: Precondition:  the stack is not empty.
            string pop ();

            // The member function top: Precondition:  the stack is not empty.
            string top () const;

            bool IsEmpty () const;

            //printing all the elements in the stack
            void print() const;

            int size() const;
            int getCapacity() const;


    private:
            int Capacity; // Capacity is the maximum number of items that a stack can hold
            std::string* DynamicStack;
            int used; // How many items are stored in the stack
};


		// NONMEMBER FUNCTIONS for the stack class
		// Postcondition: The stack returned is the union of s1 and s2.
		SStack operator +(const SStack& s1, const SStack& s2);
		
		//Return true if the two stacks contain exactly the same element values in the same order. 
        bool equals(const SStack& s1, const SStack& s2);

#endif
