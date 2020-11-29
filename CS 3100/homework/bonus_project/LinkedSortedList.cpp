/*
CS 3100 Data Structures and Algorithms
Ryan Arnold
Dr.Meilin Liu
November. 9, 2020
Project 3: Linked Sorted List
*/

#include "LinkedSortedList.h"

#include <utility>
using namespace std ;

// Constructor
LinkedSortedList::LinkedSortedList()
{
    head = NULL ;
    nodeCount = 0 ;
}

//Copy Constructor
//pass the prescribed head by reference to avoid memory issues
LinkedSortedList::LinkedSortedList(Node* &head0, int n)
{
    head = head0 ;
    nodeCount = n ;
}
// Destructor
LinkedSortedList::~LinkedSortedList()
{
    clear();
}

// Return the number of the elements in the sorted linked list
int LinkedSortedList::size() const
{
    return nodeCount ;
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
    nodeCount = 0 ;
}

//Insert a last name into the sorted linked list (in non-descreasing order)
//in the right position according to string value so that
//the linked list is still a correctly sorted linked list.
//Return true if successful, false if failure.
bool LinkedSortedList::insert(string lname)
{

    try {
        Node* current;
        Node* new_node = new Node(lname, NULL);

        if (head == NULL || head->value >= new_node->value) {
            new_node->next = head;
            head = new_node;
            ++nodeCount;
        } else {
            current = head;
            while (current->next != NULL &&
                   current->next->value < new_node->value) {
                current = current->next;
            }
            new_node->next = current->next;
            current->next = new_node;
            ++nodeCount;
        }
    }
    catch (...)
    {
        return false;
    }
    return true ;
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

    if (m==0)
    {
        returnvalue = current->value ;
        head = current->next ;
        delete current;
        nodeCount--;
    }
    else
    {
        Node* prev = NULL;
        for (int i = 0; i < m; i++)
        {
            if (i == m-1) prev = current;
            current = current->next ;
        }

        returnvalue = current->value ;
        prev->next = current->next;
        delete current;
        nodeCount--;
    }

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
    nodeCount--;
    second_to_last->next = NULL;
    return true;
}

// Print out the entire sorted linked list to the screen.  Print an appropriate message
// if the list is empty.  Note:  the "const" keyword indicates that
// this function cannot change the contents of the sorted linked list.
void LinkedSortedList::print() const
{
    if (head == NULL)
    {
        cout<<"NULL"<<endl;
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
    //cout<<"NULL"<<endl ;

}

LinkedNode* MergeLinkedSortedList(LinkedNode *head1, LinkedNode *head2)
{
    // dummy first node allocated on the stack to put the result on
    Node dummy;
    Node* tail = &dummy;

    //make copies of the input heads to traverse without actually moving originals
    Node* h1 = head1 ;
    Node* h2 = head2 ;

    while(true)
    {
        //must return the other list if one runs out
        if (h1==NULL)
        {
            //copy again to traverse from current head position
            Node* oldhead2 = h2;
            //go throught the remainer of the head
            while(oldhead2 != NULL)
            {
                // create a new node to copy the merge data
                Node* tmp = new Node;
                //assign the value of the oldhead to copy
                tmp->value = oldhead2->value;
                //append to the tail
                tail->next = tmp ;
                //advance the oldhead and the tail
                oldhead2 = oldhead2 ->next;
                tail = tail->next;
            }
            //break main control loop
            break;
        }
        else if (h2==NULL)
        {
            //same as previous for head 1
            Node* oldhead1 = h1;

            while(oldhead1 != NULL)
            {
                Node* tmp = new Node;

                tmp->value = oldhead1->value;
                tail->next = tmp ;
                oldhead1 = oldhead1 ->next;
                tail = tail->next;
            }

            break;
        }
        //case where the current value of head1 is less than head 2.
        //we extract this value and advance head 1 one position
        if (h1->value <= h2->value)
        {
            //create a new node to copy data to
            Node* tmp = new Node;
            //make a copy to traverse h1 from current position
            Node* newNode = h1;
            //write value to new node
            tmp->value = newNode->value;
            //append to tail
            tail->next = tmp;
            //advance the tail
            h1 = newNode->next ;
        }
        else
        {
            //same logic as before, except head 2 is less
            Node* tmp = new Node;
            Node* newNode = h2;

            tmp->value = newNode->value;
            tail->next = tmp;
            h2 = newNode->next ;
        }
        //advance tail
        tail = tail->next ;
    }
    //create output node, we take dummy.next, since dummy's 0th value is empty
    Node* mergedHead = dummy.next ;
    return mergedHead ;
}

// custom added functions to manage the head
Node* LinkedSortedList::getHead() const
{
    return head ;
}
