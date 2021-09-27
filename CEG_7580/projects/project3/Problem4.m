function Problem4(varargin)
    
%for my sanity, clear all the figures
%close all

    %setting power law coefficient constants
    c_power = 1.0 ; 
    gamma_power = 0.5 ; 

    %find correct file name using substring search
    if nargin >=1
        files = {varargin{1}} ;
    else
        files = find_files_from_pattern('skeleton_orig', '*.tif') ; 
    end

    %should only be a single file, but to be safe, do a loop

    for f = files

        file = f{1} ; 
        %load in original image 
        I = imread(file) ; 

        %setup plot objects
        fig = figure() ; 
        set(0, 'CurrentFigure', fig) ; 

        %display original image
        subplot(2,4, 1)
        imshow(I) 
        title('a) Original Image')

        I_double = im2double(I) ; 

        %grab required function handles for spatial processing
        fun_lap = get_filter_handle('laplace') ; 
        fun_gradient = get_filter_handle('sobel');
        fun_box = get_filter_handle('box') ;

        %apply laplacian, part b)
        I_laplace_double = nlfilter(I_double, [3,3], fun_lap) ; 

        %shift values back to 0 - 255
        I_laplace_int = shift_image_values(I_laplace_double) ; 

        %plot laplacian transform
        subplot(2,4, 2)
        imshow(I_laplace_int)
        title('b) Laplacian of Original Image')

        % this is the extra step that the book does to obtain the blurred image in c)
        %modify laplacian by virtue of smoothing and masking (we will use gaussian for lowpass here)
        
        I_gradient_double = nlfilter(I_double, [3,3], fun_gradient) ; 

        I_grad_smooth_double = imgaussfilt(I_gradient_double) ;

        I_lap_times_grad_double = I_grad_smooth_double .* I_laplace_double ; 

        % add the laplace to the original image
        I_lap_plus_orig_int = shift_image_values(I_lap_times_grad_double + I_double) ; 

        subplot(2,4, 3)
        imshow(I_lap_plus_orig_int)
        title('c) Laplace + Original')
        
        %commence part d) hommies
        
        %sobel gradient was already computed previously , so just display it 
        I_sobel_int = shift_image_values(I_gradient_double) ; 

        subplot(2,4, 4)
        imshow(I_sobel_int)
        title('d) Sobel Gradient Image')

        %part e) baby
        %now smooth the sobel gradient image using a 5x5 box filter (default is 5x5 in filter handle)
        I_smooth_sobel_double = nlfilter(I_gradient_double, [5,5], fun_box) ; 
        I_smooth_sobel_int = shift_image_values(I_smooth_sobel_double) ; 

        %display smoothed sobel gradient image
        subplot(2,4, 5)
        imshow(I_smooth_sobel_int)
        title('e) 5X5 Box Filtered Sobel Gradient Image')

        % part f) home stretch 
        % multiply the result of part b) with part e)
        Lap_times_smooth_sobel_double = I_smooth_sobel_double .* I_laplace_double ; 
        Lap_times_smooth_sobel_int = shift_image_values(Lap_times_smooth_sobel_double);

        %display results
        subplot(2,4, 6)
        imshow(Lap_times_smooth_sobel_int) ;
        title('f) Product of Laplace and Smoothed Gradient Image')

        % part g) I can almost taste it ...
        % add part f) to original image
        I_orig_plus_f_double = Lap_times_smooth_sobel_double + I_double ; 
        I_orig_plus_f_int = shift_image_values(I_orig_plus_f_double) ; 

        %display part f results
        subplot(2,4, 7)
        imshow(I_orig_plus_f_int)
        title('g) Part f. Mask Plus Original')

        % part h) do the power law transform as the last step
        % perform power law using function on previous result
        I_final_int = power_xform(I_orig_plus_f_double, c_power, gamma_power);

        %display final results

        subplot(2,4, 8)
        imshow(I_final_int)
        title('h) Final Image after Power Xform')

        % BOOM TOUCHDOWN !
    end

end