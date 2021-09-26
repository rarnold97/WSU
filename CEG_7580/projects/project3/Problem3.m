function Problem3(varargin)

    %comment to remove this behavior, uncomment to clear plots
    %close all

    % set the mask size
    mask_size = [5, 5] ;

    k_unsharp = 1.0 ; 
    k_highboost = 2.0 ;

    %retrieve function handles 
    fun_gauss = get_filter_handle('gaussian', mask_size, 1.0, 1.0) ;

    %load image file
    if nargin >=1
        files = {varargin{1}} ;
    else
        files = find_files_from_pattern('blurry_moon', '*.tif') ; 
    end

    %part a)
    for f = files 
        file = f{1} ; 
        I_int = imread(file);
        I_double = im2double(I_int) ; 

        % apply unsharp masking to blurry moon
        I_blurr_double = nlfilter(I_double, mask_size, fun_gauss) ; 
        %sigma was chosen based on trial and error
        %I_blurr_double = imgaussfilt(I_double, 1) ;
        
        %subtract blurred image from original to generate mask
        I_mask_double = I_double - I_blurr_double ; 
        %add mask to original
        I_unsharp_double = I_double + k_unsharp .* I_mask_double ; 
        % add mask multiplied by high boost factor to original
        I_unsharp_int = shift_image_values(I_unsharp_double) ; 

        %display result from part a)
        %setup plot object
        fig = figure() ; 
        set(0, 'CurrentFigure', fig) ; 

        %show original image first 
        subplot(2,2, 1)
        imshow(I_double)
        title('Original Image')
        
        %Display Blurred Gaussian Image
        subplot(2,2,2)
        imshow(shift_image_values(I_blurr_double))
        title('Blurred gaussian filtered image')
        
        subplot(2,2, 3)
        imshow(I_unsharp_int)
        title('Result of Unsharp Masking')

        %commence part b)

        I_highboost_double = I_double + k_highboost .* I_mask_double ; 
        I_highboost_int = shift_image_values(I_highboost_double) ;

        subplot(2,2, 4)
        imshow(I_highboost_int)
        title(strcat('Result of Highboost Filtering k = ', num2str(k_highboost) ))
    end

end