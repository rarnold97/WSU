//
// Created by ryanarnold on 10/9/20.
//

#ifndef LECTURE_CODE_EXAMPLES_LINKEDLIST_H
#define LECTURE_CODE_EXAMPLES_LINKEDLIST_H

#include <cstdlib>
#include <iostream>

template <typename Item>
class Lnode
{
public:
    Item value;
    Lnode *next;
    Lnode(Item newvalue, Lnode * newptr = NULL){value = newvalue; next=newptr;}
};

template <typename Item>
class Slist
{
private:
    Lnode<Item>* head;
public:
    Slist(){head=NULL;}
    ~Slist(){clear();}
    bool insertfront(Item i);
    bool insertend(Item i);
    bool getfirst(Item &val);
    bool getlast(Item &val);
    void clear();
};

#endif //LECTURE_CODE_EXAMPLES_LINKEDLIST_H
