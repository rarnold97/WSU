//Employee.h provided by Dr. Meilin Liu, and you can make minor modifications if //you want.

#ifndef _BinarySearchTree_
#define _BinarySearchTree_

#include <cstdlib>
#include "BinaryTreeNode.h"
#include "Employee.h"
#include <fstream>
#include <list>

using namespace std;
typedef BinaryTreeNode Node;

class BinarySearchTree {
public:
    /*
    class Position {
    protected:
        Node *v;
    public:
        Position(Node *_v = NULL) : v(_v) {}

        //operator overloads for comparisons
        Employee& operator*()
            { return v->person; }
        bool operator==(Position other)
            {return v == other.v;}
        bool operator<(Position other)
            {return v->person.getID() < other.getPerson().getID();}
        // cant just use ! < because we are not allowing duplicates
        bool operator>(Position other)
            {return v->person.getID() > other.getPerson().getID(); }
        //read only access
        const Employee& getPerson() const
            {return v->person;}
        Position left()
            { return Position(v->left); }
        Position right()
            { return Position(v->right); }
        Position parent()
            { return Position(v->par); }
        bool isRoot()
            { return v->par == NULL; }
        bool isExternal()
            { return v->left == NULL && v->right == NULL; }
        bool isInternal()
            {return !isExternal();}

        friend class BinarySearchTree;
    }; // end of position class
    */
    //typedef std::list<Position> PositionList;
    public:
        //typedef Position TPos ;

        //iterator class
        class Iterator{ //inorder traversal iteration
        private:
            const Node* btn ;
        public:
            explicit Iterator(const BinaryTreeNode* v) : btn(v) {}
            const Employee& operator*() const {return btn->getElement();}
            //Employee& operator*(){return btn->getElement();}
            bool operator==(Iterator otherPos)
                {return btn == otherPos.btn;}
            bool operator!=(Iterator otherPos)
                {return !(btn == otherPos.btn);}
            Iterator& operator++(); // successor
            void print()
                {std::cout<<btn->getElement()<<std::endl;}
            friend class BinarySearchTree;
    }; // end of iterator class

    //bst methods
    public:
        BinarySearchTree();	//constructor
        ~BinarySearchTree();	//destructor
        bool clear(); // using postorder tree traversal
        bool insert(Employee & emp);
        Employee* search(int k);
        bool remove(int k);
        int BSTsize();
        bool print(); // using inorder tree traversal
        bool save(); // using inorder tree traversal

        Iterator begin() ;
        Iterator end() ;

        BinaryTreeNode* getRoot() const;
        BinaryTreeNode* getRightMost(BinaryTreeNode*);

        void expandExternal(Employee& E, Node* btn);
        Node* removeAboveExternal(Node* btn);
        friend class Iterator;

    private:
        BinaryTreeNode * root;
        int size;
};

BinaryTreeNode* findSuccessor(const BinaryTreeNode*);
Node* DeleteNode(Node* tree, int k);

#endif
 
