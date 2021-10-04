function Problem2(varargin)

    % load in file name. let TA pass it in to function if they wish
    if nargin >=1 
        files = cell(varargin{1});
    else
        files = find_files_from_pattern('testpattern','*.tif');
    end

    for f = files 
        file = f{1} ; 
        % load in original image 
        I_int = imread(file);
        I_double = im2double(I_int) ; 

        [M,N] = size(I_double) ; 
        P = 2 * M ; 
        Q = 2 * N ;

        % create a padded image where the dimensions are twice that of the input image
        padded = zeros(P,Q) ; 
        [Y,X] = meshgrid(1:Q, 1:P) ; 
        % paste the input image over the pad template
        padded(1:M, 1:N) = I_double ; 

        % center the image for the dft
        Fxy = padded .* (-1.^(X+Y)) ;
        
        % perform fast fourier transform on 2D matrix
        dft = fft2(Fxy) ;
        
        %compute the magnitude 
        spectrum = sqrt(real(dft).^2 + imag(dft).^2) ;
        % convert spectrum to decibel
        spectrum = 20*log10(spectrum) ;
       
        % create figure handle
        fig = figure() ; 
        set(0, 'CurrentFigure', fig) ; 

        % show results
        subplot(1,2,1)
        imshow(I_int)
        title('Original Image')

        subplot(1,2,2)
        %convert to int so that the data renders properly using imshow()
        %imshow(shift_image_values(spectrum))
        imshow(uint8(spectrum))
        title('Fourier Spectrum (Db)')
       
        %now compute the average value 
        f_bar = abs(real(dft(1,1) / (M*N))) ;
        msgbox(['Average value is: ', num2str(f_bar)])

    end

end