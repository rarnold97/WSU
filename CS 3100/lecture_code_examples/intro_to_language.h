//
// Created by root on 9/2/20.
//

#ifndef LECTURE_CODE_EXAMPLES_INTRO_TO_LANGUAGE_H
#define LECTURE_CODE_EXAMPLES_INTRO_TO_LANGUAGE_H

#include <iostream>
#include <cstdlib>
#include <iomanip>
#include <fstream>
#include <cassert>
#include <string>

//LECTURES 1-3
void IO_example() ;
void IO_manip() ;
void read_write_textFiles() ;
void assert_test();

//LECTURE 4-

//defaults only need to be defined in the function prototype
int getValueInRange(int minV = 0, int maxV = 100) ;

//parameter passing

void getValueInRange(int&, int=0, int=100) ;

void swapByVal(int a, int b) ;
void swapByRef(int& a, int& b) ;
#endif //LECTURE_CODE_EXAMPLES_INTRO_TO_LANGUAGE_H
