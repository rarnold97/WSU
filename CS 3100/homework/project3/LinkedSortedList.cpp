//
// Created by ryanarnold on 10/22/20.
//
#include "LinkedSortedList.h"

#include <utility>
using namespace std ;

// Constructor
LinkedSortedList::LinkedSortedList()
{
    head = NULL ;
}

// Destructor
LinkedSortedList::~LinkedSortedList()
{
    clear();
}

// Return the number of the elements in the sorted linked list
int LinkedSortedList::size() const
{
    int n = 0;
    Node* current = head ;
    if(head == NULL) return n ;

    while(current->next != NULL) ++n;

    return n + 1 ;
}

// Clear the list.  Free any dynamic storage.
void LinkedSortedList::clear()
{
    if (head == NULL) return ;
    Node *old;
    while (head->next !=NULL)
    {
        old = head;
        head = old->next;
        delete old ;
    }
    head = NULL ;
}

//Insert a last name into the sorted linked list (in non-descreasing order)
//in the right position according to string value so that
//the linked list is still a correctly sorted linked list.
//Return true if successful, false if failure.
bool LinkedSortedList::insert(string lname)
{
    Node* current;
    Node* new_node = new Node(lname, NULL);

    if (head == NULL || head->value >= new_node->value )
    {
        new_node->next = head;
        head = new_node;
    }
    else
    {
        current = head;
        while(current->next != NULL &&
            current->next->value < new_node->value)
        {
            current = current->next ;
        }
        new_node->next = current->next ;
        current->next = new_node ;
    }
}

// Get AND DELETE the nth element of the sorted linked list from the end, placing it into the
// return variable "returnvalue".  If the list has less than n elements, return false,
// otherwise return true after successfully deleting the nth element from the end (i.e., the nth node from the end).
bool LinkedSortedList::remove_nth_element_from_end(string &returnvalue, int n)
{
    if (head == NULL || n > size())
    {
        cout << "n exceeds the size of the linked list!"<<endl;
        return false;
    }
    int m = size() - n ;
    Node* current = head;
    Node* prev ;

    for (int i = 0; i < m; i++)
    {
        if (i == m-1) prev = current;
        current = current->next ;
    }

    returnvalue = current->value ;
    prev->next = current->next;
    delete current;
    return true;
}

// Get AND DELETE the last element of the sorted linked list, placing it into the
// return variable "lastvalue".  If the list is empty, return false, otherwise
// return true after successfully deleting the last element (i.e., the last node).
bool LinkedSortedList::getlast(string &lastvalue)
{
    if (head == NULL) return false;
    if (head->next == NULL)
    {
        lastvalue = head->value;
        head->next = NULL ;
        delete head;
        return true;
    }

    Node *second_to_last = head;
    while(second_to_last->next->next != NULL)
            second_to_last = second_to_last->next;

    lastvalue = second_to_last->next->value;
    delete (second_to_last->next);
    second_to_last->next = NULL;

}

// Print out the entire sorted linked list to the screen.  Print an appropriate message
// if the list is empty.  Note:  the "const" keyword indicates that
// this function cannot change the contents of the sorted linked list.
void LinkedSortedList::print() const
{
    if (head == NULL)
    {
        cout << "Sorted Linked List has no contents!"<<endl;
        return;
    }

    Node* current = head;
    while(current->next != NULL)
    {
        current->print();
        cout<<endl;
        current = current->next ;
    }
    current->print();
    cout<<endl;
    cout<<"NULL"<<endl ;

}

LinkedNode* MergeLinkedSortedList(LinkedNode *head1, LinkedNode *head2)
{
    // default constructor points next to NULL
    Node* tail;

    while (true)
    {
        if (head1 == NULL)
        {
            tail->next = head2 ;
            break;
        }
        else if (head2 == NULL)
        {
            tail->next = head1 ;
            break;
        }
        if (head1->value <= head2->value)
        {
            Node* new_node = head1;
            head1 = new_node->next;
            new_node->next = tail->next;
            tail->next = new_node;
        }
        else
        {
            Node* new_node = head2;
            head2 = new_node->next;
            new_node->next = tail->next;
            tail->next = new_node;
        }
        tail = tail->next;
    }

    return(tail);
    //return tail->next
}