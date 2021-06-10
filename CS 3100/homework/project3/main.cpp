/*
CS 3100 Data Structures and Algorithms
Ryan Arnold
Dr.Meilin Liu
November. 9, 2020
Project 3: Linked Sorted List
*/

#include <iostream>
#include <fstream>
#include <string>
#include "LinkedSortedList.h"

using namespace std ;

void skipLines(std::istream & is, size_t n, char delim);
int readInputFile(LinkedSortedList &lsl, bool skip, std::string filename);


int main() {
    string filename = "all.last.txt" ;

    cout<< "Reading in first N names from file."<<endl;
    LinkedSortedList list1 ;
    int nread1 = readInputFile(list1, false, filename) ;
    cout<<"Read "<<nread1<<" elements into list1"<<endl;
    list1.print();
    cout<<endl;

    cout<<"Reading in next M names from file."<<endl;
    LinkedSortedList list2;
    int nread2 = readInputFile(list2, true, filename) ;
    cout<<"Read "<<nread2<<" elements into list2"<<endl;
    list2.print();
    cout<<endl;

    cout << "Removing nth element from list1, where n=2."<<endl;
    string nth_removed ;
    int nremove = 2 ;
    list1.remove_nth_element_from_end(nth_removed, nremove);
    list1.print() ;
    cout<<endl;

    cout<<"Note the new size of list1 is now: "<<list1.size()<<endl;
    cout<<endl;

    cout << "Removing nth element from list2, where n=size().  Should remove first Value."<<endl;
    string nth_removed_2 ;
    int nremove2 = list2.size() ;
    list2.remove_nth_element_from_end(nth_removed_2, nremove2);
    list2.print() ;
    cout<<endl;

    string userEnteredName ;
    cout << "Enter Name from keyboard."<<endl;
    cin >> userEnteredName ;
    list1.insert(userEnteredName) ;
    cout<<endl;
    list1.print();
    cout<<endl;

    cout<<"Last element of list2, assuming its not NULL based on user input:"<<endl;
    string lastElement;
    list2.getlast(lastElement);
    cout<<"Last element is:    "<<lastElement << endl;
    cout<<endl;
    cout<<"What remains of list2 ..."<<endl;
    list2.print() ;
    cout<<endl;

    cout << "TESTING HELPER FUNCTIONS!" << endl;
    cout << "Size of list 1 is "<<list1.size()<<endl;
    cout<<endl;

    cout << "TESTING MERGING ALGORITHM!"<<endl;
    cout << endl;
    cout<<"Merging Sorted List1 and sorted List2" <<endl;
    cout<<endl;

    Node* head1 = list1.getHead(); Node* head2 = list2.getHead();

    Node* mergedHead = MergeLinkedSortedList(head1, head2) ;
    int mergeSize = list1.size() + list2.size() ;
    //although mergedHead is dynamic, we pass to the copy constructor
    //by reference, so the destructor of the merged list frees the heap
    //memory
    LinkedSortedList mergedList(mergedHead, mergeSize) ;
    mergedList.print() ;
    cout<<endl;

    cout<<"Clearing List 2:"<<endl;
    list2.clear();
    list2.print();
    cout<<endl;

    //testing the merge where one of the lists has a single element
    cout<<"Testing the Merge function, where one of the two lists/heads only contains a single element! (SHINJI)"<<endl;
    cout<<endl;

    LinkedSortedList list3 ;
    list3.insert(string("GON"));
    list3.insert(string("FREECS"));
    list3.insert(string("IZUMI"));
    list3.insert(string("KANEKI"));
    list3.insert(string("BELMONT"));

    LinkedSortedList list4;
    list4.insert(string("SHINJI"));

    Node* head3 = list3.getHead(); Node* head4 = list4.getHead();

    Node* mergedHead2 = MergeLinkedSortedList(head3, head4) ;
    int nMerge = list3.size() + list4.size();
    LinkedSortedList mergedList2(mergedHead2, nMerge);
    mergedList2.print();
    cout<<endl;

    return 0;
}


int readInputFile(LinkedSortedList &lsl, bool skip, std::string filename)
{
    int n_names ;

    while(true)
    {
        try
        {
            std::cout << "Enter the number of names to be read: "<<std::endl;
            std::cin >> n_names ;
            // 88799 is the max number of lines in the file
            if (n_names > 88799) throw(n_names);
            break;
        }
        catch(int n_names)
        {
            std::cout<<n_names<<" is greater than file capacity try agian..." <<std::endl ;
        }
    }

    std::string line ;
    std::ifstream fin ;
    fin.open(filename) ;

    if (skip) skipLines(fin,n_names,'\n') ;
    int n_lines = 0 ;
    bool success ;

    while(n_lines < n_names && fin)
    {
        std::getline(fin, line) ;
        success = lsl.insert(line) ;
        n_lines++ ;
    }

    fin.close();
    return n_names ;
}

void skipLines(std::istream & is, size_t n, char delim)
{
    // declare the size of the file based on input
    size_t i = 0 ;
    while(i++ < n)  // skip n lines
    {
        // skip number of lines with a buffer of 80 characters
        // will stop skipping at newline delimiter
        is.ignore(256, delim) ;
    }
}