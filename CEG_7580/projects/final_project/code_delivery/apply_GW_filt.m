function [feature, phi, runtime] = apply_GW_filt(I, params, filter_method)

    bank = cell(1, length(params.frequencies));

    % on the fence about the 2pi part
    %wavelengths = 2 * pi * (1 ./ params.frequencies);

    % computing the transfer function using a backdoor method to get a more accurate runtime
    % the paper states that the filter banks are precomputed
    options = struct('D0',50,'n',1,'center',[], 'pass_type', 'gaussian', 'notche_idx', [], 'return_transfer', false, ...
        'orientation', 45.0, 'omega', 0.3*pi/3, 'Huv', []);
    
    [M,N] = size(I) ; 
    P = 2 *M ; Q = 2 * N ; 
    [U,V] = meshgrid(1:P, 1:Q) ; 
    
    for i = 1:length(bank)
        
        if filter_method == Filter.FREQUENCY
            %w = 2 * pi / params.frequencies(i) ; 
            %w = 1 / params.frequencies(i) ; 
            %g = gabor(w, rad2deg(params.thetas(i))) ; 
            %H = imag(g.SpatialKernel) ; 

            options.omega = params.frequencies(i) ; 
            options.orientation = params.thetas(i) ; 
            %options.D0 = params.sigmas(i); 
            options.D0 = 50; 
            %options.D0 = 1 ;
            H = get_freq_transfer_fun(U, V, 'gabor', options);
            %H = GaborImag([P,Q], params.frequencies(i), params.thetas(i), 'sigma', 50) ;
            %H = fft2(H) ; 
            bank{i} = H; % paper suggests using imaginary component
        elseif filter_method == Filter.SPATIAL
            omega = params.frequencies(i) ; 
            theta = params.thetas(i) ; 
            sigma = params.sigmas(i) ; 
            [X,Y] = meshgrid(1:params.maskSize(1), 1:params.maskSize(2)) ; 
            center = [floor((params.maskSize(1)+1)/2), floor((params.maskSize(2)+1)/2)] ;
            
            xprime = X - center(1) ; yprime = Y - center(2) ; 
            arg = -1.0 * ((xprime).^2 + (yprime).^2) / (2 * sigma^2) ; 
            gauss = exp(arg) ; 
            
            arg2 = omega * (xprime * cos(theta) + yprime * sin(theta));
            sinu = sin(arg2) ; 
            
            bank{i} = gauss .* sinu ; 
        end
    end

    phi = zeros(size(I,1), size(I,2), length(params.frequencies));

    tStart = tic;

    for i = 1:length(params.frequencies)
        if filter_method == Filter.FREQUENCY
            phi(:,:,i) = freq_filter_image(im2double(I), P, Q, 'gabor', 'Huv', bank{i});
        else
            kernel = bank{i} ; 
            fun = @(block) sum(dot(kernel, block)) ; 
            phi(:,:, i) = nlfilter(im2double(I), params.maskSize, fun) ;
            %phi(:,:,i) = imfilter(im2double(I), bank{i}) ;
        end
    end

    %max_feature = max_vectorized(phi);

    [T1, T2] = GetThresholds(im2double(I), params.method, params.alpha);
    
    
    %max_feature(and(max_feature >= T1 , max_feature <=T2)) = 1 ; 
    %max_feature(max_feature<T1) = 0 ;
    %max_feature(max_feature>T2) = 2 ; 
    
    page_ranked = sort(phi, 3, 'descend') ; 

    phi1 = page_ranked(:,:, 1) ; 
    phi2 = page_ranked(:,:, 2) ; 
    
    %[T1, T2] = GetThresholds(im2double(phi1), params.method, params.alpha);

    I_max = zeros(size(phi1)) ; 

    cond1 = and(phi1 > T1 , phi2 <=T1) ; 
    cond2 = and(phi1 <=T1, phi2 >T1) ; 
    I_max(or(cond1, cond2)) = 1; % weak edge
    I_max(and(phi1<T1, phi2<T1)) = 0; % not an edge
    I_max(phi1+phi2 > T2) = 2; % strong edge
    
    max_feature = I_max ; 
   
    runtime = toc(tStart);
    % get the runtime after threshold, but not linking 
    
    feature = hysteresis_link(max_feature, params.neighborhood) ; 

end
