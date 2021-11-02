function Problem4(varargin)
%%
% Accepts the filename as an optional arguement, varargin{1}
% otherwise will search for problem 4's image via pattern 
    %uncomment while debugging or youll go insane
    %close all
    % grab filename
    if nargin >=1 
        filename = varargin{1} ; 
    else
        filename = find_files_from_pattern('809(a)', '*.tif') ;
        filename = filename{1} ;
    end

    % load image
    I = imread(filename) ; 

    % plot original image 
    fig = figure() ; 
    set(0, 'CurrentFigure', fig) ; 

    imshow(I)
    title('Original Image of fig 8.09a')

    %convert to double for transforms and such 
    I_dbl = im2double(I) ;

    % setup parameters 
    scales = [2 3 4] ; 
    rms_vals = zeros(size(scales)) ; 
    snrms_vals = zeros(size(scales)) ; 
    wavelet = 'haar'; 

    rms_msg = '' ; 
    snrms_msg = '' ; 

    % decompose wavelet to the end scale 
    
    i = 1; 

    % setup plot object
    fig = figure() ; 
    set(0, 'CurrentFigure', fig) ; 

    for level = scales
        % perform the decomposition for the input image at prescribed level
        [c, s] = wavedec2(I_dbl, level, wavelet) ;
        % compute the number of approximation coefficients
        N_Approx = s(1,1) * s(1,2) ; 
        % truncate the detail coefficients 
        c(N_Approx+1 : end) = 0 ; 
        
        % decompress the image without detail coefficients 
        I_decomp_dbl = waverec2(c,s,wavelet) ; 
        I_decomp_int = shift_image_values(I_decomp_dbl) ; 

        % get the rescaled coefficients from wavelet decomposition
        subplot(2,3,i)
        
        % reconstruct the image 
        imshow(I_decomp_int)
        
        title(['Image reconstruction L = ', num2str(level)])

        %plot the errors
        subplot(2,3, i+3)
        imshow(shift_image_values(I_decomp_dbl - I_dbl))
        title(['Reconstruction Error L = ', num2str(level)])
        
        % compute error parameters 
        i = i + 1 ; 
        rms_vals(i) = RMS(I_dbl, I_decomp_dbl) ; 
        snrms_vals(i) = snrms(I_dbl, I_decomp_dbl) ; 

        rms_msg = [rms_msg, 'RMS Error at Scaling Level: ', num2str(level), ' : ', num2str(rms_vals(i)), newline] ; 
        snrms_msg = [snrms_msg, 'SNRms at Scaling Level: ', num2str(level), ' : ', num2str(snrms_vals(i)), newline] ; 

    end
    
    msgbox([rms_msg, newline, snrms_msg])
end