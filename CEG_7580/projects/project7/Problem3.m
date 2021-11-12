function Problem3(varargin)
%% permitts user to enter explicit file path as varargin{1}, else auto detects figure image

    %% load image data 
    if nargin >= 1 
        pattern1 = varargin{1} ;
        pattern2 = varargin{2} ; 
    else
        pattern1 = '0110(4)';
        pattern2 = '0718(a)';
    end

    I_river = load_image(pattern, '*.tif') ; 

    %% Start Slicing

    % define a cutoff based on data observation
    cutoff1 = 50;

    blue = uint8([0 0 205]) ; 
    yellow = uint8([255 255 0]) ;

    yellow_mask = I_river >= cutoff1 ; 
    blue_mask = I_river < cutoff1 ; 

    I_river_sliced = zeros([size(I_river,1), size(I_river,2), 3]) ; 
    R = zeros(size(I_river)) ; 
    G = zeros(size(I_river)) ; 
    B = zeros(size(I_river)) ; 
    
    R(blue_mask) = blue(1) ; 
    G(blue_mask) = blue(2) ;
    B(blue_mask) = blue(3) ; 
    
    R(yellow_mask) = yellow(1) ; 
    G(yellow_mask) = yellow(2) ;
    B(yellow_mask) = yellow(3) ; 
    
    I_river_sliced(:,:,1) = R ; 
    I_river_sliced(:,:,2) = G ; 
    I_river_sliced(:,:,3) = B ; 
    %% proceed to analyze the next image 

    I_lung = load_image(pattern2, '*.tif') ; 

    green = uint8([0 255 0]) ;
    purple = uint8([255 0 255]) ; 
    white = uint8([255 255 255]) ; 
    red = uint8([255 0 0]) ;
    pink = uint8([255 0 125]) ; 
    magenta = uint8([204 0 102]) ;

    % define a color map for all the regimes
    cmap = zeros(8,3) ; 
    cmap(1,:) = [0 0 0] ; 
    cmap(2,:) = blue ; 
    cmap(3,:) = purple ;
    cmap(4,:) = pink ;  
    cmap(5,:) = green ; 
    cmap(6,:) = yellow ; 
    cmap(7,:) = red;
    cmap(8,:) = white;
    
    % set the cutoff levels based on visual inspection 
    cutoff2 = [0 15; 15 25; 25 35; 35 45; 45 60; 60 100; 100 125; 125 255] ; 
    
    % define RGB for the lung image
    R2 = uint8(zeros(size(I_lung))) ; 
    G2 = uint8(zeros(size(I_lung))) ; 
    B2 = uint8(zeros(size(I_lung))) ; 
    
    % loop through all the threshold planes and assign the RGB values to
    % corresponding color map color
    for i = 1:length(cmap)
       thresh_mask = and(I_lung >= cutoff2(i, 1), I_lung < cutoff2(i, 2)) ; 
       R2(thresh_mask) = cmap(i, 1) ; 
       G2(thresh_mask) = cmap(i, 2) ; 
       B2(thresh_mask) = cmap(i, 3) ;
    end
    
    I_lung_sliced = zeros([size(I_lung) 3]) ;
    I_lung_sliced(:,:,1) = R2 ; 
    I_lung_sliced(:,:,2) = G2 ; 
    I_lung_sliced(:,:,3) = B2;

    %% display results
    fig = figure();
    set(0, 'CurrentFigure', fig);

    subplot(1,2,1)
    imshow(I_river)
    title('Original River Image')

    subplot(1,2,2)
    imshow(I_river_sliced)
    title('Pseudocolor Image of River')

    fig = figure();
    set(0, 'CurrentFigure', fig);

    subplot(1,2,1)
    imshow(I_lung)
    title('Original Lung Xray Cross Section')

    subplot(1,2,2)
    imshow(I_lung_sliced)
    title('Pseudocolor Lung Image')
    
end