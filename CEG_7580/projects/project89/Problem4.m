function Problem4(varargin)
% accepts optional inputs:
% varargin{1} file pattern or filename

    % load the image 
    pattern = '0916';

    if nargin >= 1
        pattern = varargin{1};
    end

    I = load_image(pattern);

    % binarize if the image isnt already binarized
    if any(I > 1)
        I = imbinarize(I);
    end

    % define a structuring element
    se = strel('rectangle', [3 3]);

    % perform erosion using built-in method
    I_erode = imerode(I, se);

    % perform boundary extraction using eq 9-18
    Boundary = set_diff(I, I_erode);

    % display results
    fig = figure();
    set(0, 'CurrentFigure', fig);

    subplot(1, 2, 1)
    imshow(I)
    title('Original Image')

    subplot(1, 2, 2)
    imshow(Boundary)
    title('Boundary Extracted Image')

end
