function P = prob_calcs(M, varargin)
    %%
    % accepts a 2D matrix of image values and a variable lengthed arg for 'bitness'
    % defaults to assuming 8-bit image
    % returns a struct with probability information

    P = struct() ; 

    bits = 8 ;
    if nargin > 1
        bits = varargin{1} ; 
    end

    L = 2^bits - 1 ; 
    Levels = 0:1:L ; 
    dims = size(M) ; 

    %assuming that the matrix is 2 dimensional
    NM = dims(1) * dims(2) ; 
    K = length(Levels) ; 
    hk = zeros(1, K)

    for i - 1:K
        hk(i) = sum(sum(M(M==Levels(i)))) ; 
    end

    pr = hk ./ NM ; 

    Sk = zeros(1, K) ; 

    for i = 1:K
        Sk(i) = L * sum(pr(1:k)) ; 
    end

    P.Sk = Sk ; 
    P.pr = pr ; 

end