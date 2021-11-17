function Problem1(varargin)
    % accepts optional inputs:
    % varargin{1} file pattern or filename or showHisto (true/false)
    % varargin{2} showHisto (true/false) -> if also passing in the file regexp

    % set defaults
    pattern = '0239'; showHisto = false;

    if nargin >= 1

        if isstring(varargin{1})
            pattern = varargin{1};
        else
            showHisto = varargin{1};
        end

    end

    if nargin >= 2 % whether or not to plot histogram
        showHisto = varargin{2};
    end

    I = load_image(pattern);
    I_dbl = im2double(I);

    % this is chosen via trial and error
    sigma = 2; T = 0.35;
    % apply gaussian smoothing
    I_smooth = imgaussfilt(I, sigma);
    I_smooth_dbl = im2double(I_smooth);

    % display the histogram to optimize threshold
    if showHisto
        % non thresholded gradient filtered Image
        sobel_image = sobel_filter(I_smooth_dbl);

        % generate a histogram
        [histgram, N] = imhist(sobel_image);

        % plot the histogram
        fig = figure();
        set(0, 'CurrentFigure', fig);

        bar(N, histgram);
        xlabel('pixel value')
        ylabel('Count')
        title('Gradient Histogram')

    else
        % get a sobel filter mask that is thresholded
        mask = sobel_filter(I_smooth_dbl, T);

        % apply threshold
        I_edges = zeros(size(I));
        I_edges(mask) = 255;

        % display results

        fig = figure();
        set(0, 'CurrentFigure', fig);

        subplot(1, 3, 1)
        imshow(I)
        title('Original Image')

        subplot(1, 3, 2)
        imshow(I_smooth)
        title('Gaussian Smoothened Image')

        subplot(1, 3, 3)
        imshow(I_edges)
        title('Results of Edge Detection')

    end

end

function filtered_image = sobel_filter(I, varargin)
    % performs a sobel filter on an input image.
    % In
    % I -> 2D image array
    % Optional
    % varargin{1} -> Threshold if the user wishes to threshold

    % define the kernels
    kernelX = [-1 -2 -1; 0 0 0; 1 2 1];
    kernelY = [-1 0 1; -2 0 2; -1 0 1];

    filter_fn = @(block) abs(sum(sum(kernelX .* block))) + abs(sum(sum(kernelY .* block)));

    filtered_image = nlfilter(I, [size(kernelX, 1) size(kernelY, 2)], filter_fn);

    % additionally apply a threshold if the user enters optional input
    if nargin > 1
        T = varargin{1};

        % returns binary mask
        filtered_image = filtered_image > T;
    end

end
