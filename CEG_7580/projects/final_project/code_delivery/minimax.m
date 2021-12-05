function lambda_star = minimax(arr)

    % not sure of this is a column/row-wise operation, this may need changing (in the house of flies)?
    arr_size = 0;

    if size(arr, 1) == 1 || size(arr, 2) == 1
        arr_size = length(arr) ; 
    else
        %arr_size = size(arr, 1) * size(arr, 2);
        arr_size = max(size(arr,1), size(arr,2)) ; 
    end

    % from what I can tell this is a soft thresholding method ??

    % each index is a power of 2
    lamlist = [0 0 0 0 0 1.27 1.47 1.67 1.86 2.05 2.23 2.41 2.6 2.77 2.95 3.13 3.310];
    pows2 = 2.^(0:1:16);

    n = 2^nextpow2(arr_size);

    ind = find(n == pows2, 1);
    
    if ~isempty(ind)
        % also not too sure what lambda star is really even used for ????
        lambda_star = lamlist(ind);
    else
        lambda_star = lamlist(end) ; 
    end

end
