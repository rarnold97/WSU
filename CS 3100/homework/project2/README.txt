CS 3100 Data Structures and Algorithms
Ryan Arnold
Dr.Meilin Liu
October. 12, 2020
Project 2: Array Based Stack

--- How to operate Ryan Arnold's stack project ---

Prep:
-Make sure to pass in 'all.last.txt' as the file arguement for the file reader.  defaulted to 'all.last.txt'

Explanation of interface:

-instantiated as follows:

    SStack <obj_name> ;
    or
    SStack <obj_name> = SStack(capacity);
    or
    SStack <obj_name> = SStack(SStack <another_stack>) ;

-constructor takes in a stack max capacity, defaulted to 100 if none are passed.
-copy constructor copies all the data from another stack to a new copy.

-push() adds an element to the top of the queue unless at max capacity.
-pop() removes an element from the top unless the stack is already empty.
-top() returns a constant value of the top element of the stack.
-IsEmpty() if the stack is empty , return true, else return false.
-print() prints the data of the stack to the screen.
-size() prints the length of the data array element.
-getCapacity() returns the max capacity of the stack to the screen.

private members:
-used (i.e., top) records the top element
-DynamicStack is a dynamically allocated array of strings
-Capacity holds the max capacity of the stack

Explanations of helper functions/objects:

-StackException:  Class as a generic exception for stacks
-StackEmpty/StackFull: both inherit the StackException class. Used throw stack errors.
 called when stacks are popped when empty and pushed when full.  Program will throw
 the exceptions

Explanations of supplemental functions:

- operator overload for + : when adding two stacks (stack1 + stack2) , reorders the stacks
  such that the stacks are placed on top of each other and a new stack is formed.
  ex: stack1 [1][2][3] + stack2 [4][5][6] = stack3 [1][2][3][4][5][6]
- equals() : checks to see that two stacks are equal, accepts two SStack types. returns true
 or false.
- skipLines() will skip lines at the beginning of a file based on the number provided.
 used to get next n names in the file so that the same n names are not always being
 duplicated.