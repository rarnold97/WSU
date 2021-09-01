#pragma once

/*
CS 3100 Data Structures and Algorithms
Ryan Arnold
Dr.Meilin Liu
December. 4, 2020
Bonus Project: Hash Table
*/

#include <iostream>
#include <string>
#include <fstream>
#include "LinkedSortedList.h"

unsigned long sdbm(const char* str); 

typedef LinkedSortedList bucket; // linked sorted lists will serve as buckets

class HashTable
{
protected:
	int nBuckets; 
	int occupied;
	int longestList;
	int numKeys; 
	float loadFactor;

	bucket** table; // array of linked list pointers 

public:

	struct entry {
		unsigned long key; 
		std::string value; 
	};
	// default constructor
	HashTable(int n = 88001);
	// destructor
	~HashTable(); 
	// get hash key
	unsigned long Hash(std::string value); 
	// insert key to hash table
	void insert(std::string value);
	// delete key
	void deleteEntry(std::string value);
	// search for key and print bucket number containing key
	void search(std::string value); 
	// save a file of the hash table buckets and corresponding values
	void saveLogFile(std::ofstream& out);
	// print summary metrics describing hash table
	void printSummary();

};
