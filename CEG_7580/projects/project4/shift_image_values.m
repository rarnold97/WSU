function I = shift_image_values(img, varargin)
%% Function to reshift analog values to 0-255 after doing mathematical manipulation
% accepts an image intensity matrix : img

    gm = im2double(img) - (min(min(im2double(img)))) ; 

    %figure out k based on the bitness of the image.  Assuming 8-bit
    bits = 8 ; 
    if nargin > 1 
        bits = varargin{1} ; 
    end
    
    K = 2^bits - 1 ;
    
    gs = K * (gm ./ max(max(gm))) ; 

    if bits <= 8
        I = uint8(gs) ;
    else
        I = uint32(gs) ; 
    end
end