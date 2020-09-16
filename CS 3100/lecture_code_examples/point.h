//
// Created by root on 9/9/20.
//

#ifndef LECTURE_CODE_EXAMPLES_POINT_H
#define LECTURE_CODE_EXAMPLES_POINT_H

// header definition provides the interface
class point
{
public:
    // constructor
    point(double init_x = 0.0, double init_y = 0.0) ;
    // copy constructor
    point(const point& p);

    // modification methods
    void shift(double dx, double dy);
    void rotate90() ;

    // constant member getters
    inline double get_x() const {return x;}
    inline double get_y() const  {return y;}
    // destructor
    ~point();
private:
    double x ;
    double y ;
};

// operator overload
bool operator==(const point& p1, const point& p2);

#endif //LECTURE_CODE_EXAMPLES_POINT_H