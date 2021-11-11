function Problem1(varargin)
    %%
    % optionally, the filename can be specified in varargin{1}

    % load image data
    filename = string;

    if nargin >= 1
        filename = varargin{1};
    else
        f_cell = find_files_from_pattern('507(a)', '*.tif');
        filename = f_cell{1};
    end

    % declare constants
    Ps = 0.2;
    Pp = 0.2;
    mask_size = [3 3];

    I = imread(filename);
    %I_dbl = im2double(I);

    % first, corrupt the image with salt and pepper noise
    I_noisy = imnoise(I, 'salt & pepper', Ps);

    %% generate a display corrupted image

    % shift by 1 pixel to go from 0-255

    %% apply median filtering
    med_ftr_fn = @(block) median(median(block));

    %pass 1
    I_pass1 = nlfilter(I_noisy, mask_size, med_ftr_fn);

    I_pass2 = nlfilter(I_pass1, mask_size, med_ftr_fn);

    I_pass3 = nlfilter(I_pass2, mask_size, med_ftr_fn);

    % genereate display images
    

    %% show results
    fig = figure();
    set(0, 'CurrentFigure', fig);

    subplot(2, 2, 1)
    imshow(I_noisy)
    title('Salt & Pepper Corrupted Image')

    subplot(2, 2, 2)
    imshow(I_pass1)
    title('Median Filtering Pass 1')

    subplot(2, 2, 3)
    imshow(I_pass2)
    title('Median Filtering Pass 2')

    subplot(2, 2, 4)
    imshow(I_pass3)
    title('Median Filtering Pass 3')

end
