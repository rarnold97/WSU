function Problem4(varargin)
%%
% Accepts the filename as an optional arguement, varargin{1}
% otherwise will search for problem 4's image via pattern 
    %uncomment while debugging or youll go insane
    close all
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
    scales = [1 3 4 9] ; 
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
        [c, s] = wavedec2(I_dbl, level, wavelet) ;
        [H, V, D] = detcoef2('all', c, s, level) ; 
        A = appcoef2(c, s, wavelet, level) ; 
        % truncate detail coefficients 
        H_zeroed = zeros(size(H)) ; 
        V_zeroed = zeros(size(V)) ; 
        D_zeroed = zeros(size(D)) ; 

        % get the rescaled coefficients from wavelet decomposition
        recon = idwt2(A, H_zeroed, V_zeroed, D_zeroed, wavelet) ; 
        subplot(2,2,i)
        
        % reconstruct the image 
        f_hat = uint8(wcodemat(recon, 256)) ;
        imshow(f_hat)
        
        title(['Image reconstruction without details Using: ', num2str(level), ' Scaling Levels'])
        
        % compute error parameters 
        i = i + 1 ; 
        rms_vals(i) = RMS(f_hat, I) ; 
        snrms_vals(i) = snrms(f_hat, I) ; 

        rms_msg = [rms_msg, 'RMS Error at Scaling Level: ', num2str(level), ' : ', num2str(rms_vals(i)), newline] ; 
        snrms_msg = [snrms_msg, 'RMS Error at Scaling Level: ', num2str(level), ' : ', num2str(rms_vals(i)), newline] ; 

    end
    
    msgbox([rms_msg, newline, snrms_msg])
end