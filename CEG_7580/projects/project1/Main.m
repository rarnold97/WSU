%% Project 1: Image Processing fundamentals
% Ryan Arnold
% Sept. 7, 2021

%% Part 1 

%load in the drip bottle tif image
img = imread('drip-bottle-256.tif');

img_d = double(img) / 256 ; 

% gather user response and ensure that the number of levels was indeed a
% number
while true
    response = inputdlg("Please enter a number of intensity levels between 2-8") ; 
    response_num = str2double(response) ; 
    if ~isnan(response_num)
        break
    else
        warndlg('Invalid input entered, try again') ;
    end
end
%make sure the number is in the right bound
if response_int <2
    response_int = 2; 
end

if response_int > 8
    response_int = 8 ; 
end

%display all the images based on what the user entered
fig = figure() ; 
set(0, 'CurrentFigure', fig) ; 

for l = 1:1:response_num
   l_int = uint8(l) ; 
   factor = double(2^l_int - 1) ; 
   img_nbits = uint8(img_d*factor) ; 
   
   % reshift matrix if math causes values to exceed bound: 2^bits -1 
   if max(max(img_nbits)) > 2^l_int - 1 
       img_nbits = shift_image_values(img_nbits, 8) ; 
   end
   
   subplot(2, ceil(response_num/2), l) ;
   imshow(img_nbits, [0, factor]) ;
end

%% Part 2 
scaleUp = 4 ; 

%load in image gray scale data
img = imread('Chronometer.tif') ;

%display original image
fig2 = figure();
set(0, 'CurrentFigure', fig2) ;
%subplot(2,2,1)
imshow(img)
title('Original Image')

% scale to a quarter size 
img_quarter = imresize(img, 1/scaleUp) ; 


fig3 = figure();
set(0, 'CurrentFigure', fig3) ;
%subplot(2,2,2)
imshow(img_quarter) ; 
title('Clock Scaled down to a Quarter')

%return image to original size using pixel replication
dims = size(img_quarter) ; 
pixel_rep_img = zeros(4*dims) ; 

% copy the pixel values employing the correct mask spacing scheme
pixel_rep_img(1:scaleUp:dims(1)*scaleUp, 1:scaleUp:dims(2)*scaleUp) = img_quarter ; 

for i = 1:scaleUp:dims(1)*scaleUp
   for j = 1:scaleUp:dims(2)*scaleUp
        pixel_rep_img(i:i+scaleUp-1, j:j+scaleUp-1) = pixel_rep_img(i,j) ; 
   end
end

% make sure data type is integer after performing mathematical operations
pixel_rep_img = uint8(pixel_rep_img) ; 

%subplot(2,2,3)
fig4 = figure();
set(0, 'CurrentFigure', fig4) ;
imshow(pixel_rep_img)
title('Rescaled Image with Pixel Replication')

% return the image to the original size using bilinear interpolation via
% interp2 

%create a mesh of the original spacing and then the new pixel spacing
[X, Y] = meshgrid(linspace(0, 1, dims(2)) , linspace(0, 1, dims(1)) ); 
[Xq, Yq] = meshgrid(linspace(0, 1, dims(2)*scaleUp) , linspace(0, 1, dims(1)*scaleUp) );
vals_old = double(img_quarter) ; 
vals_new = interp2(X, Y, vals_old, Xq, Yq); 
vals_new = uint8(round(vals_new)) ; 

%subplot(2,2,4)
fig5 = figure();
set(0, 'CurrentFigure', fig5) ;
imshow(vals_new) ; 
title('Rescaled Image with Bilinear Interpolation') ; 


