//
// Created by ryanm on 11/12/2020.
//

#include "BinarySearchTree.h"
#include <iostream>

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
    if (root == NULL)
    {
        root = w ;
        return true;
    }

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


Node* findSuccessor(const BinaryTreeNode *node_in)
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

Employee* BinarySearchTree::search(int k)
{
    //root has no nodes
    if (root ==NULL){
        std::cout<<"Key Not Found"<<std::endl;
        return NULL;
    }

    Node* tmp = root ;

    do {
        if (k==tmp->getKey())
        {Employee* target = tmp->getElementPtr() ;
        return target;}
        else if (k > tmp->getKey())
        {
            tmp = tmp ->right;
        }
        else
        {
            tmp = tmp->left;
        }
    } while(tmp->isInternal());

    // did not find the key
    std::cout<< "Key Not Found"<<std::endl;
    return NULL ;

}


Node* DeleteNode(Node* tree, const int k)
{
    if (tree == NULL)
        return tree;

    // if the key is smaller than the root, its in the left subtree
    if (k < tree->getKey())
        tree-> left = DeleteNode(tree->left, k) ;

    //otherwise it is in the right subtree
    else if (k> tree->getKey())
        tree ->right = DeleteNode(tree->right, k);

    //found where it is, has to equal
    else{
        if (tree->left == NULL)
        {
            Node* tmp = tree->right;
            delete(tree);
            return tmp ;
        }
        else if (tree->right == NULL)
        {
            Node* tmp = tree->left;
            delete(tree);
            return tmp ;
        }

        Node* tmp = findSuccessor(tmp);
        tree->setElement(tmp->getElement());
        //delete inorder successor
        tree->right = DeleteNode(tree->right, tmp->getKey()) ;
    }
    return tree;
}


bool BinarySearchTree::remove(int k)
{
    if (root==NULL) return false ;

    Node* tree = root ;

    bool found = false;

    do {
        if (k==tree->getKey())
        {
            found = true;
            break;
        }
        else if (k > tree->getKey())
        {
            tree = tree ->right;
        }
        else
        {
            tree = tree->left;
        }
    }while(tree->isInternal());

    if (!found) return found;

    root = DeleteNode(root, k);
    return true ;
}

bool BinarySearchTree::print()
{
    if (root == NULL) return false;

    Node* tmp = root ;
    do {
        std::cout<<tmp->getElement()<<std::endl;
        tmp = findSuccessor(tmp) ;
    }
    while(tmp!= getRightMost(root));

    return true;
}

bool BinarySearchTree::save()
{
    if (root == NULL) return false;
    ofstream file ;
    file.open("Binary-Tree-Output.txt");

    try {
        Node* tmp = root ;
        do {
            Employee E = tmp->getElement();
            file<<E.getLastName()<<" "<<E.getFirstName()<<" "<<E.getID()<<std::endl;
            tmp = findSuccessor(tmp) ;
        }
        while(tmp!= getRightMost(root));
    }catch(...)
    {return false;}

    return true;
}
