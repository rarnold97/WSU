function Gxy = freq_filter_image(I, P, Q, filterType, varargin)
% Pre processes image for frequency filtering
% I -> Image data matrix
% * variable arguements
% arg1 -> P (pad dim1)
% arg2 -> Q (pad dim2)

    % default values of potential user options
    options = struct('D0',50,'n',1,'center',[], 'pass_type', 'gaussian');

    options = parse_inputs(options, varargin) ;

    %get dimensions of input image
    [M, N] = size(I) ; 

    %first, zero pad. Gonna assume that it is gonna be twice the dimension for now unless the user specifies
    % use the user passed dimensions for padding parameters
    pad = zeros(P,Q) ; 
    pad(1:M, 1:N) = I ; 
    %pad = padarray(I, [(P-M)/2, (Q-N)/2]) ; 
    
    [Y, X] = meshgrid(1:Q, 1:P) ; 

    % now center the image 
    Fxy = (-1).^(X+Y) .* pad ; 

    % apply fourier transform
    Fuv = fft2(Fxy) ;
    
    % return frequency domain data if that is all the user wants,
    % as opposed to applying a transfer function
    if strcmp(filterType, 'dft')
        Gxy = Fuv ;
        return 
    end


    %retrieve transfer function on a P by Q grid
    [v, u] = meshgrid(1:Q, 1:P) ;

    Huv = get_freq_transfer_fun(u, v, filterType, options) ; 
    % apply the transfer function to the Frequency domain image
    %Guv = real(Huv) .* real(Fuv) + imag(Huv).*imag(Fuv) ; 
    Guv = Huv.* Fuv ; 

    % go back to the spatial domain
    gp_xy = real(ifft2(Guv)) .*((-1).^(X+Y)) ; 

    Gxy = gp_xy(1:M, 1:N) ;

end