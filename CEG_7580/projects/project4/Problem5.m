function Problem5(varargin)
 
    if nargin>=1
        files = {varargin{1}};
    else
        files = find_files_from_pattern('thumb','*.tif') ;
    end

    % create figure handle
    fig = figure() ; 
    set(0, 'CurrentFigure', fig) ; 

    for f = files
        file = f{1} ;

        I_int = imread(file) ;

        [M, N] = size(I_int) ; 
        P = 2*M ; 
        Q = 2*N ;

        %display original image
        subplot(1,3,1)
        imshow(I_int)
        title('Original Image')

        I_double = im2double(I_int) ; 

        % assuming that P and Q end up being 2*M and 2*N
        % going to use D0 = 10% padded image length
        %this can be changed as needed
        
        D0 = 0.10 * (2*length(I_double)) ;
 
        % gaussian transfer function, use highpass
        Gxy_double = freq_filter_image(I_double, P, Q, 'highpass', 'D0', D0, 'pass_type', 'gaussian') ; 

        % display result of high pass filter
        subplot(1,3,2)
        %imshow(uint8(Gxy_double))
        imshow(shift_image_values(Gxy_double))
        title('Result of High Pass Filtering')

        % use thresholding 
        G_high_double = Gxy_double ; 
        G_high_double(Gxy_double <= 0) = 0 ; 
        G_high_double(Gxy_double > 0) = 1;

        G_high_int = shift_image_values(G_high_double) ; 

        %display results
        subplot(1,3,3)
        imshow(G_high_int)
        title('Result of Thresholding')

    end

end


