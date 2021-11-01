function I_decimated = rowcoldel(I)

oldDims = size(I) ;

delRows = 1:2:oldDims(1) ; 
delCols = 1:2:oldDims(2) ; 

I(delRows, :) = [] ;
I(:, delCols) = [] ; 

I_decimated = I ; 

end