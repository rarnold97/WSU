function Problem3(varargin)
    % accepts optional inputs:
    % varargin{1} file pattern or filename

    % load image
    if nargin > 1
        pattern = varargin{1};
    else
        pattern = '1036';
    end

    I = load_image(pattern);

    % generate histogram
    [counts, ~] = imhist(I);

    % apply built-in otsu method
    T = otsuthresh(counts);

    % create a binary image from threshold
    BW = imbinarize(I, T);

    % display results
    fig = figure();
    set(0, 'CurrentFigure', fig);

    subplot(1, 2, 1)
    imshow(I)
    title('Original Image')

    subplot(1, 2, 2)
    imshow(BW)
    title('Segmented Image using Otsus Method')

end
