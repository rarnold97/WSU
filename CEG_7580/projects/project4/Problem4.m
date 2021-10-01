function Problem4()

    files = {} ; 
    if nargin >=1 
        files = cell(varargin{1});
    else
        files = find_files_from_pattern('testpattern', '*.tif') ;

    radii = [60 160]; 

    % create figure handle
    fig = figure() ; 
    set(0, 'CurrentFigure', fig) ; 

    % set butterworth constant
    n = 2 ; 

    for f = files 
        file = f{1} ;

        I_int = imread(file) ; 
        I_double = im2double(I_int) ; 

        subplot(2,3,1)
        imshow(I_double)
        title('Original Image')

        Gxy_ideal_1 = freq_filter_image(I_double, P, Q, 'highpass', 'D0', radii(1), 'pass_type', 'ideal') ;  
        Gxy_ideal_2 = freq_filter_image(I_double, P, Q, 'highpass', 'D0', radii(2), 'pass_type', 'ideal') ; 

        Gxy_gauss_1 = freq_filter_image(I_double, P, Q, 'highpass', 'D0', radii(1), 'pass_type', 'gaussian') ; 
        Gxy_gauss_2 = freq_filter_image(I_double, P, Q, 'highpass', 'D0', radii(2), 'pass_type', 'gaussian') ;

        Gxy_butt_1 = freq_filter_image(I_double, P, Q, 'highpass', 'D0', radii(1), 'pass_type', 'butterworth', 'n', n);
        Gxy_butt_2 = freq_filter_image(I_double, P, Q, 'highpass', 'D0', radii(2), 'pass_type', 'butterworth', 'n', n);

    end



end