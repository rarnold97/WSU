#include "HashTable.h"
#include <iomanip>

unsigned long sdbm(const char* str){	unsigned long hashCode = 0;	int c;	while (c = *str++)	{		hashCode = c + (hashCode << 6) + (hashCode << 16) - hashCode;	}	return hashCode;}

HashTable::HashTable(int n)
{
	table = new bucket*[n]; 
	occupied = 0; 
	longestList = 0;
	numKeys = 0; 
	nBuckets = n;
	loadFactor = 0.0; 

	for (int i = 0; i < n; i++) table[i] = NULL; 
}

HashTable::~HashTable()
{
	//for (auto i = 0; i < nBuckets; i++) delete table[i]; 
	delete[] table; 
}

unsigned long HashTable::Hash(std::string value)
{
	unsigned long hashCode = sdbm(value.c_str());
	return hashCode % nBuckets; 
}

void HashTable::insert(std::string value)
{
	unsigned long Hk = Hash(value); 
	if (table[Hk] == NULL)
	{
		bucket* tmp = new bucket(); 
		tmp->insert(value); 
		table[Hk] = tmp; 
		++occupied; 
		if (longestList == 0) longestList = 1; 
	}
	else
	{
		bucket* chain = table[Hk]; 
		Node* tmp = chain->getHead(); 

		bool isDup = false; 

		while (tmp != NULL)
		{
			if (tmp->value == value)
			{
				isDup = true;
				std::cout << value << " is already in the Hash Table!" << std::endl;
				break;
			}
			tmp = tmp->next;
		}

		if (isDup) return; 

		chain->insert(value); 
		if (chain->size() > longestList) longestList = chain->size(); 
	}

	numKeys++; 
	loadFactor = float(numKeys) / float(nBuckets); 
}

void HashTable::deleteEntry(std::string value)
{
	unsigned long hk = Hash(value); 

	bucket* chain = table[hk]; 

	if (chain == NULL)
	{
		std::cout << value << " not found, bucket empty!" << std::endl;
		return;
	}

	Node* tmp = chain->getHead(); 
	Node* oldtmp = tmp; 

	while (tmp != NULL)
	{
		if (tmp->value == value)
		{
			std::cout << tmp->value << " found at bucket # " << hk << ". Deleting..."
				<< std::endl;

			oldtmp->next = tmp->next; 

			delete tmp;  

			std::cout << value << " successfully deleted!" << std::endl;
			break;
		}
		else
		{
			oldtmp = tmp;
			tmp = tmp->next;
		}
	}

	if (tmp = NULL) std::cout << value << " not found!" << std::endl; 
	return; 
	
}

void HashTable::search(std::string value)
{
	unsigned long Hk = Hash(value); 
	bucket* chain = table[Hk]; 
	if (chain == NULL)
	{
		std::cout << value << " was not found in Hash Table!" << std::endl;
		return;
	}
	else
	{
		Node* cursor = chain->getHead();

		while (cursor != NULL)
		{
			if (cursor->value == value)
			{
				std::cout<< cursor->value << " was found in the hash table at bucket # " 
					<< Hk << std::endl;

				break;
			}
			else
			{
				cursor = cursor->next; 
			}
		}

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

	for (auto hk = 0; hk < nBuckets; hk++)
	{
		out << std::setw(6) << hk << " -> ";
		bucket* chain = table[hk]; 
		if (chain == NULL) {
			//out << "NULL" << std::endl;
			out << "NULL" ;
		}
		else
		{
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
	std::cout << "____Hash Table Summary____" << std::endl; 
	std::cout << "Occupied Buckets     -> " << occupied << std::endl;
	std::cout << "Unoccupied Buckets   -> " << nBuckets - occupied << std::endl;
	std::cout << "Load Factor          -> " << loadFactor << std::endl;
	std::cout << "Longest chain length -> " << longestList << std::endl;
	std::cout << std::endl;
}
