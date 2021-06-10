/*
CS 3100 Data Structures and Algorithms
Ryan Arnold
Dr.Meilin Liu
December. 1, 2020
Project 4: Binary Search Tree
*/

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

Node * getRightMost(Node* btn)
{
    // get right most child of input node.  go until there are no right children
    Node* current = btn;
    while (current && current->right != NULL) current = current->right;
    return current ;
}

BinaryTreeNode* getLeftMost(BinaryTreeNode* btn)
{
    // get left most child of input node. go until there are no left children
    Node* current = btn;
    while (current && current->left !=NULL) current = current->left;
    return current ;
}

// insert a new node to the tree
bool BinarySearchTree::insert(Employee& E)
{
    // start at root
    Node* v = root;
    // create a new Node pointer containing input Employee element
    Node* w = new Node(E) ;
    // if there is no prexisting root then assign new element to be the new root
    if (root == NULL)
    {
        root = w ;
        size++;
        return true;
    }
    // start main control loop
    do
    {
        // check keys, if key is larger than current, go right else go left
        if (w->getKey() > v->getKey())
        {
            if (v->right == NULL) // no existing right child, external node
            {
                // assign parent and child
                v->right = w;
                w->par = v ;
                size++; // add to count
                return true; // exit function and return true for success
            }
            else{
                // internal node keep going
                v = v->right;
            }

        }
        else if (w->getKey() < v->getKey()) // key is less than current, go left
        {
            if (v->left == NULL) // external node
            {
                // assign parent and child
                v->left = w;
                w->par = v ;
                size++; // add to count
                return true; // exit function and return true for success
            }
            else{
                // internal node keep going
                v = v->left;
            }

        }
        else
        {
            // duplicate key, inform user this is invalid and return false
            std::cout<<"No Duplicates allowed!"<<std::endl;
            return false;
        }

    }while (true);

}

Employee* BinarySearchTree::search(int k) // search for node based on key
{
    //root has no nodes
    if (root ==NULL){
        std::cout<<"Key Not Found"<<std::endl;
        return NULL;
    }
    int amtSearched = 0 ; // start count of nodes searched
    // start at root
    Node* tmp = root ;

    std::cout << "Searching..."<<std::endl;
    // go until node is NULL pointer
    while (tmp != NULL)
    {
        amtSearched++ ; // add to amount of nodes checked
        if (k==tmp->getKey()) // found correct ID
        {
            Employee* target = tmp->getElementPtr() ; // get the employee element
            // print the data stored in the employee element
            std::cout<<amtSearched<<" Employees Searched. Found Record."<<std::endl;
            std::cout<<target->getID()<<" "<<target->getLastName()<<" "<<target->getFirstName()<<std::endl;
            return target; // return element and exit function
        }
        else if (k > tmp->getKey())
        {
            // key greater, go right
            tmp = tmp ->right;
        }
        else
        {
            // key less, go left
            tmp = tmp->left;
        }
    }

    // did not find the key
    std::cout<< "Key (ID) Not Found after searching "<<amtSearched<<" keys."<<std::endl;
    return NULL ;

}

// recursion ensures that the correct structure is retained when performing delete operations
// need to make sure links are broken and replaced correctly
Node* DeleteNode(Node* tree, const int k)
{
    // tree contains nothing
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
            // delete the node
            Node* tmp = tree->right;
            delete(tree);
            return tmp ;
        }
        else if (tree->right == NULL)
        {
            // delete the node
            Node* tmp = tree->left;
            delete(tree);
            return tmp ;
        }

        // perform deletion and replace element with the successor
        Node* tmp = getLeftMost(tree->right);
        tree->setElement(tmp->getElement());
        // delete inorder successor
        tree->right = DeleteNode(tree->right, tmp->getKey()) ;
    }
    return tree; // return recursed tree
}


bool BinarySearchTree::remove(int k)
{
    // tree is empty, return false
    if (root==NULL) return false ;
    // start at root
    Node* tree = root ;
    // use a control variable to indicate if found and initialize to false
    bool found = false;
    // scan the tree
    while (tree !=NULL)
    {
        if (k==tree->getKey())
        {
            // found the key, now need to perform the delete operation, we can stop checking for it
            found = true;
            break;
        }
        else if (k > tree->getKey())
        {
            // key is greater, check right subtree
            tree = tree ->right;
        }
        else
        {
            // key is less, check left subtree
            tree = tree->left;
        }
    }

    if (!found) return found; // we did not find the key
    // perform recursive delete operation
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
    // tree is empty
    if (node == NULL) return ;
    // recurse left subtree
    recursiveSave(out, node->left) ;
    // save information
    Employee E = node->getElement();
    out << E.getLastName() << " " << E.getFirstName() << " " << E.getID() << std::endl;
    // recurse right subtree
    recursiveSave(out, node->right) ;
}

bool BinarySearchTree::save()
{
    // empty tree, exit
    if (root == NULL) return false;
    // open a text file stream
    ofstream file ;
    file.open("Binary-Tree-Output.txt");

    try{ // catch errors and return false indicating unsuccessful write
        file << "____Binary Tree Save Data____:"<<std::endl;
        // get the root
        Node* tmp = root ;
        // recurse the tree starting at the root
        recursiveSave(file, tmp) ;
        //close file
        file.close() ;
        // print message indicating success
        std::cout << "Success saving output file Binary-Tree-Output.txt!"<<std::endl ;
        std::cout << std::endl;
    }catch(...)
    {
        // error occured, print message to indicate this and return false
        std::cout << "unsuccessful in saving to disk!" << std::endl;
        std::cout<<std::endl;
        file.close() ;
        return false;}
    // return true, function worked
    return true ;
}

// post order traversal algorithm used in clear()
void postorder(Node* current)
{
if (current == NULL) return; // empty, no need to delete
// recurse left
postorder(current->left);
// recurse right
postorder(current->right);
// print message to alert that element is being deleted
std::cout<<"deleting element at key: "<< current->getKey()<<std::endl;
delete(current) ;
}

bool BinarySearchTree::clear()
{
    // driver function to post order delete
    if (root == NULL){
        std::cout<<"Nothing deleted!"<<std::endl;
        return false;
    }
    //call the post order deletion recursive function
    postorder(root);
    return true;
}