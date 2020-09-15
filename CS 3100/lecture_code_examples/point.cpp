//
// Created by root on 9/9/20.
#include "point.h"
#include <iostream>
// point.h implementation

point::point(double init_x , double init_y )
{
    std::cout << "constructor is called" << std::endl ;
    this->x = init_x ;
    this->y = init_y ;
}

point::point(const point& p)
{
    std::cout << " copy constructor is called" <<std::endl;
    x = p.get_x();
    y= p.y;
}

point::~point()
{
    std::cout << "The destructor is called when the point object goes out of scope" << std::endl ;
}

void point::shift(double x_amount, double y_amount)
{
    x += x_amount ;
    y += y_amount ;
}

void point::rotate90()
{
    double new_x ;
    double new_y ;

    new_x = y;  // For a 90 degree clockwise rotation, the new x is the original y,
    new_y = -x; // and the new y is -1 times the original x.
    x = new_x;
    y = new_y;
}

bool operator==(const point& p1, const point& p2)
{
    return p1.get_x() == p2.get_x()
    && p1.get_y() == p2.get_x() ;
}

bool operator !=(const point& p1, const point& p2)
{
    return !(p1 == p2) ;
}

point operator +(const point& p1, const point& p2)
{
    double x_sum, y_sum ; 

    x_sum = p1.get_x() + p2.get_x() ; 
    y_sum = p1.get_y() + p2.get_y();

    point sum(x_sum, y_sum);
    return sum ; 
}

std::ostream& operator <<(std::ostream& outs, const point& source)
{
    outs<< source.get_x() << " " << source.get_y() ; 
}
//

point middle(const point p1, const point p2)
{
    double new_x = (p1.get_x() + p2.get_x())/2;
    double new_y = (p2.get_y() + p2.get_y())/2;

    new_point = point(new_x, new_y) ;
    return new_point ; 
}

double distance(const point& p1, const point& p2)
{
    double distance;

    double x_dist = std::pow((p2.get_x() - p1.get_x(), 2) ; 
    double y_dist = std::pow(p2.get_y(), - p1.get_y(), 2 ) ; 

    distance = std::sqrt(x_dist+y_dist) ; 
    return distance ; 
}

std::istream& operator>>(std::istream& ins, point& target)
{
    ins>> point.x >> point.y ; 
}