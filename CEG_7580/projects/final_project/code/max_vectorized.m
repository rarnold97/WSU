function maxElements = max_vectorized(cellArr)

    arr = cat(3, cellArr{:}) ; 
    maxElements = max(arr, [], 3) ; 

end