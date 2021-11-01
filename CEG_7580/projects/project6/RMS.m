function err = RMS(I, fhat)
%% 2D abstraction of toolbox rms() function
% makes it less of a pain to perform on 2D image arrays
% I -> input image values
% fhat -> reconstructed image estimage
% err -> output rms error

    err = nan ; 
    dims = size(I) ; 
    dims_hat = size(fhat);
    % error handle input sizes 
    if dims(1) ~= dims_hat(1) || dims(2) ~= dims_hat(2)
        error('missmatched array dimensions ...')
    end

    I_flat = reshape(I, 1, dims(1)*dims(2)) ; 
    hat_flat = reshape(fhat, 1, dims(1)*dims(2)) ;
    err = rms(hat_flat - I_flat) ; 

end