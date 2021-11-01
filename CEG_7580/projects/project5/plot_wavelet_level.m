function plot_wavelet_level(a,h,v,d, overall_title, varargin)

    intensities = 256 ; 
    if nargin >=6
        intensities = varargin{1};
    end
    
    subplot(2,2,1)
    imshow(uint8(wcodemat(a, intensities)))
    title('Level Approximation')

    subplot(2,2,2)
    imshow(uint8(wcodemat(h, intensities)))
    title('Horizontal Detail Coefficients')

    subplot(2,2,3)
    imshow(uint8(wcodemat(v, intensities)))
    title('Vertical Detail Coefficients')

    subplot(2,2,4)
    imshow(uint8(wcodemat(d, intensities)))
    title('Diagonal Detail Coefficients')

    sgtitle(overall_title)

end