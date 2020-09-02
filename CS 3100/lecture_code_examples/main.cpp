#include "intro_to_language.h"

//template for IO_example


using namespace std ;

int main() {
    //std::cout << "Hello, World!" << std::endl;

    //from the io lectures in the intro to c++ lectures

    //LECTURES 1-3
    //IO_example() ;
    //IO_manip() ;
    //read_write_textFiles() ;

    //LECTURE 4

    //int value = getValueInRange(-5,5)
    /**
     * int mvalue ;
     * getValueInRange(mvalue,-5,5) ;
     * cout << "The value retrieved is " <<mvalue <<endl;
     */

    /** call by reference:
     * type-name& parameter-name
     */

    int x = 10 ;
    int y = 20;

    swapByVal(x,y) ;
    cout<<"After SwapByVal"<<setw(5)<<x<<setw(5)<<y<<endl ;
    swapByRef(x,y) ;
    cout<<"After swapByRef"<<setw(5)<<x<<setw(5)<<y<<endl;

    int mvalue ;
    getValueInRange(mvalue) ;
    cout << "The value retrieved is " <<mvalue <<endl;



    //if using <cstlib>
    //return EXIT_SUCCESS;

    return 0 ; // 0 is for success
}

