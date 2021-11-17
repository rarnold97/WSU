%% Main Routine 
% ensure that all image files are in the same root/working directory 
% if using a custom image path is preferred, pass it in as the arguement to ProblemN(filename)
% if it is desired to produce a histogram, pass (true/false) in either exclusively as the first arg or the second
% arg followed by the file pattern.  The file pattern or filename can be entered as varargin{1}
% for default behavior, assuming that the images are in the same directory as all the scripts,
% run as is 

% close all existing figures 
close all

Problem1() ; 
% show histogram
%Problem1(true) ; 

Problem2() ; 
% show histogram
%Problem2(true) ; 

Problem3() ;

Problem4() ; 

Problem5() ; 
% show histogram
%Problem5(true) ; 