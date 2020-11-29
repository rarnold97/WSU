#pragma once

#include <iostream>
#include <string>
#include <fstream>
#include "LinkedSortedList.h"

unsigned long sdbm(const char* str); 

typedef LinkedSortedList bucket; 

class HashTable
{
protected:
	int nBuckets; 
	int occupied;
	int longestList;
	int numKeys; 
	float loadFactor;

	bucket** table; 

public:

	struct entry {
		unsigned long key; 
		std::string value; 
	};

	HashTable(int n = 88001);

	~HashTable(); 

	unsigned long Hash(std::string value); 

	void insert(std::string value);

	void deleteEntry(std::string value);

	void search(std::string value); 

	void saveLogFile(std::ofstream& out);

	void printSummary();

};
