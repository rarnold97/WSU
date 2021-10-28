function ent = calc_entropy(A)
%% calculates the entropy of given array or matrix
% A -> input image array data
% ent -> output entropy

% grab the dimensions of the array
dims = size(A) ; 

% error handle the input array
if length(dims) ~= 2
    error('invalid array, pass in a 1 or 2D array ...')
end

% calculate the size of the data
MN = dims(1) * dims(2) ; 

% going to assume that the images are to be 8 bit for the sake of this project
A_int = uint8(A) ; 

% find the unique symbols in the data array
C = unique(A) ; 

H = zeros(1, length(C)) ; 

for i = 1:length(C)
    % extract a unique symbol
    a = C(i) ;

    count = sum(A == a) ; 
    % handle 2D case as well
    if length(count) > 1
        count = sum(count);
    end

    pr = count / MN ; 

    H(i) = pr * log2(pr) ;
end

ent = -1.*sum(H) ;