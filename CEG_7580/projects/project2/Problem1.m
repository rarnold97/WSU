%% Problem 1 
function Problem1()
% close any open figures, if desired, uncomment
%close all

% load in the image data to matrices 
Ia = imread('Fig0308(a)(fractured_spine).tif') ; 
Ib = imread('Fig0309(a)aerialview-washedout.tif') ; 

%convert the images to double precision for transformation processing
Ia_double = im2double(Ia) ; 
Ib_double = im2double(Ib) ; 

%log xform

% c values chosed based on trial and error process
c1_log = 2.0 ; 
c2_log = 1.0 ; 

c1_power = 1.0 ; 
c2_power = 1.0 ; 

% gammas were more strategic.  For the first image, it is desired to expand
% the interval of dark levels.  Conversely for the washed out images , it
% is desirable to expand the mapping of light levels
gamma1 = 0.6 ; 
gamma2 = 4.0 ;

%perform transforms on images with coefficients and gammas
Ia_log_xform = log_xform(Ia, c1_log) ;
Ib_log_xform = log_xform(Ib, c2_log) ; 

Ia_power_xform = power_xform(Ia, c1_power, gamma1) ; 
Ib_power_xform = power_xform(Ib, c2_power, gamma2) ; 

% PLOTTING
% set up a figure handle to compare results
fig = figure() ; 
set(0, 'CurrentFigure', fig) ; 

% produce plots for all the histograms, and label coefficients in the
% titles
subplot(1,2,1)
imshow(Ia)
title('Original Image Fig 3.8a')

subplot(1,2,2)
imshow(Ia_log_xform)
title(strcat('Log transformation Fig 3.8a c = ', ' ', num2str(c1_log)))

fig2 = figure() ; 
set(0, 'CurrentFigure', fig2) ; 

subplot(1,2,1)
imshow(Ib)
title('Original Image 3.9a')

subplot(1,2,2)
imshow(Ib_log_xform)
title(strcat('Log Transfomred Image 3.9a c = ',' ', num2str(c2_log)))

fig3 = figure() ; 
set(0, 'CurrentFigure', fig3) ; 

subplot(1,2,1)
imshow(Ia)
title('Original Image 3.8a')

subplot(1,2,2)
imshow(Ia_power_xform)
title(strcat('Power Transfomred Image 3.8a c = ',num2str(c1_power), ... 
    ' gamma = ', num2str(gamma1) ))


fig4 = figure() ; 
set(0, 'CurrentFigure', fig4) ; 

subplot(1,2,1)
imshow(Ib)
title('Original Image 3.9a')

subplot(1,2,2)
imshow(Ib_power_xform)
title(strcat('Power Transfomred Image 3.9a c = ',num2str(c2_power), ... 
    ' gamma = ', num2str(gamma2) ))


function c = optimize_xform_c(I)
% helps in the trial and error process of solving for a proper c value
% I -> 2D gray level matrix of an image dataset
    
    % start with the simple case of c = 1
    c = 1.0 ;
    while true 
        % present the figure to the user with the current coeficient
        f = gcf ; 
        close(f) ; 
        
        % perform the actual transformation logarithmically
        I_log_xform = c * log10(1 + im2double(I)) ;
        I_log_xform = shift_image_values(I_log_xform) ; 
        
        %present the image to the user to see if it is good
        imshow(uint8(I_log_xform))
        title(strcat('Testing Log Transform at c = ', num2str(c))) ; 
        
        % present user with dialog
        answer = questdlg('Is the current c value optimal?', ...
            'Select Y/N', ...
            'yes','no', 'no');
        
        % increment c if dialog answer is no, quit if yes
        if strcmp(answer, 'yes')
            break ; 
        else
            c = c + 1.0 ;
        end 
    end

end

function I_xform = log_xform(I, c)
% logarithmic transformation function
% I -> 2D graylevel matrix of image dataset
% c -> coefficient scalar, manually determined typically

    % see if the data is integer.  If so, convert to doubles
    test_type_val = I(1,1) ; 
    if ~isa(test_type_val, 'double')
       I = im2double(I) ;  
    end
    
    % apply xform
    I_xform = c .* log10(1 + I) ;
    % linearly scale data back to [0-255]
    I_xform = shift_image_values(I_xform) ; 
end

function I_xform = power_xform(I, c, gamma)
% performs power law tranformation on an input image
% I -> input image dataset.  gray level
% c -> coefficient multiplier
% gamma -> exponential coefficient
    
    % make sure data isnt integer.  Convert to double if it is
    test_type_val = I(1,1) ; 
    if ~isa(test_type_val, 'double')
       I = im2double(I) ;  
    end
    
    % apply xform
    I_xform = c*I.^gamma ;
    %linearly scale data back to [0-255]
    I_xform = shift_image_values(I_xform) ; 
    
end

end