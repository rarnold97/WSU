function Problem1(varargin)

    %assume default mask size
    mask_size = [3, 3] ;

    if nargin >=1
        files = {varargin{1}} ;
    else
        files = find_files_from_pattern('ckt_board_saltpep', '*.tif') ;
    end

    % retrieve block function handles
    fun_avg = get_filter_handle('average');
    fun_median = get_filter_handle('median');

    for f = files 
        file = f{1} ;

        % load in original image
        I_int = imread(file);
        I_double = im2double(I_int) ; 

        %display original image 
        %create figure handle
        fig = figure() ; 
        set(0, 'CurrentFigure', fig) ; 

        subplot(1,3,1)
        imshow(I_int)
        title('Original Image')

        % apply averaging filter
        I_avg_double = nlfilter(I_double, mask_size, fun_avg);

        % apply median filter
        I_med_double = nlfilter(I_double, mask_size, fun_median);

        % display and compare results graphically
        subplot(1,3, 2)
        imshow(shift_image_values(I_avg_double))
        title('Result of Averaging Filter')

        subplot(1,3,3)
        imshow(shift_image_values(I_med_double))
        title('Result of Median Filter')


    end
end