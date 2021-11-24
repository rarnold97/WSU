function I_filt = SGW(I, nl, maskSize, scheme, varargin)
    % scheme : 0 -> simple, 1-> efficient (according to journal methods)
    % Scheme enumeration script absracts this and uses enum keywords

    if length(size(maskSize)) ~= 2
        error('Enter a 2 element vector for mask dimensions ...')
    end

    % convert the image to a double
    I_dbl = im2double(I);

    % compute kernels from Gabor filter bank
    % bear in mind that these kernels are quantized
    kernels = GenGWBank(nl, maskSize);
    I_cand = cell(1, length(kernels));

    if scheme == Scheme.SIMPLE
        I_filt = simple_feature_extract(I_dbl, kernels, maskSize);
    elseif scheme == Scheme.EFFICIENT
        % define the efficient scheme using minimax double thresholding
        method = 1; % thresholding method

        if nargin > 4
            method = varargin{1};
        end

        I_filt = eff_feature_extract(I_dbl, kernels, maskSize, method);

    else
        error('Invalid scheme option passed in, 0 -> simple, 1-> efficient ...')
    end

end

% not sure if the thresholding is applied to only the efficient algorithm or if it is applied to both ??

function I_feat = simple_feature_extract(I, kernels, maskSize)
    % consider taking the absolute value of the maximum
    % they say absolute, which implies to me the greatest value
    % but this could also imply taking the max of the absolute values ??

    % perform convolution
    for i = 1:length(kernels)
        kernel = kernels{i};
        conv_fun = @(block) sum(dot(kernel, block));
        Icand{i} = nlfilter(I, maskSize, conv_fun);
    end

    % begin extracting features

    % define the base method defined in the paper
    I_feat = max(Icand{:});
end

function I_feat = eff_feature_extract(I, kernels, maskSize, tMethod)
    disp('todo')
    I_feat = zeros(size(I));

    kern00 = kernels{1}; % omega = 0.3pi, theta = 0 [rad]
    kern02 = kernels{3}; % omega = 0.3pi, theta = pi /2 [rad]

    % not sure if the entire image or just the kernel is supposed to be used here ?
    conv_fun00 = @(block) sum(dot(kern00, block)) ; 
    conv_fun02 = @(block) sum(dot(kern02, block)) ; 

    phi00 = nlfilter(I, maskSize, conv_fun00) ; 
    phi02 = nlfilter(I, maskSize, conv_fun02) ; 

    % not quite sure yet how to calculate the threshold with method 3
    % going to assume that default method will suffice for now 

    [T1, T2] = GetThresholds(I , tMethod) ; 



end
