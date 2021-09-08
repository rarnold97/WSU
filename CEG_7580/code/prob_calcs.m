function P = prob_calcs(M, varargin)

    P = struct() ; 

    bits = 8 ;
    if nargin > 1
        bits = varargin{1} ; 
    end

    L = 2^bits - 1 ; 
    Levels = 0:1:L ; 

    K = length(Levels) ; 


end