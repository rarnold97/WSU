/*
CS 3100 Data Structures and Algorithms
Ryan Arnold
Dr.Meilin Liu
October. 12, 2020
Project 2: Array Based Stack
*/

#include "SStack.h"
//element refers to a typedef, which is std::string in this case.

//error handling objects
class StackException{
public:
    StackException(const string& err)
        :errMsg(err){}
    string getError(){return errMsg;}

private:
    string errMsg ;
};

class StackEmpty : public StackException{
public:
    StackEmpty(const string& err)
            :StackException(err){}
};

class StackFull : public StackException{
public:
    StackFull(const string& err)
        :StackException(err){}
};

// helper functions
bool SStack::IsEmpty() const {return (used < 0) ;}

int SStack::size() const {return (used + 1) ;}

int SStack::getCapacity() const {return Capacity ;}

void SStack::print() const
{
    for (int i = used ; i >= 0 ; i--)
    {
        std::cout << DynamicStack[i] << std::endl ;
    }
    //add an extra end line to look neater
    std::cout<<std::endl ;
}
// end helper functions

//constructor function
SStack::SStack(int cap)
{
    used = -1 ; //tracker variable
    Capacity = cap; //capacity
    DynamicStack = new element[cap] ; //dynamically allocated array of strings
}

// copy constructor
SStack::SStack(const SStack& s ):
    Capacity(s.getCapacity()),
    DynamicStack(new string[Capacity]),
    used(s.size()-1)
{
    for (int i = 0; i < size(); i++)
    {
        DynamicStack[i] = s.DynamicStack[i];
    }
}

//destructor
SStack::~SStack()
{
    delete [] DynamicStack; //manage dynamic memory
}

// pushing function
void SStack::push(const std::string s)
{
    // check for a full stack
    if (size() == Capacity) throw StackFull("Trying to push to full stack!");

    DynamicStack[++used] = s ;
}

// popping function
string SStack::pop()
{
    if (IsEmpty()) throw StackEmpty("Trying to pop an empty stack!") ;
    --used ;
    return DynamicStack[used+1] ;
}

// top function

element SStack::top() const
{
    if (IsEmpty()) throw StackEmpty("Trying to take top of empty stack!");
    return DynamicStack[used] ;
}

// nonmember functions

SStack operator +(const SStack& s1, const SStack& s2)
{
    SStack tmpStack1 = SStack(s1) ;
    SStack tmpStack2 = SStack(s2) ;
    SStack reverseStack1 = SStack(tmpStack1.getCapacity());
    SStack reverseStack2 = SStack(tmpStack2.getCapacity());

    // need to reverse the stacks in order to follow last in first out principle
    while(!tmpStack1.IsEmpty()) reverseStack1.push(tmpStack1.pop()) ;
    while(!tmpStack2.IsEmpty()) reverseStack2.push(tmpStack2.pop()) ;

    int newCap = s1.getCapacity() + s2.getCapacity() ;
    SStack stackOut = SStack(newCap);

    while(!reverseStack1.IsEmpty()){stackOut.push(reverseStack1.pop()) ;}
    while(!reverseStack2.IsEmpty()){stackOut.push(reverseStack2.pop()) ;}

    return stackOut ;
}

bool equals(const SStack& s1, const SStack& s2)
{
    SStack tmpStack1 = SStack(s1) ;
    SStack tmpStack2 = SStack(s2) ;

    while (!tmpStack1.IsEmpty() && !tmpStack2.IsEmpty())
    {
        if (tmpStack1.top() == tmpStack2.top()) {
            tmpStack1.pop();
            tmpStack2.pop();
        }
        else
        {
            break ;
        }
    }

    return (tmpStack1.IsEmpty() && tmpStack2.IsEmpty()) ;
}


