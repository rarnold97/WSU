#ifndef CIRCULARQUEUE_H
#define CIRCULARQUEUE_H

#include <iostream>

template <typename T>
class CircQueue{

    private:

        T* items; 
        int front ; 
        int rear ; 
        int SIZE ; 

    public:

        CircQueue()
        {
            T tmp[10];
            items = tmp ; 

            front = -1 ; 
            rear = -1 ; 
            SIZE = 10 ; 
        }

        CircQueue(const int n)
        {
            T tmp[n]; 
            items = tmp ; 

            front = -1 ; 
            rear = -1 ;

            SIZE = n ; 
        }

        // check if queue is full
        bool isFull()
        {
            if (front ==0 && rear == SIZE - 1)
            {
                return true ; 
            }
            if (front == rear + 1)
            {
                return true ; 
            }

            return false; 
        }

        // check if queue is empty 
        bool isEmpty()
        {
            if (front == -1)
                return true;
            else 
                return false ; 
        }

        // Adding Element
        void enQueue(T element)
        {
            if (isFull()){
                std::cout << "Queue is full" << std::endl; 
            }
            else{
                if (front == -1) front = 0 ;
                rear = (rear + 1) % SIZE ; 
                items[rear] = element ; 
            }
        }

        //Removing and element
        T deQueue(){
            T element ; 
            if (isEmpty()){
                std::cout<< "Queue is empty" << std::endl ; 
                return NULL ; 
            }
            else 
            {
                element = items[front] ; 

                // Q has only one element so we reset the queue after deleting it
                if (front == rear){
                    front = -1 ;
                    rear = -1 ;
                }
                
                else 
                {
                    front = (front + 1) % SIZE ; 
                }
                return (element) ; 
            }
        }

        void display()
        {
            // function to print the contents of the circular array 
            int i ; 

            if (isEmpty())
            {
                std::cout << "Empty Queue" << std::endl ; 
            }
            else
            {
                std::cout<< "Front -> " << front ; 
                std::cout << std::endl 
                << "Items -> ";

                for (i=front; i!=rear; i = (i+1) % SIZE)
                    std::cout << items[i] << " " ; 

                std::cout << items[i] ; 
                std::cout << std::endl 
                    << "Rear -> " << rear ; 

            }
        }

};



#endif