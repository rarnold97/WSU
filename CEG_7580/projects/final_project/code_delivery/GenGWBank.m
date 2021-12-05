function filters = GenGWBank(params)
    % Purpose is to generate a filter bank to convolve the input images with
    % the parameters are hard coded, as they were pre-selected in the journal paper
    %
    % params: describes the inputs to be passed in. contains default parameters and those solved by the paper
    %
    % in -> varargin{1} *optional: 2 element vector describing kernel
    % dimensions
    %
    % out -> SGW (quantized) filters to be used in edge detection analysis via Image convolution

    % debug parameter
    %showQuantPlots = true ;
    showQuantPlots = params.showQuantPlots;
    % this default value makes the images look the best for the report
    maskSize = params.maskSize;

    % allowing use of the default sigma for the gaussian component of the wavelet
    nl = params.nl;

    frequencies = params.frequencies;
    thetas = params.thetas;
    sigmas = params.sigmas;

    filters = cell(1, length(frequencies));

    % going to create a figure demonstrating replication
    if showQuantPlots
        fig = figure();
        set(0, 'CurrentFigure', fig);
    end

    for i = 1:length(frequencies)

        omega = frequencies(i);
        theta = thetas(i);
        sigma = sigmas(i);

        sgw = GaborImag(maskSize, omega, theta, 'sigma', sigma, 'asDeg', false);
        sgw_quant = QuantizeWavelet(sgw, nl, showQuantPlots);
        filters{i} = sgw_quant;
        
        if showQuantPlots
            %plot results
            subplot(2, 4, i)
            imshow(shift_image_values(sgw_quant))
            title(['SGW Kernel theta = ' num2str(theta) ' omega = ' num2str(omega)])
        end
    end

end
