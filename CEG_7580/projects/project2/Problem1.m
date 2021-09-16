%% Problem 1 

% close any open figures
close all

% load in the image data to matrices 
Ia = imread('Fig0308(a)(fractured_spine).tif') ; 
Ib = imread('Fig0309(a)aerialview-washedout.tif') ; 

%convert the images to double precision for transformation processing
Ia_double = im2double(Ia) ; 
Ib_double = im2double(Ib) ; 

%log xform

% write a loop to test the ideal image
%c1_log = 845 ; 
c1_log = 2 ; 
c2_log = 50 ; 

c1_power = 1.0 ; 
c2_power = 1.0 ; 

gamma1 = 0.6 ; 
gamma2 = 4.0 ;

Ia_log_xform = log_xform(Ia, c1_log) ;
Ib_log_xform = log_xform(Ib, c2_log) ; 

Ia_power_xform = power_xform(Ia, c1_power, gamma1) ; 
Ib_power_xform = power_xform(Ib, c2_power, gamma2) ; 

% PLOTTING
% set up a figure handle to compare results
fig = figure() ; 
set(0, 'CurrentFigure', fig) ; 

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
    c = 1.0 ;
    while true 
        f = gcf ; 
        close(f) ; 
        Ia_log_xform = c * log10(1 + im2double(I)) ;
        Ia_log_xform = shift_image_values(Ia_log_xform) ; 
        imshow(uint8(Ia_log_xform))
        title(strcat('Testing Log Transform at c = ', num2str(c))) ; 

        answer = questdlg('Is the current c value optimal?', ...
            'Select Y/N', ...
            'yes','no', 'no');

        if strcmp(answer, 'yes')
            break ; 
        else
            c = c + 1.0 ;
        end 
    end

end

function I_xform = log_xform(I, c)
    test_type_val = I(1,1) ; 
    if ~isa(test_type_val, 'double')
       I = im2double(I) ;  
    end
    
    I_xform = c .* log10(1 + I) ;
    I_xform = shift_image_values(I_xform) ; 
end

function I_xform = power_xform(I, c, gamma)

    test_type_val = I(1,1) ; 
    if ~isa(test_type_val, 'double')
       I = im2double(I) ;  
    end
    
    I_xform = c*I.^gamma ;
    I_xform = shift_image_values(I_xform) ; 
    
end