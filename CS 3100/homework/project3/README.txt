/*
CS 3100 Data Structures and Algorithms
Ryan Arnold
Dr.Meilin Liu
November. 9, 2020
Project 3: Linked Sorted List
*/

## Information about project 3 created by Ryan Arnold

* To use the interface in this project, it involves creating an instance of LinkedSortedList,
which relies on a LinkedNode defined in LinkedNode.h.  This node holds a std::string.

* DISCLAIMER:  When using the print function, it can print NULL at the end.  I did this to
potentially make things easier to visualize to indicate that the last element points to NULL.  This was by
design, and to get enable this, uncomment out line 172 of LinkedSortedList.cpp

* SUPPLEMENTAL FILES: This project is coded to use the all.last.txt file that contains a list
of several last names that are read in as strings.  The keyboard can also be used to insert
strings as demonstrated in main.cpp

* main.cpp is the driver code in this project and is primarily used to demonstrate the interface.

* There is also a typedef to shorten LinkedNode to Node ; These are the same data types

# LinkedSortedList Interface
* Members:
    ** head -> holds the pointer to the first node in the linked list
    ** nodeCount -> holds the number of nodes in the linked list

* LinkedSortedList() -> Default Constructor
    ** by default, sets head to NULL and the nodeCount to 0;

* LinkedSortedList(Node* &head0, int n)
    ** takes the head from either another LL or one created from scratch and sets this to the
    head of the newly created LL.  Also, writes the count of nodes based on passed int n.

    ** stores the head0 by reference so that no memory errors occur and so that the destuctor
    of the LL can handle freeing up any heap memory

* ~LinkedSortedList()
    ** destructor.  invokes clear()
    ** frees up heap memory by deleting the nodes and setting head = NULL

* int size() const
    ** returns a constant reference as an int of the number of nodes in the LL

* void clear()
    ** frees up any heap memory and deletes the pointers to the node of the LL. Then sets
    the head to NULL
    ** sets node count to 0

* bool insert(string lname)
    ** insertes a new string to the list in the correct order based on the sort
    ** also updates the node count
    ** returns true if successful, false if not.

* bool remove_nth_element_from_end(string &returnvalue, int n)
    ** removes the nth element from the end and writes it to the input string by reference
    ** updates node count
    ** ex:// if the LL is:      head->ALPHA->BETA->BRAVO->CHARLIE->GAMMA
    removing the 2nd from end:  head->ALPHA->BETA->BRAVO->GAMMA
    the value written to the input will be: CHARLIE
    ** returns true if successful, false if not.

* bool getlast(string &lastvalue)
    ** takes the last element of the LL, writes it to the input by reference, and deletes the last node
    ** node count is then updated
    ** returns true if successful, false if not.

* void print()
    ** prints the elements stored in the LL in order
    ** gives user a message if there are no elements

* Node* getHead() const
    ** returns a constant reference to the pointer stored in the head

# HELPER FUNCTIONS

* readInputFile() and skipLines() are used to read data from the input file in main.cpp

* LinkedNode* MergeLinkedSortedList(LinkedNode *head1, LinkedNode *head2)
    ** used to merge two linked lists together in sorted order, using the respective head pointers.
    ** this is achieved with getHead()
    ** returns a new copy of a LL that is the sorted, merged linked list
    ** this can be used in the copy constructor of the LL interface
    ** if not passed to a copy constructor, memory needs to be freed manually since
       the heap is used to create the copy.
    ** the head LinkedNode pointer is returned ultimately

* In the main.cpp, be sure to enter non zero numbers for the amount of names to read in from the file,
otherwise, the program will probably not function correctly.
