/*
CS 3100 Data Structures and Algorithms
Ryan Arnold
Dr.Meilin Liu
December. 1, 2020
Project 4: Binary Search Tree
*/


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

    BinaryTreeNode * left; // left child
    BinaryTreeNode * right; // right child
    BinaryTreeNode * par; // parent node

    //operator overloads for comparisons of ID
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
    // pointer to employee element
    Employee* getElementPtr()
        {
        Employee* E = &person;
        return E;
        }
    // set a new employee element
    void setElement(Employee E)
        {person = Employee(E);}
    // set left child
    void setLeft(BinaryTreeNode* btn)
        {left = btn;}
    // set right child
    void setRight(BinaryTreeNode* btn)
        {right = btn;}
    // set parent node
    void setParent(BinaryTreeNode* btn)
        {par = btn;}
    // we know that it is the root if there is no parent node
    bool isRoot() const
        { return par == NULL; }
    // return the ID key, which is an integer
    int getKey() const
        {return person.getID();}
};

#endif
