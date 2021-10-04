function Problem4(varargin)

    % load in file name. let TA pass it in to function if they wish
    files = {} ; 
    if nargin >=1 
        files = cell(varargin{1});
    else
        files = find_files_from_pattern('testpattern', '*.tif') ;
    end

    % the two cutoff frequencies to test 
    radii = [60 160]; 

    % set butterworth constant
    n = 2 ; 

    for f = files 
        file = f{1} ;
        % load image
        I_int = imread(file) ; 
        I_double = im2double(I_int) ; 

        [M,N] = size(I_double);
        P = 2*M ; 
        Q = 2*N;

        % create figure handle
        fig1 = figure() ; 
        set(0, 'CurrentFigure', fig1) ; 

        imshow(I_double)
        title('Original Image')

        % create figure handle
        fig2 = figure() ; 
        set(0, 'CurrentFigure', fig2) ; 

        % get transformed image based on frequency filtering techniques of ideal, gaussian, and butterworth highpass filters

        Gxy_ideal_1 = freq_filter_image(I_double, P, Q, 'highpass', 'D0', radii(1), 'pass_type', 'ideal') ;  
        Gxy_ideal_2 = freq_filter_image(I_double, P, Q, 'highpass', 'D0', radii(2), 'pass_type', 'ideal') ; 

        Gxy_gauss_1 = freq_filter_image(I_double, P, Q, 'highpass', 'D0', radii(1), 'pass_type', 'gaussian') ; 
        Gxy_gauss_2 = freq_filter_image(I_double, P, Q, 'highpass', 'D0', radii(2), 'pass_type', 'gaussian') ;

        Gxy_butt_1 = freq_filter_image(I_double, P, Q, 'highpass', 'D0', radii(1), 'pass_type', 'butterworth', 'n', n);
        Gxy_butt_2 = freq_filter_image(I_double, P, Q, 'highpass', 'D0', radii(2), 'pass_type', 'butterworth', 'n', n);

        % display results 
        subplot(2,3,1)
        imshow(Gxy_ideal_1)
        title(['Ideal Highpass Filter, D0 = ', num2str(radii(1))])

        subplot(2,3,2)
        imshow(Gxy_ideal_2)
        title(['Ideal Highpass Filter, D0 = ', num2str(radii(2))])

        subplot(2,3,3)
        imshow(Gxy_gauss_1)
        title(['Gaussian Highpass Filter, D0 = ', num2str(radii(1))])
        
        subplot(2,3,4)
        imshow(Gxy_gauss_2)
        title(['Gaussian Highpass Filter, D0 = ', num2str(radii(2))])

        subplot(2,3,5)
        imshow(Gxy_butt_1)
        title(['Butterworth Highpass Filter, D0 = ', num2str(radii(1))])

        subplot(2,3,6)
        imshow(Gxy_butt_2)
        title(['Butterworth Highpass Filter, D0 = ', num2str(radii(2))])

    end



end