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

//constructor
BinarySearchTree::BinarySearchTree()
{
    root = NULL;
    size = 0;
}
//destructor
BinarySearchTree::~BinarySearchTree()
{
    clear();
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


Node * getRightMost(Node* btn)
{
    Node* current = btn;
    while (current && current->right != NULL) current = current->right;
    return current ;
}

BinaryTreeNode* getLeftMost(BinaryTreeNode* btn)
{
    Node* current = btn;
    while (current && current->left !=NULL) current = current->left;
    return current ;
}

/**
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
**/
bool BinarySearchTree::insert(Employee& E)
{
    Node* v = root;
    Node* w = new Node(E) ;

    if (root == NULL)
    {
        root = w ;
        return true;
    }

    do
    {
        if (w > v)
        {
            if (v->right == NULL)
            {
                v->right = w;
                w->par = v ;
                return true;
            }
            else{
                v = v->right;
            }

        }
        else if (w < v)
        {
            if (v->left == NULL)
            {
                v->left = w;
                w->par = v ;
                return true;
            }
            else{
                v = v->left;
            }

        }
        else
        {
            std::cout<<"No Duplicates allowed!"<<std::endl;
            return false;
        }

    }while (true);

}


Node* findSuccessor(BinaryTreeNode *node_in, BinaryTreeNode *root)
{

    if (node_in == getRightMost(root)) return NULL ;
    Node* w = node_in;
    if (w->right != NULL)
        return getLeftMost(w->right);

    Node* p = w->par ;
    while(p!=NULL && w == p->right)
    {
        w = p;
        p = p->par;
    }

    return p;

    /*
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
    */
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

        Node* tmp = getLeftMost(tree->right);
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
    while (tmp != NULL)
    {
        std::cout<<tmp->getElement()<<std::endl;
        tmp = findSuccessor(tmp, root) ;
    }

    return true;
}

bool BinarySearchTree::save()
{
    if (root == NULL) return false;
    ofstream file ;
    file.open("Binary-Tree-Output.txt");

    try {
        Node* tmp = root ;
        while (tmp != NULL)
        {
            Employee E = tmp->getElement();
            file<<E.getLastName()<<" "<<E.getFirstName()<<" "<<E.getID()<<std::endl;
            tmp = findSuccessor(tmp, root) ;
        }
    }catch(...)
    {return false;}

    return true;
}

void postorder(Node* current)
{
if (current == NULL) return;
postorder(current->left);
postorder(current->right);
std::cout<<"deleting key: "<< current->getKey()<<std::endl;
delete(current) ;
}

bool BinarySearchTree::clear()
{
    if (root == NULL){
        std::cout<<"Nothing deleted!"<<std::endl;
        return false;
    }
    postorder(root);
    return true;
}