function dblThreshMat = double_thresh(I, lowT, highT)

    [M, N] =  size(I) ; 
    dblThreshMat = zeros([M, N])

    weak = 25 ; strong = 255 ; 

    dblThreshMat(and(I >= lowT, I <= highT)) = weak ;
    dblThreshMat(I > highT) = strong ; 

end