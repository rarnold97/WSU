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
    BinaryTreeNode(Employee &newEmployee ,  BinaryTreeNode * rightptr = NULL, BinaryTreeNode *leftptr = NULL);
	// copy constructor
	BinaryTreeNode(BinaryTreeNode* btn);
    BinaryTreeNode(const BinaryTreeNode* btn);
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
    void setLeft(BinaryTreeNode* btn)
        {left = btn;}
    void setRight(BinaryTreeNode* btn)
        {right = btn;}
    void setParent(BinaryTreeNode* btn)
        {par = btn;}
    bool isRoot()
        { return this->par == NULL; }
    bool isExternal()
        { return this->left == NULL && this->right == NULL; }
    bool isInternal()
        {return !isExternal();}
};

#endif
