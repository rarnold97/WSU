function Problem3(varargin)

    files = {};

    if nargin >= 1
        files = cell(varargin{1}) ; 
    else
        files = find_files_from_pattern('testpattern','*.tif') ;
    end

    radii = [10 30 60 160 460];

    % create figure handle
    fig = figure() ; 
    set(0, 'CurrentFigure', fig) ; 

    for f= files
        file = f{1};
        I_int = imread(file) ; 
        I_double = im2double(I_int);
        
        subplot(2,3,1)
        imshow(I_int)
        title('Original Image')

        [M, N] = size(I_double);
        P = 2*M ; 
        Q = 2*N ; 
        
        i = 2 ; 
        for D0 = radii

            Gxy = freq_filter_image(I_double, P, Q, 'lowpass', 'D0', D0, 'pass_type', 'gaussian') ;

            subplot(2, 3, i)
            imshow(shift_image_values(Gxy))
            title(strcat('Cutoff Freq. = ', num2str(D0)))
            i = i + 1 ;
        end
    end

end