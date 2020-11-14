//
// Created by ryanm on 11/12/2020.
//

#include "BinarySearchTree.h"

/*
BinarySearchTree();	//constructor
~BinarySearchTree();	//destructor
bool clear(); // using postorder tree traversal
bool insert(Employee & emp);
Employee* search(int k);
bool remove(int k);
bool print(); // using inorder tree traversal
bool save(); // using inorder tree traversal

*/
typedef BinaryTreeNode Node;
typedef BinarySearchTree::Iterator Iterator;


int BinarySearchTree::BSTsize(){return size;}

Node* BinarySearchTree::getRoot() const {return root;}

void BinarySearchTree::expandExternal(Employee& E, Node* btn){
    //Node* v = p.v;
    if (E.getID() < btn->getElement().getID())
    {
        btn->left = new Node(E);
    }
    else if (E.getID() > btn->getElement().getID())
    {
        btn->right = new Node(E) ;
    }
    else // duplicate handling
    {
        std::cout << "No duplicates allowed, enter a unique key!"<<std::endl;
    }
}

Node* BinarySearchTree::removeAboveExternal(Node* btn) {
    Node* w = btn; Node* v = w->getParent();
    Node* sib = (w == v->getLeft() ? v->getRight() : v->getLeft());
    if (v == root){
        root = sib ;
        sib->par = NULL;
    }
    else
    {
        Node* gpar = v->par;
        if (v == gpar->left) gpar->left = sib ;
        else gpar->right = sib;
        sib->par = gpar ;
    }

    delete w; delete v;
    size -=2 ;
    return sib;
}

Node * BinarySearchTree::getRightMost(Node* btn)
{
    Node* tmp = new Node(btn) ;
    while (tmp->right != NULL) tmp = tmp->right;
    return tmp ;
}
//successor
Iterator& Iterator::operator++()
{
    Node* w = btn->right ;
    if (w->isInternal()){
        do {btn = w; w = w->left;}
        while (w->isInternal());
    }
    else
    {
        w = btn->par;
        while (btn == w->right)
        {btn = w; w = w->par;}
        btn=w;
    }
    if (btn->par == NULL) btn = NULL;
    return *this ;
}

bool BinarySearchTree::insert(Employee& E)
{
    Node* tmp = root;

}

