/*
CS 3100 Data Structures and Algorithms
Ryan Arnold
Dr.Meilin Liu
December. 4, 2020
Bonus Project: Hash Table
*/

#include "HashTable.h"
#include <iomanip>

unsigned long sdbm(const char* str)
{
	unsigned long hashCode = 0; // initialize as zero as an unsigned long 
	// used for character arithmitic 
	int c;
	// loop through all characters in the string 
	while (c = *str++) 
	{
		// use all characters of the string to solve the hash code 
		hashCode = c + (hashCode << 6) + (hashCode << 16) - hashCode;
	}
	return hashCode;
}

HashTable::HashTable(int n)
{
	table = new bucket*[n]; // create an array of linked lists , where each ll is a bucket
	// set defaults
	occupied = 0; 
	longestList = 0;
	numKeys = 0; 
	nBuckets = n;
	loadFactor = 0.0; 
	// initialize initial values of the buckets to be NULL
	for (int i = 0; i < n; i++) table[i] = NULL; 
}

HashTable::~HashTable()
{
	//for (auto i = 0; i < nBuckets; i++) delete table[i]; 
	// free up dynamic memory 
	delete[] table; 
}

unsigned long HashTable::Hash(std::string value)
{
	// store the hash code 
	unsigned long hashCode = sdbm(value.c_str());
	// get the hash key using modular arithmitic
	return hashCode % nBuckets; 
}

void HashTable::insert(std::string value)
{
	// find the hash key 
	unsigned long Hk = Hash(value); 
	// case of empty bucket 
	if (table[Hk] == NULL) 
	{
		bucket* tmp = new bucket(); // crete new linked list 
		tmp->insert(value); // insert key to linked list 
		table[Hk] = tmp; // store in the hash table 
		++occupied; // update the number of occupied buckets 
		if (longestList == 0) longestList = 1; // replace longest list if none exist i.e., 0
	}
	else
	{
		// bucket is occupied, collision occurs 
		// pull existing chain of linked lists
		bucket* chain = table[Hk]; 
		// get the head 
		Node* tmp = chain->getHead(); 
		// boolean to track if there is a duplicate present
		bool isDup = false; 
		// start loop through linked list chain 
		while (tmp != NULL)
		{
			// check for duplicates
			if (tmp->value == value)
			{
				// duplicate found 
				isDup = true;
				std::cout << value << " is already in the Hash Table!" << std::endl;
				break;
			}
			tmp = tmp->next;
		}
		// we found a duplicate, do not insert and exit 
		if (isDup) return; 
		// no duplicate, insert in the chain 
		chain->insert(value); 
		// increase in size might make it the longest chain
		if (chain->size() > longestList) longestList = chain->size(); 
	}
	// increase the number of keys
	numKeys++; 
	// increase the load factor 
	loadFactor = float(numKeys) / float(nBuckets); 
}

void HashTable::deleteEntry(std::string value)
{
	// get the hash key of the input string ID
	unsigned long hk = Hash(value); 
	// get the linked list chain stored at the hash key in the hash table 
	bucket* chain = table[hk]; 
	// check if the bucket was unoccupied 
	if (chain == NULL)
	{
		// display to screen that the value is not found since bucket was empty
		std::cout << value << " not found, bucket empty!" << std::endl;
		return;
	}
	// get head to traverse linked list to search for key
	Node* tmp = chain->getHead(); 
	Node* oldtmp = tmp; 
	// traverse linked list 
	while (tmp != NULL)
	{
		if (tmp->value == value) // found the value
		{
			// display to user that the key was found 
			std::cout << tmp->value << " found at bucket # " << hk << ". Deleting..."
				<< std::endl;
			// fix the links that might be broken 
			oldtmp->next = tmp->next; 
			// delete entry
			delete tmp;  
			
			std::cout << value << " successfully deleted!" << std::endl;
			break;
		}
		else
		{
			// keep traversing 
			oldtmp = tmp;
			tmp = tmp->next;
		}
	}
	// element was never gfound throught the traversal 
	if (tmp == NULL) std::cout << value << " not found!" << std::endl; 
	return; 
	
}

void HashTable::search(std::string value)
{
	// get hash key 
	unsigned long Hk = Hash(value); 
	// retrieve from table 
	bucket* chain = table[Hk]; 
	if (chain == NULL)
	{
		// empty bucket 
		std::cout << value << " was not found in Hash Table!" << std::endl;
		return;
	}
	else
	{
		// cursor to check the nodes in the linked list
		Node* cursor = chain->getHead();
		// traverse the chain 
		while (cursor != NULL)
		{
			if (cursor->value == value)
			{
				// found the value, print it to the screen with the bucket hash number
				std::cout<< cursor->value << " was found in the hash table at bucket # " 
					<< Hk << std::endl;

				break;
			}
			else
			{
				// keep traversing 
				cursor = cursor->next; 
			}
		}
		// did not find the key in the list 
		if (cursor == NULL)
			std::cout << value << " was not found in Hash Table!" << std::endl;

		return; 
	}
}

void HashTable::saveLogFile(std::ofstream& out)
{
	//write header data
	out << std::setw(6)<<"Bucket #" << "  Last Name" << std::endl;
	std::cout<< std::endl; 
	// go through all the buckets 
	for (auto hk = 0; hk < nBuckets; hk++)
	{
		// print to file in clean format
		out << std::setw(6) << hk << " -> ";
		// put elememnt in 
		bucket* chain = table[hk]; 
		if (chain == NULL) {
			//out << "NULL" << std::endl;
			// indicate empty balue 
			out << "NULL" ;
		}
		else
		{
			// print the rest of the chain to the file to the correct bucket
			Node* tmp = chain->getHead();
			while (tmp != NULL)
			{
				out << tmp->value;
				if (tmp->next != NULL) out << " -> ";
				tmp = tmp->next; 
			}
		}

		out << std::endl; 	
	}
}

void HashTable::printSummary()
{
	// print the summary metrics concerning hash table 
	std::cout << "____Hash Table Summary____" << std::endl; 
	std::cout << "Occupied Buckets     -> " << occupied << std::endl;
	std::cout << "Unoccupied Buckets   -> " << nBuckets - occupied << std::endl;
	std::cout << "Load Factor          -> " << loadFactor << std::endl;
	std::cout << "Longest chain length -> " << longestList << std::endl;
	std::cout << std::endl;
}
