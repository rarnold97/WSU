%% Problem 2 
function Problem2()

% uncomment this if the figures get annoying when testing
% close all 

% part a 

% filter out the images in the folder based on figure 3.16
imageFiles = find_files_from_pattern('0316', '*.tif') ; 

% for each file, generate histogram plots
for f = imageFiles
    file = f{1} ;
    % process and equalize histograms generated from input images 
    %part of part a)
    loadHisto(file) ; 
end

fig332 = find_files_from_pattern('0332(a)', '*.tif') ; 

% should only be one file found, but what the heck, loop just in case the same regexp comes up again
for f = fig332
    %extract from cell array
    file = f{1} ; 
    % get basename for plot title
    [~, baseName, ~] = fileparts(file) ;
    %load file
    img_r = imread(file) ; 
    % false to indicate not to plot, just return the data
    [~, ~, global_map] = loadHisto(file, false) ; 
    
    %apply local histogram equalization
    img_s_local = localhisteq(img_r, [3, 3], 256) ; 
    
    %plot results 
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
% performs local histogram equalization based on input mask size
% input_img -> input image data matrix 2D gray levels
% mask_size -> 2 element vector of mask dimensions
% graylevel -> number of gray levels (should be power of 2)
    
    % make sure gray level is a power of 2 
    pos = ceil(log2(graylevel)) ; 
    graylevel = 2^pos ;
    
    %make sure mask is a 2D vector
    if length(size(mask_size)) ~= 2
        error('Please pass in a 2D spatial mask size ...')
    end
    
    % dont let mask size exceed image dims
    img_dims = size(input_img) ; 

    if mask_size(1) > img_dims(1) || mask_size(2) > img_dims(2)
        error('mask size cannot exceed dimensions of global image !')
    end

    % create a lambda-like expression for function handle to be used on block processing
    % the kernel function here is histogram equalization using the
    % graylevel for bins
    kernel_fun = @(block_struct) histeq(block_struct.data, graylevel) ; 
    % apply block processing algorithm
    output_img = blockproc(input_img, mask_size, kernel_fun) ; 
end 

%%Auxillary Functions
function [hist_in, hist_out, newmap] = loadHisto(filename, varargin)
% function for global histogram equalization.  Also optionally plots
% histograms (hence the varargin)
% filename -> image filename
% varargin(1) -> bool whether or not to plot the images (true to plot)
    
    % assume user wants to plot
    showPlots = true ; 
    if nargin > 1
        % variable arguement of whether or not to plot
        showPlots = varargin{1} ; 
    end 
    
    % get basename for plot title 
    [~, basename, ~] = fileparts(filename) ; 
    % load image
    img = imread(filename) ; 
    
    % show original image
    if showPlots
        fig = figure();
        set(0, 'CurrentFigure', fig) ; 
        subplot(1,3,1)
        imshow(img) ; 
        title(strcat('Original Image: ', basename))
    end
    
    % compute histogram of image data
    [histgram, N] = imhist(im2double(img)) ; 
    
    % display histogram
    if showPlots
        subplot(1,3,2)
        bar(N, histgram) ; 
        title('input histogram')
        xlabel('level bin')
        ylabel('count')
        
    end
    % create a new mapping (newmap is Transfer function) using histogram
    % equalization
    newmap = histeq(img, gray(256)) ; 
    
    % plot globally equalized histogram mapped image
    if showPlots
        subplot(1,3,3)
        imshow(img, newmap) ; 
        title('output histogram equalization')
        
        % plot the transfer function
        fig2 = figure() ; 
        set(0, 'CurrentFigure', fig2)
        rgbplot(newmap) ;
        title(strcat('Transfer Function T(r) Estimate for: ',' ', basename))
        xlabel('r (input intensity)')
        ylabel('s (output intensity)')
    end
    
    % return the processed histogram and discrete transfer fn mapping
    hist_in = histgram ;
    hist_out = newmap ; 

end

end