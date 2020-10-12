//
// Created by ryanarnold on 10/9/20.
//

#include "LinkedList.h"

template<class Item>
bool Slist<Item>::insertfront(Item i)
{
    Lnode<Item>* newnode = new Lnode<Item>(i);
    if (newnode == NULL)
        return false;
    newnode->next = head;
    head = newnode;
    return true;
}

template <class Item>
void Slist<Item>::clear()
{
    Lnode<Item>* oldnode;
    while(head != NULL)
    {
        oldnode = head ;
        head = head->next;
        delete(oldnode);
    }
}

template class Slist<int>;
template class Slist<double>;
template class Slist<std::string>;