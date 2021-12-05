function [I_filt, runtime] = SGW(I, params, scheme, varargin)
    % scheme : 0 -> simple, 1-> efficient (according to journal methods)
    % Scheme enumeration script absracts this and uses enum keywords
    %
    %varargin{1} -> return phi feature matrices (used for intermediate figures)

    if length(size(params.maskSize)) ~= 2
        error('Enter a 2 element vector for mask dimensions ...')
    end

    returnPhi = false ; 
    if nargin >= 4
        returnPhi = varargin{1} ; 
    end

    % convert the image to a double
    I_dbl = im2double(I);

    % compute kernels from Gabor filter bank
    % bear in mind that these kernels are quantized
    kernels = GenGWBank(params);

    % do hysteresis linking 

    if scheme == Scheme.SIMPLE

        % assuming the post processing does not count towards runtime 

        tStart = tic ; 

        phis = [] ;
        if ~returnPhi
            features = simple_feature_extract(I_dbl, kernels, params, returnPhi);
        else
            phis = simple_feature_extract(I_dbl, kernels, params, returnPhi);
        end

        runtime = toc(tStart) ; 
        
        % get runtime after threshold, but not link
        
        if returnPhi
            I_filt = phis ; 
            return 
        else
            
            I_filt = hysteresis_link(features, params.neighborhood) ; 
        end

    elseif scheme == Scheme.EFFICIENT
        % assuming post processing doesnt count towards runtime
        tStart = tic ; 
        features = eff_feature_extract(I_dbl, kernels, params.maskSize, params.method, params.alpha);
        runtime = toc(tStart) ; 
        % get runtime after threshold, but not link 

        %% Apply thresholding 

        % in this case, we already have a trinarisation image, so cant use hystersis3d fun directly ...
        %I_filt = hysteresis_link(features, params.neighborhood, params.weak, params.strong) ; 

        I_filt = hysteresis_link(features, params.neighborhood) ; 
    else
        error('Invalid scheme option passed in, 0 -> simple, 1-> efficient ...')
    end

end

% not sure if the thresholding is applied to only the efficient algorithm or if it is applied to both ??

function I_feat = simple_feature_extract(I, kernels, params, returnPhi)
    % consider taking the absolute value of the maximum
    % they say absolute, which implies to me the greatest value
    % but this could also imply taking the max of the absolute values ??

    [T1, T2] = GetThresholds(I, params.method, params.alpha) ; 

    I_cand = zeros(size(I,1), size(I,2), length(kernels)) ; 
    % perform convolution
    for i = 1:length(kernels)
        kernel = kernels{i};
        conv_fun = @(block) sum(dot(kernel, block));
        I_cand(:,:, i) = nlfilter(I, params.maskSize, conv_fun);
        %I_cand(:,:, i) = imfilter(I, kernel) ; 
    end

    % begin extracting features

    % find the top 2 maximum features 
    page_ranked = sort(I_cand, 3, 'descend') ; 

    phi1 = page_ranked(:,:, 1) ; 
    phi2 = page_ranked(:,:, 2) ; 
    
    %[T1, T2] = GetThresholds(im2double(phi1), params.method, params.alpha) ; 

    I_max = zeros(size(phi1)) ; 

    cond1 = and(phi1 > T1 , phi2 <=T1) ; 
    cond2 = and(phi1 <=T1, phi2 >T1) ; 
    I_max(or(cond1, cond2)) = 1; % weak edge
    I_max(and(phi1<T1, phi2<T1)) = 0; % not an edge
    I_max(phi1+phi2 > T2) = 2; % strong edge

    % define the base method defined in the paper
    if returnPhi
        I_feat = I_cand;
    else
        I_feat = I_max;
    end
end

function I_feat = eff_feature_extract(I, kernels, maskSize, tMethod, alpha)

    % not quite sure yet how to calculate the threshold with method 3
    % going to assume that default method will suffice for now 

    [T1, T2] = GetThresholds(I , tMethod, alpha) ; 

    fun = @(block) eff_conv(block, kernels, T1, T2) ; 

    I_feat = nlfilter(I, maskSize, fun) ; 

end


function cv = eff_conv(block, kernels, T1, T2)

    kern00 = kernels{1} ; 
    kern02 = kernels{3} ; 

    [i00, j00, ~] = find(kern00) ; 
    [i02, j02, ~] = find(kern02) ; 

    i00 = unique(i00); j00 = unique(j00) ; 
    i02 = unique(i02); j02 = unique(j02) ; 

    phi00 = sum(dot(block(i00,j00), kern00(i00,j00))) ; 
    phi02 = sum(dot(block(i02,j02), kern02(i02,j02))) ; 

    %identify if pixel is an edge pixel 

    if phi00 + phi02 > T2
        cv = 2 ; % strong edge

    elseif phi00 < T1 && phi02 <T1
        cv = 0 ; % not an edge 

    else
        phi1 = max(phi00, phi02) ; 
        % examine the other phis , we know either phi00 or phi02 is greater than T1
        kernel_subset = {kernels{2} kernels{4:end}} ; 

        cv = 1 ; % weak edge 

        for kernel = kernel_subset
            ker = kernel{1} ; 
            [i, j, ~] = find(ker) ; 
            i = unique(i); j = unique(j) ; 

            phi_test = sum(dot(block(i,j), ker(i,j))) ; 

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