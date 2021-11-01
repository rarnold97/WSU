function Problem4(varargin)
    files = {} ;
    if nargin >=1
        files = varargin{1};
    else 
        files = find_files_from_pattern('0440(a)','*.tif') ;
    end

    scales = [1 3 4 6 9] ; 
    wavelet = 'haar';
    

    for f = files 
        file = f{1};

        I = imread(file) ; 
        I_decimated = rowcoldel(I);
        I_double = im2double(I_decimated) ;

        [c, s] = wavedec2(I_double, 9, wavelet) ; 

        %% part a
        i = 4 ; 
        for level = scales

            [H, V, D] = detcoef2('all', c, s, level) ; 
            A  = appcoef2(c,s,wavelet, level) ;

            A_zeroed = zeros(size(A)) ; 
            H_zeroed = zeros(size(H)) ; 
            V_zeroed = zeros(size(V)) ; 
            D_zeroed = zeros(size(D)) ; 

            fig = figure() ; 
            set(0, 'CurrentFigure', fig) ; 

            subplot(2,2,1)
            I_resc_A0 = idwt2(A_zeroed, H, V, D, wavelet);
            %imshow(shift_image_values(I_resc_A0))
            imshow(uint8(wcodemat(I_resc_A0, 256)))
            title('Zero Approximation')

            subplot(2,2,2)
            I_resc_H0 = idwt2(A, H_zeroed, V, D, wavelet);
            %imshow(shift_image_values(I_resc_H0))
            imshow(uint8(wcodemat(I_resc_H0, 256)))
            title('Zero Horizontal Coefficients')

            subplot(2,2,3)
            I_resc_V0 = idwt2(A, H, V_zeroed, D, wavelet);
            %imshow(shift_image_values(I_resc_V0))
            imshow(uint8(wcodemat(I_resc_V0, 256)))
            title('Zero Vertical Coefficients')

            subplot(2,2,4)
            I_resc_D0 = idwt2(A, H, V, D_zeroed, wavelet);
            %imshow(shift_image_values(I_resc_D0))
            imshow(uint8(wcodemat(I_resc_D0, 256)))
            title('Zero Diagonal Coefficients')

            sgtitle(['Analysis of Coefficient Effects at Level ', num2str(level)])
        end

    end
end