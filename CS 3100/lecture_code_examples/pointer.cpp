//
// Created by ryan.arnold on 9/14/20.
// LECTURE 6
//

#include <iostream>
#include <cstdlib>
#include <iomanip>

using namespace std;

int pointer_example()
{

    int x =20;
    int *p; // p is a varialbe that holds the address of a memory location for an
// integer
    cout << "The value of x is " << x << endl;
    p=&x;


    cout << "The value that p points to is " << *p << endl;
    cout << "The address of p is " << &p << endl;

    cout << "The value that p points to is " << *p << endl;
    cout << " The address of variable x is " << &x << endl;

    *p=50;


    cout << "The value of x  now is " << *p << endl;

    p = new int;

    *p= 100;


    cout << "The value that p points to is " << *p << endl;

    cout << "The value of x  now is " << x << endl;

    int *A;

    A = new int[3];

    A[0]=100; // *A = 100

    A[1]=200; // *(A+1)= 200

    A[2]=300;

    delete p;

    cout << "Pringing out dynamic array A: " << setw(6) << A[0] << setw(6) << A[1] << setw(6) << A[2] << endl;

    delete [] A;

    int B[3];

    B[0]=10;
    B[1]=20;
    B[2]=30;


    cout << "Pringing out array B: " << setw(6) << B[0] << setw(6) << B[1] << setw(6) << B[2] << endl;


    return EXIT_SUCCESS;

}