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
    nodeCount = 0 ;
}

//Copy Constructor
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
    /**
    int n = 0;
    Node* current = head ;
    if(head == NULL) return n ;

    while(current->next != NULL) ++n;

    return n + 1 ;
    **/
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
        Node* prev ;
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

/*
Node* Merge(Node* h1, Node* h2)
{
    // we assume here that the first value of h1 is less than h2, handled in the driver function
    if (h1->next == NULL)
    {
        h1->next = h2;
        return h1;
    }

    Node* oldHead1 = h1;
    Node* oldNext1 = h1->next;
    Node* oldHead2 = h2;
    Node* oldNext2 = h2->next;

    while (oldNext1 && oldHead2)
    {
        if ((oldHead2->value >= oldHead1->value) && (oldHead2->value <= oldNext1->value))
        {
            oldNext2 = oldHead2->next ;
            oldHead1->next = oldHead2 ;
            oldHead2->next = oldNext1 ;

            oldHead1 = oldHead2 ;
            oldHead2 = oldNext2 ;
        }
        else
        {
            if (oldNext1->next != NULL)
            {
                oldNext1 = oldNext1->next;
                oldHead1 = oldHead1->next;
            }
            else
            {
                oldNext1->next = oldHead2;
                return h1 ;
            }
        }
    }

    return h1;
}
*/

LinkedNode* MergeLinkedSortedList(LinkedNode *head1, LinkedNode *head2)
{
    // dummy first node allocated on the stack to put the result on
    Node dummy;
    Node* tail = &dummy;

    Node* h1 = head1 ;
    Node* h2 = head2 ;

    while(true)
    {
        //must return the other list if one runs out
        if (h1==NULL)
        {
            Node* oldhead2 = h2;

            while(oldhead2 != NULL)
            {
                Node* tmp = new Node;

                tmp->value = oldhead2->value;
                tail->next = tmp ;
                oldhead2 = oldhead2 ->next;
                tail = tail->next;
            }
            //tail->next = h2;
            break;
        }
        else if (h2==NULL)
        {
            Node* oldhead1 = h1;

            while(oldhead1 != NULL)
            {
                Node* tmp = new Node;

                tmp->value = oldhead1->value;
                tail->next = tmp ;
                oldhead1 = oldhead1 ->next;
                tail = tail->next;
            }

            //tail->next=h1;
            break;
        }
        if (h1->value <= h2->value)
        {
            Node* tmp = new Node;
            Node* newNode = h1;


            tmp->value = newNode->value;
            tail->next = tmp;
            h1 = newNode->next ;


            /*
            Node* newNode = h1 ;
            h1 = newNode->next ;
            newNode->next = tail->next;
            tail->next = newNode;
             */
        }
        else
        {
            Node* tmp = new Node;
            Node* newNode = h2;

            tmp->value = newNode->value;
            tail->next = tmp;
            h2 = newNode->next ;
            /*
            Node* newNode = h2 ;
            h2 = newNode->next ;
            newNode->next = tail->next;
            tail->next = newNode;
             */

        }

        tail = tail->next ;
    }

    Node* mergedHead = dummy.next ;
    return mergedHead ;
    /*
    if (h1 == NULL) return h2;
    if (h2 == NULL) return h1;

    Node* mergedHead ;
    if (h1->value <= h2->value)
    {
        mergedHead = h1 ;
        h1 = h1->next ;
    }
    else
    {
        mergedHead = h2;
        h2 = h2->next;
    }

    Node* mergedHead2 = mergedHead;

    while(h1 != NULL && h2 != NULL)
    {
        Node* tmp ;
        if (h1->value <= h2->value)
        {
            tmp = h1;
            h1 = h1->next;
        }
        else
        {
            tmp = h2 ;
            h2 = h2->next;
        }

        mergedHead2->next = tmp ;
        mergedHead2 = tmp ;
        //mergedHead2 = mergedHead2->next ;
    }

    if (h1 != NULL)
    {
        mergedHead2->next = h1 ;
    }
    else if (head2 != NULL)
    {
        mergedHead2->next = h2 ;
    }

    return mergedHead ;
     */
    //if (h1->value < h2->value) return Merge(h1, h2);
    //else return Merge(h2, h1);
}

// custom added functions to manage the head
Node* LinkedSortedList::getHead() const
{
    return head ;
}

void LinkedSortedList::setHead(Node *newHead) {head = newHead;}