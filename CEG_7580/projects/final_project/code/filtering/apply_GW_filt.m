function [feature, phi, runtime] = apply_GW_filt(I, params)

    bank = cell(1, legnth(parms.frequencies));

    % on the fence about the 2pi part
    wavelengths = 2 * pi * (1 ./ params.frequencies);

    % computing the transfer function using a backdoor method to get a more accurate runtime
    % the paper states that the filter banks are precomputed
    [X, Y] = size(I);
    P = 2 * X; Q = 2 * Y;

    [U, V] = meshgrid(1:P, 1:Q);

    for i = 1:length(bank)
        H = get_freq_transfer_fun(U, V, 'gabor', 'orientation', params.thetas(i), 'omega', params.frequencies(i));
        bank{i} = complex(zeros(size(H)), imag(H)); % paper suggests using imaginary component
    end

    phi = cell(1, length(params.frequencies));

    tStart = tic;

    for i = 1:legnth(phi)
        phi{i} = freq_filter_image(I, P, Q, 'gabor', 'Huv', bank{i});
    end

    max_feature = max_vectorized(features);

    runtime = toc(tStart);

    [T1, T2] = GetThresholds(max_feature, params.method);
    T1 = T1 / max(max(max_feature)); T2 = T2 / max(max(max_feature));

    [tri, hys] = hysteresis3d(max_feature, T1, T2, params.neigborhood);

    feature = zeros(size(max_feature));
    feature(hys) = params.strong;

    feature = uint8(feature);
end
