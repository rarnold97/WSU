function [I_filt, runtime] = SGW(I, params, scheme)
    % scheme : 0 -> simple, 1-> efficient (according to journal methods)
    % Scheme enumeration script absracts this and uses enum keywords

    if length(size(params.maskSize)) ~= 2
        error('Enter a 2 element vector for mask dimensions ...')
    end

    % convert the image to a double
    I_dbl = im2double(I);

    method = params.method; % thresholding method

    % compute kernels from Gabor filter bank
    % bear in mind that these kernels are quantized
    kernels = GenGWBank(params);

    if scheme == Scheme.SIMPLE
        tStart = tic ; 
        features = simple_feature_extract(I_dbl, kernels, params.maskSize);
        runtime = toc(tStart) ; 

        % assuming the post processing does not count towards runtime 
        [T1, T2] = GetThresholds(features, method) ; 

        %I_edge = zeros(size(features)) ; 

        %I_edge(features > T2) = params.strong ; % strong edge
        %I_edge(and(features >= T1, features <= T2) ) = params.weak ; % weak edge
        %I_filt = hysteresis_link(I_edge, params.neighborhood, params.weak, params.strong) ;
        
        [tri, hys] = hysteresis3d(features, T1 / max(max(features)), T2 / max(max(features)), params.neighborhood) ; 
        I_filt = zeros(size(features)) ; 
        I_filt(hys) = params.strong ; 
        I_filt = uint8(I_filt) 

    elseif scheme == Scheme.EFFICIENT
        % assuming post processing doesnt count towards runtime
        tStart = tic ; 
        features = eff_feature_extract(I_dbl, kernels, params.maskSize, params.method);
        runtime = toc(tStart) ; 

        % in this case, we already have a trinarisation image 
        I_filt = hysteresis_link(features, params.neighborhood, params.weak, params.strong) ; 

    else
        error('Invalid scheme option passed in, 0 -> simple, 1-> efficient ...')
    end

end

% not sure if the thresholding is applied to only the efficient algorithm or if it is applied to both ??

function I_feat = simple_feature_extract(I, kernels, maskSize)
    % consider taking the absolute value of the maximum
    % they say absolute, which implies to me the greatest value
    % but this could also imply taking the max of the absolute values ??

    I_cand = cell(1, length(kernels)) ; 
    % perform convolution
    for i = 1:length(kernels)
        kernel = kernels{i};
        conv_fun = @(block) sum(dot(kernel, block));
        I_cand{i} = nlfilter(I, maskSize, conv_fun);
    end

    % begin extracting features

    % define the base method defined in the paper
    I_feat = max_vectorized(I_cand);
end

function I_feat = eff_feature_extract(I, kernels, maskSize, tMethod)

    % not quite sure yet how to calculate the threshold with method 3
    % going to assume that default method will suffice for now 

    [T1, T2] = GetThresholds(I , tMethod) ; 

    fun = @(block) eff_conv(block, kernels, T1, T2) ; 

    I_feat = nlfilter(I, maskSize, fun) ; 

end


function cv = eff_conv(block, kernels, T1, T2)

    kern00 = kernels{1} ; 
    kern02 = kernels{3} ; 

    phi00 = sum(dot(block, kern00)) ; 
    phi02 = sum(dot(block, kern02)) ; 

    %identify if pixel is an edge pixel 

    if phi00 + phi02 > T2
        cv = 2 ; % strong edge

    elseif phi00 < T1 && phi01 <T1
        cv = 0 ; % not an edge 

    else
        phi1 = max(phi00, phi02) ; 
        % examine the other phis , we know either phi00 or phi02 is greater than T1
        kernel_subset = {kernels{2} kernels{4:end}} ; 

        cv = 1 ; % weak edge 

        for kernel = kernel_subset
            phi_test = sum(dot(block, kernel{1})) ; 

            if phi1 + phi_test > T2
                cv = 2 ; % strong edge
                break ; 
            else % for now, assuming we are not interested in weak edges.  May need to revisit this 
                if phi_test > phi1
                    phi1 = phi_test ; 
                end
            end

        end

    end

end