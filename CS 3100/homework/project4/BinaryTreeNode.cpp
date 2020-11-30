/*
CS 3100 Data Structures and Algorithms
Ryan Arnold
Dr.Meilin Liu
December. 1, 2020
Project 4: Binary Search Tree
*/

#include "BinaryTreeNode.h"
/*
Employee person;

BinaryTreeNode * left;
BinaryTreeNode * right;
BinaryTreeNode * par;

BinaryTreeNode(Employee &newEmployee,  BinaryTreeNode * rightptr = NULL, BinaryTreeNode *leftptr = NULL);
// copy constructor
BinaryTreeNode(BinaryTreeNode* btn);
~BinaryTreeNode();
 */

// default constructor
BinaryTreeNode::BinaryTreeNode(Employee &newEmployee,  BinaryTreeNode* rightptr, BinaryTreeNode* leftptr, BinaryTreeNode* p)
{
    person = newEmployee;
    right = rightptr ;
    left = leftptr ;
    par = p ;
}

BinaryTreeNode::BinaryTreeNode(BinaryTreeNode * btn)
{
    person = btn->person ;
    right = btn->right ;
    left = btn->left ;
    par = btn->par ;
}

BinaryTreeNode::BinaryTreeNode(const BinaryTreeNode *btn)
{
    person = btn->person;
    right = btn->right;
    left = btn->left;
    par = btn->par;
}

BinaryTreeNode::~BinaryTreeNode()
{
    //delete left;
    //delete right;
}