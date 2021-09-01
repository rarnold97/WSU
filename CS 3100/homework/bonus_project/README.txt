/*
CS 3100 Data Structures and Algorithms
Ryan Arnold
Dr.Meilin Liu
December. 4, 2020
Bonus Project: Hash Table
*/

# How to Run

* the entry point to the program is through main.cpp
* make sure that all.last.txt is either in the same directory as the executable or is included
  in the working directory path!
* main.cpp contains all the tests of the hash table functionality

# Dependencies

* requires usage of LinkedSortedList
* LinkedSortedList requires LinkedNode
* LinkedSortedList.h, LinkedSortedList.cpp, LinkedNode.h
* linked lists are required to handle collisions.  This program
  employs the use of chaining to handle collision.

# Interface 

	## Protected members:

	* nBuckets - number of hash buckets
	* occupied - number of occupied bucket
	* longestList - size of largest collision linked list
	* numKeys -  number of keys stored in hash table
	* loadFactor - numKeys / nBuckets

	## Public functions 

	* HashTable - constructor that defaults a has table with 88001 buckets
	* ~HashTable - destructor that frees any dynamic memory in hash table
	* insert - insert a key (string) into the hash table
	* deleteEntry - finds an entry by tree and deletes from hash table.
	  if there is a chain, breaks and restores the links accordingly
	* search - looks for key, indicates if it was found in and what bucket number it is stored in
	* saveLogFile - prints the hash table contents to a text file by bucket.
	  if there is a chain, prints the chain in correct order
	* printSummary - prints to the screen the fundamental data about the hash table.
	  this includes : occupied buckets, unoccupied buckets, load factor, and longest chain length
