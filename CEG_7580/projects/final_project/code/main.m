%% First load the image data matrices 

Images = LoadImages() ; 

for I_cell = Images 

    % pre-converted to double through LoadImages()
    I = I_cell{1} ; 

    %% first smoothen the image using a gaussian smoothing function
    % using one sigma for now
    I_smooth = imgaussfilt(I, 1) ; 

end