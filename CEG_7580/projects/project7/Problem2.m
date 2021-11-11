function Problem2(varargin)
    %%
    % optionally, the filename can be specified in varargin{1}

    % load image data
    filename = string;

    if nargin >= 1
        filename = varargin{1};
    else
        f_cell = find_files_from_pattern('interference', '*.tif');
        filename = f_cell{1};
    end

    I = imread(filename);
    I_dbl = im2double(I);

    % lets genereate a spectrum yo
    dims = size(I);
    P = 2 * dims(1);
    Q = 2 * dims(2);

    % this employs the fourier transform implementation from project 4 !!!!!
    Spectrum = freq_filter_image(I_dbl, P, Q, 'dft');
    SpectrumMag = sqrt(real(Spectrum).^2 + imag(Spectrum).^2);
    SpectrumDb = 20 .* log10(SpectrumMag);

    %% notes on spectrum observations
    %magnitude 1 : upper left dot - index 98, [X,Y] [951, 775] (col, row)
    % freq in db: 97.7640
    % linear freq : 7.7304e+04
    % 287.7271
    % magnitude 2 : lower right dot - index 98, [X,Y] [1051, 875] (col, row)
    % freq in db: 97.7640
    % linear freq: 7.7304e+04
    % 287.7271
    % try taking 95% of the frequencies as the threshold ??

    %% notche filtering

    % calculate notche parameters
    center1 = [775, 951];
    center2 = [875, 1051];
    freq_dom_center = [P / 2, Q / 2];

    %D1 = @(u,v) sqrt((u - P/2 - center1(1)).^2 + (v - Q/2 - center1(2)).^2) ;
    %D2 = @(u,v) sqrt((u - P/2 - center2(2)).^2 + (v - Q/2 - center2(2)).^2 ) ;

    % measuring cutoff frequency radii, not actual frequency value
    %D0_1 = sqrt((center1(1)-freq_dom_center(1)).^2 + (center1(2)-freq_dom_center(2)).^2) ;
    %D0_2 = sqrt((center2(1)-freq_dom_center(1)).^2 + (center2(2)-freq_dom_center(2)).^2) ;

    % appy frequency domain filtering based on notche filtering parameters
    notches = [[775, 951]; [875, 1051]];
    % frequency radii are trial and error
    cutoffs = [15 15];

    filter_results = freq_filter_image(I_dbl, P, Q, 'highpass', ...
        'pass_type', 'notche', 'D0', cutoffs, ...
        'notche_idx', notches, 'return_transfer', true);

    I_filtered_dbl = filter_results{1};
    Huv_dbl = filter_results{2};

    I_pattern_dbl = I_dbl - I_filtered_dbl;

    %% display results

    fig = figure();
    set(0, 'CurrentFigure', fig);

    subplot(3, 2, 1)
    imshow(I)
    title('Original Image')

    subplot(3, 2, 2)
    imshow(uint8(SpectrumDb))
    title('Frequency Spectrum')

    subplot(3, 2, 3)
    [X, Y] = meshgrid(1:Q, 1:P);
    mesh(X, Y, Huv_dbl, 'edgecolor', 'b')
    title('Highpass Notch Filter')

    subplot(3, 2, 4)
    imshow(shift_image_values(I_pattern_dbl))
    title('Interference Pattern')

    subplot(3, 2, 5)
    imshow(shift_image_values(I_filtered_dbl))
    title('Filtered Image')

end
