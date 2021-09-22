function Problem4()
    
%for my sanity, clear all the figures
close all

    %setting power law coefficient constants
    c_power = 1.0 ; 
    gamma_power = 0.5 ; 

    %find correct file name using substring search
    files = find_files_from_pattern('0363');

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
        title('Original Image')

        I_double = im2double(I) ; 

        %apply laplacian
        fun_lap = get_filter_handle('laplace') ; 
        I_laplace_double = nlfilter(I_double, [3,3], fun_lap) ; 

        %shift values back to 0 - 255
        I_laplace_int = shift_image_values(I_laplace_double) ; 

        %plot laplacian transform
        subplot(2,4, 2)
        imshow(I_laplace_int)
        title('Laplacian of Original Image')

        % add the laplace to the original image
        I_lap_plus_orig_int = shift_image_values(I_laplace_int + I) ; 

        subplot(2,4, 3)
        imshow(I_lap_plus_orig_int)
        title('Laplace + Original')

        

    end

end