#include "intro_to_language.h"
#include <cstdlib>
#include "point.h"

//template for IO_example
int pointClassDemo() ;

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

    /*
    int x = 10 ;
    int y = 20;

    swapByVal(x,y) ;
    cout<<"After SwapByVal"<<setw(5)<<x<<setw(5)<<y<<endl ;
    swapByRef(x,y) ;
    cout<<"After swapByRef"<<setw(5)<<x<<setw(5)<<y<<endl;

    int mvalue ;
    getValueInRange(mvalue) ;
    cout << "The value retrieved is " <<mvalue <<endl;
     */


    pointClassDemo() ;

    //if using <cstlib>
    //return EXIT_SUCCESS;

    return 0 ; // 0 is for success
}

int pointClassDemo()
{
    point sample(6, -4);

    point sample1;

    point sample2 (sample);

    point sample3= sample1;

    cout << " x coordinate is " << sample.get_x()  << " y coordinate is " << sample.get_y() << endl;
    cout << " x coordinate is " << sample2.get_x()  << " y coordinate is " << sample2.get_y() << endl;


    cout << " x coordinate is " << sample1.get_x()  << " y coordinate is " << sample1.get_y() << endl;

    cout << " x coordinate is " << sample3.get_x()  << " y coordinate is " << sample3.get_y() << endl;

    sample.rotate90();

    cout << " After rotation,  x coordidate is " << sample.get_x() << " y coordinate is " <<
         sample.get_y() << endl;

    sample.shift(1.0, 2.0);
    if ( sample2 == sample) {
        cout << " these two points are the same" << endl;
    }

    cout << " After shift,  x coordidate is " << sample.get_x() << " y coordinate is "
         << sample.get_y() << endl;

    cout << "All the member functions have been tested." << endl;

    return EXIT_SUCCESS;

}