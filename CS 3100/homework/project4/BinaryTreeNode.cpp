//
// Created by ryanm on 11/12/2020.
//

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
BinaryTreeNode::BinaryTreeNode(Employee &newEmployee,  BinaryTreeNode* rightptr, BinaryTreeNode* leftptr)
{
    person = newEmployee;
    right = rightptr ;
    left = leftptr ;
}

BinaryTreeNode::BinaryTreeNode(BinaryTreeNode * btn)
{
    person = btn->person ;
    right = btn->right ;
    left = btn->left ;
}

BinaryTreeNode::BinaryTreeNode(const BinaryTreeNode *btn)
{
    person = btn->person;
    right = btn->right;
    left = btn->left;
}