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

bool BinarySearchTree::insert(Employee& E)
{
    Node* v = root;
    Node* w = new Node(E) ;

    if (root == NULL)
    {
        root = w ;
        size++;
        return true;
    }

    do
    {
        if (w->getKey() > v->getKey())
        {
            if (v->right == NULL)
            {
                v->right = w;
                w->par = v ;
                size++;
                return true;
            }
            else{
                v = v->right;
            }

        }
        else if (w->getKey() < v->getKey())
        {
            if (v->left == NULL)
            {
                v->left = w;
                w->par = v ;
                size++;
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

Employee* BinarySearchTree::search(int k)
{
    //root has no nodes
    if (root ==NULL){
        std::cout<<"Key Not Found"<<std::endl;
        return NULL;
    }
    int amtSearched = 0 ;

    Node* tmp = root ;

    std::cout << "Searching..."<<std::endl;

    while (tmp != NULL)
    {
        amtSearched++ ;
        if (k==tmp->getKey())
        {
            Employee* target = tmp->getElementPtr() ;
            std::cout<<amtSearched<<" Employees Searched. Found Record."<<std::endl;
            std::cout<<target->getID()<<" "<<target->getLastName()<<" "<<target->getFirstName()<<std::endl;
            return target;
        }
        else if (k > tmp->getKey())
        {
            tmp = tmp ->right;
        }
        else
        {
            tmp = tmp->left;
        }
    }

    // did not find the key
    std::cout<< "Key (ID) Not Found after searching "<<amtSearched<<" keys."<<std::endl;
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

    while (tree !=NULL)
    {
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
    }

    if (!found) return found;

    root = DeleteNode(root, k);
    return true ;
}

void recursivePrint(Node* node)
{
    if (node == NULL) return ;
    //recursvie call to the left node
    recursivePrint(node->left) ;
    //print data within the node
    std::cout<< node->getElement().getLastName() << " "
        << node->getElement().getFirstName() << " "
        << node->getKey() << std::endl;
    //recursive call to the right node
    recursivePrint(node->right) ;
}

bool BinarySearchTree::print()
{
    // root contains nothing
    if (root==NULL) return false ;

    recursivePrint(root);
    //recursive print successful
    return true ;
}

void recursiveSave(std::ostream& out, Node* node)
{
    if (node == NULL) return ;

    recursiveSave(out, node->left) ;

    Employee E = node->getElement();
    out << E.getLastName() << " " << E.getFirstName() << " " << E.getID() << std::endl;

    recursiveSave(out, node->right) ;
}

bool BinarySearchTree::save()
{
    if (root == NULL) return false;
    ofstream file ;
    file.open("Binary-Tree-Output.txt");

    try{ // catch errors and return false indicating unsuccessful write
        file << "____Binary Tree Save Data____:"<<std::endl;
        Node* tmp = root ;
        recursiveSave(file, tmp) ;
        file.close() ;
        std::cout << "Success saving output file Binary-Tree-Output.txt!"<<std::endl ;
        std::cout << std::endl;
    }catch(...)
    {
        std::cout << "unsuccessful in saving to disk!" << std::endl;
        std::cout<<std::endl;
        file.close() ;
        return false;}

    return true ;
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