function [T1, T2] = GetThresholds(arr, method)

    % computes the thresholds from the array data using one of three methods:
    % 1 -> my minimax attempt implementation
    % 2 -> the thselect method
    % 3 -> built in wavelet method (also uses the same reference as the paper)
    %
    % in: arr -> array image data, method -> (int) 1-3
    %
    % out: The low and high thresholds
    %
    % not really sure which method will best implement minimax, since the it is poorly defined
    % in the journals and the references.  Not quite sure what the N parameter is.
    % is it a 1D parameter or 2D ???

    T1 = 0;

    switch method

        case 1
            T1 = minimax(arr);
        case 2
            arr1d = reshape(arr, 1, size(arr, 1) * size(arr, 2));
            T1 = thselect(arr1d, 'minimaxi');
        case 3
            %arr1d = reshape(arr, 1, size(arr, 1)*size(arr,2)) ;
            [T1, ~, ~] = ddencmp('den', 'wv', arr);
        otherwise
            error('invalid int for method, enter a value between 1-3 ...')
    end

    T2 = 2 * T1;

end
