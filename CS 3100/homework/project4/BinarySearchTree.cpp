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

BinarySearchTree::BinarySearchTree()
{
    root = NULL;
    size = 0;
}

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
    Node* w = btn; Node* v = w->par;
    Node* sib = (w == v->left ? v->right : v->left);
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
    Node* tmp = btn ->right ;
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

Iterator BinarySearchTree::begin()
{

    if (root == NULL){
        Iterator out(NULL);
        return out ;
    }
    Node* v = root;
    while(v->isInternal()) v = v->left;
    Iterator out(v) ;
    return out ;
}

Iterator BinarySearchTree::end()
{
    Node* v = BinarySearchTree::getRightMost(root);
    Iterator out(v) ;
    return out ;

}

bool BinarySearchTree::insert(Employee& E)
{

    Node* v = root;
    Node* w = new Node(E) ;

    while (v->isInternal())
    {
        if (w > v)
        {
            v = v->right;
        }
        else if (w < v)
        {
            v = v->left;
        }
        else
        {
            std::cout<<"No Duplicates allowed!"<<std::endl;
            return false;
        }
    }

    if (w > v)
    {
        v->right = w ;
    }
    else if (w < v)
    {
        v->left = w ;
    }
    else
    {
        std::cout<<"No Duplicates allowed!"<<std::endl;
        return false;
    }

    return true; //finished successfully
}


Node* BinarySearchTree::findSuccessor(const BinaryTreeNode *node_in)
{
    Node* w = node_in->right ;

    if (w->isInternal()){
        do {w = w->left;}
        while(w->isInternal());
    }
    else{
        w = node_in->par;
        Node* tmp = new Node(node_in);
        while(tmp == w->right)
        {tmp=w; w = w->par;}
        //will be null if rightmost node
        delete tmp;
    }

    return w ;
}