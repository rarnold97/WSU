%% Problem 2 

% for my sanity, Im closing the preopened figures, grader, comment this out if it disrupts your rhythm
% know what Im saying :D
close all 

% part a 

imageFiles = find_files_from_pattern('0316', '*.tif') ; 

% for each file, generate histogram plots
for f = imageFiles
    file = f{1} ;
    % process and equalize histograms generated from input images 
    %part of part a)
    loadHisto(file) ; 
end

close all
% although it is redundant to repeat this loop, I did it to separate the subparts of the problem statement

fig332 = find_files_from_pattern('0332(a)', '*.tif') ; 

% should only be one file found, but what the heck, loop just in case the same regexp comes up again
% still in big O(n) am I right :)

for f = fig332
    file = f{1} ; 
    [~, baseName, ~] = fileparts(file) ;

    img_r = imread(file) ; 
    % false to indicate not to plot, just return the data
    [~, ~, global_map] = loadHisto(file, false) ; 
    img_s_local = localhisteq(img_r, [3, 3], 256) ; 

    fig = figure() ; 
    set(0, 'CurrentFigure', fig) ; 

    subplot(1,3,1)
    imshow(img_r)
    % splitting the image title, just to get the figure part
    baseParts = strsplit(baseName, '(') ; 
    title(strcat('Original Image: ', ' ', baseParts{1})) ; 

    subplot(1,3,2)
    imshow(img_r, global_map)
    title('Global Histogram Equalized Image')

    subplot(1,3,3)
    imshow(img_s_local)
    title('Local Histogram Equalized Image')

end

%% Part B Function
function output_img = localhisteq(input_img, mask_size, graylevel)

    if length(size(mask_size)) ~= 2
        error('Please pass in a 2D spatial mask size ...')
    end

    img_dims = size(input_img) ; 

    if mask_size(1) > img_dims(1) || mask_size(2) > img_dims(2)
        error('mask size cannot exceed dimensions of global image !')
    end

    % create a lambda-like expression for function handle to be used on block processing
    
    %kernel_fun = @(input_img_struct) ind2gray(input_img_struct.data, ...
    %    histeq(input_img_struct.data, gray(graylevel))) ;
    kernel_fun = @(block_struct) histeq(block_struct.data, graylevel) ; 
    
    output_img = blockproc(input_img, mask_size, kernel_fun) ; 
end 

%%Auxillary Functions
function [hist_in, hist_out, newmap] = loadHisto(filename, varargin)
    showPlots = true ; 
    if nargin > 1
        showPlots = varargin{1} ; 
    end 
    
    [~, basename, ~] = fileparts(filename) ; 

    img = imread(filename) ; 
    
    if showPlots
        fig = figure();
        set(0, 'CurrentFigure', fig) ; 
        subplot(1,3,1)
        imshow(img) ; 
        title(strcat('Original Image: ', basename))
    end
    
    [histgram, N] = imhist(im2double(img)) ; 
    
    if showPlots
        subplot(1,3,2)
        bar(N, histgram) ; 
        title('input histogram')
    end

    newmap = histeq(img, gray(256)) ; 
    
    if showPlots
        subplot(1,3,3)
        imshow(img, newmap) ; 
        title('output histogram equalization')

        fig2 = figure() ; 
        set(0, 'CurrentFigure', fig2)
        rgbplot(newmap) ;
        title(strcat('Transfer Function T(r) Estimate for: ',' ', basename))
    end
    
    hist_in = histgram ;
    hist_out = newmap ; 

end