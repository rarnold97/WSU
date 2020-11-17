////Employee.h provided by Dr. Meilin Liu, and you can modify it if you want.


#ifndef _BinaryTreeNode_
#define _BinaryTreeNode_
#include <iostream>
#include <cstdlib>
#include "Employee.h"

using namespace std;

class BinaryTreeNode{

protected:
	Employee person;

public:
    explicit BinaryTreeNode(Employee &newEmployee ,  BinaryTreeNode * rightptr = NULL, BinaryTreeNode *leftptr = NULL,
                            BinaryTreeNode *parent = NULL);
	// copy constructor
	explicit BinaryTreeNode(BinaryTreeNode* btn);
    explicit BinaryTreeNode(const BinaryTreeNode* btn);
    ~BinaryTreeNode();

    BinaryTreeNode * left;
    BinaryTreeNode * right;
    BinaryTreeNode * par;

    //operator overloads for comparisons
    Employee& operator*()
        { return person; }
    bool operator==(BinaryTreeNode* btn) const
        {return this->person == btn->person;}
    bool operator<(BinaryTreeNode* btn) const
        {return this->person.getID() < btn->person.getID();}
    // cant just use ! < because we are not allowing duplicates
    bool operator>(BinaryTreeNode* btn)
        {return this->person.getID() > btn->person.getID(); }
    //read only access
    const Employee& getElement() const
        {return person;}
    Employee* getElementPtr()
        {
        Employee* E = &person;
        return E;
        }
    void setElement(Employee E)
        {person = Employee(E);}
    void setLeft(BinaryTreeNode* btn)
        {left = btn;}
    void setRight(BinaryTreeNode* btn)
        {right = btn;}
    void setParent(BinaryTreeNode* btn)
        {par = btn;}
    bool isRoot() const
        { return par == NULL; }
    bool isExternal() const
        { return (left == NULL && right == NULL); }
    bool isInternal() const
        {return !isExternal();}
    int getKey() const
        {return person.getID();}
};

#endif
