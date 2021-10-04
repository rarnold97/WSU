function Problem3(varargin)

    % load in file name. let TA pass it in to function if they wish
    files = {};

    if nargin >= 1
        files = cell(varargin{1}) ; 
    else
        files = find_files_from_pattern('testpattern','*.tif') ;
    end

    % array of cutoff frequencies
    radii = [10 30 60 160 460];

    % create figure handle
    fig = figure() ; 
    set(0, 'CurrentFigure', fig) ; 

    for f= files
        file = f{1};
        %load image
        I_int = imread(file) ; 
        I_double = im2double(I_int);
        
        % plot original image
        subplot(2,3,1)
        imshow(I_int)
        title('Original Image')

        % set padding parameters P and Q
        [M, N] = size(I_double);
        P = 2*M ; 
        Q = 2*N ; 
        
        % loop through all the cutoff frequencies and apply gaussian lowpass filter
        i = 2 ; 
        for D0 = radii
            % Filtered data after applying transfer function
            Gxy = freq_filter_image(I_double, P, Q, 'lowpass', 'D0', D0, 'pass_type', 'gaussian') ;
            % display filtered results at different cutoff frequencies
            subplot(2, 3, i)
            imshow(shift_image_values(Gxy))
            title(strcat('Cutoff Freq. = ', num2str(D0)))
            i = i + 1 ;
        end
    end

end