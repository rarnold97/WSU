//Employee.h provided by Dr. Meilin Liu, and you can make minor modifications if //you want.

#ifndef _BinarySearchTree_
#define _BinarySearchTree_

#include <cstdlib>
#include "BinaryTreeNode.h"
#include "Employee.h"
#include <fstream>

using namespace std;
typedef BinaryTreeNode Node;

class BinarySearchTree {
public:

    //bst methods

    BinarySearchTree();	//constructor
    ~BinarySearchTree();	//destructor
    bool clear(); // using postorder tree traversal
    bool insert(Employee & emp);
    Employee* search(int k);
    bool remove(int k);
    int BSTsize();
    bool print(); // using inorder tree traversal
    bool save(); // using inorder tree traversal

    BinaryTreeNode* getRoot() const;



    void expandExternal(Employee& E, Node* btn);
    friend class Iterator;

private:
    BinaryTreeNode * root;
    int size;
};

BinaryTreeNode* findSuccessor(BinaryTreeNode*, BinaryTreeNode *root);
BinaryTreeNode* getRightMost(BinaryTreeNode*);
BinaryTreeNode* getLeftMost(BinaryTreeNode*);
Node* DeleteNode(Node* tree, int k);

void postorderDelete(Node* current);
void recursivePrint(Node* node);
void recursiveSave(std::ostream& out, Node* node);


#endif
 
