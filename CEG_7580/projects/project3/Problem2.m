function Problem2(varargin)

    mask_size = [3,3] ; 

    % Retrieve Block Processing function handles and load image
    if nargin >=1
        files = {varargin{1}} ;
    else
        files = find_files_from_pattern('blurry_moon', '*.tif') ;
    end
    
    fun_lap_a = get_filter_handle('laplace', 'a') ;
    fun_lap_b = get_filter_handle('laplace', 'b') ;

    for f = files 
        file = f{1} ; 
        I_int = imread(file) ; 
        I_double = im2double(I_int);

        %display original image 
        %create figure handle
        fig = figure() ; 
        set(0, 'CurrentFigure', fig) ; 

        subplot(2,2, 1)
        imshow(I_int)
        title('Original Image')

        % apply laplacian using fig 3.45a kernel
        I_lap_a_double = nlfilter(I_double, mask_size, fun_lap_a) ;
        % apply laplacian using fig 3.45b kernel
        I_lap_b_double = nlfilter(I_double, mask_size, fun_lap_b) ;

        subplot(2,2, 2)
        %I am multiplying by -1 here because in my filter function, I preapply the constant c in Equation 3-54
        imshow(shift_image_values(-1*I_lap_a_double))
        title('Laplace using Kernel in Fig 3.45a')
        
        I_gxy_a_double = I_double + I_lap_a_double ; 
        
        I_gxy_b_double = I_double + I_lap_b_double ;

        subplot(2,2, 3)
        imshow(shift_image_values(I_gxy_a_double))
        title('Image sharpened with c=-1, kernel Fig 3.45a')

        subplot(2,2, 4)
        imshow(shift_image_values(I_gxy_b_double))
        title('Image sharpened with c=-1, kernel Fig 3.45b')

    end



end