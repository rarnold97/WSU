function Problem5(varargin)
    %%
    % optionally, the filename can be specified in varargin{1}

    %% load image data
    if nargin >=1
        pattern = varargin{1} ; 
    else
        pattern = '0726(b)' ; 
    end
    
    I = load_image(pattern , '*.tif') ; 
    I_dbl = im2double(I) ; 

    %% compute rgb vectors
    % create a distance handle/lambda
    dist = @(rgb1, rgb2) norm(rgb2 - rgb1) ; 

    % here I am sampling the dark regions of the image, using visual observation
    % to determine what regions contain the correct samples
    % the bounds are in the following order; each element is a vector for each of the three boxes I chose
    % the first row are the start and stop row indeces.  The second row are the start stop column indeces
    box_bounds = {[131, 140; 95, 108], [384 408; 107 133], [344, 353; 388, 401]} ;

    % extract the samples
    samples_R = [] ; samples_G = [] ; samples_B = [] ; 
    for i = 1:length(box_bounds)
        box_samples = box_bounds{i} ;
        sub_sample = I_dbl(box_samples(1, 1) : box_samples(1, 2), box_samples(2, 1) : box_samples(2, 2), :) ; 
        % unwrap the array so that we can concatenate all the samples 
        sub_sample_R = reshape(sub_sample(:,:,1) ,[1, size(sub_sample,1) * size(sub_sample, 2)]) ; 
        sub_sample_G = reshape(sub_sample(:,:,2) ,[1, size(sub_sample,1) * size(sub_sample, 2)]) ; 
        sub_sample_B = reshape(sub_sample(:,:,3) ,[1, size(sub_sample,1) * size(sub_sample, 2)]) ; 

        % YES I KNOW IT CHANGES SIZE EACH LOOP, SHUT UP JAVA HINTS AND DO YOUR JOB! ITS CALLED DYNAMIC MEMORY ALLOCATION XD
        samples_R = [samples_R sub_sample_R] ;
        samples_G = [samples_G sub_sample_G] ;
        samples_B = [samples_B sub_sample_B] ;
    end

    % compute the means and standard deviations
    sigma_R = std(samples_R) ; 
    sigma_G = std(samples_G) ; 
    sigma_B = std(samples_B) ; 

    u_R = mean(samples_R)  ; 
    u_G = mean(samples_G) ; 
    u_B = mean(samples_B) ; 

    range_R = [u_R-1.25*sigma_R,  u_R + 1.25*sigma_R] ; 
    range_G = [u_G-1.25*sigma_G, u_G + 1.25*sigma_G] ; 
    range_B = [u_B-1.25*sigma_B, u_B + 1.25*sigma_B] ;

    %% apply thresholding based on box sampling parameters
    R_mask = and(I_dbl(:,:, 1) >= range_R(1) , I_dbl(:, :, 1) <= range_R(2)) ; 
    G_mask = and(I_dbl(:,:, 2) >= range_G(1) , I_dbl(:, :, 2) <= range_G(2)) ; 
    B_mask = and(I_dbl(:,:, 3) >= range_B(1) , I_dbl(:, :, 3) <= range_B(2)) ; 

    segment_mask = and(R_mask, and(G_mask, B_mask)) ; 

    I_segmented = uint8(zeros(size(I,1), size(I, 2))) ; 
    I_segmented(segment_mask) = uint8(255) ; 

    fig = figure();
    set(0, 'CurrentFigure', fig);

    subplot(2,1, 1)
    imshow(I)
    title('Original Jupiter Image')

    subplot(2,1, 2)
    imshow(I_segmented)
    title('Segmentation of Darkest Regions')

end
