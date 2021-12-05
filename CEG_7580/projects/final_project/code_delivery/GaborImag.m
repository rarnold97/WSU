function Sxy = GaborImag(maskSize, omega, theta, varargin)
    % Computes the imaginary component of a Gabor wavelet, as recommended by the journal paper
    %
    % In
    % maskSize -> MXN kernel dims, 2 element vector
    % omega -> Sinusoidal frequency component
    % theta -> Orientation in degrees
    % varargin -> keyworded args.  'asDeg' input angle is degrees.  'sigma' guassian function spread distance

    options = struct('asDeg', false, 'sigma', 2);
    options = parse_inputs(options, varargin);

    if length(maskSize) ~= 2
        error('Improper dims for mask size, pass in a 2 element vector describing 2D kernel dimensions ...')
    end

    if options.asDeg
        theta = (pi / 180.0) * theta; % convert to radians
    end

    sigma = options.sigma;

    center = [floor(maskSize(1) / 2) + 1, floor(maskSize(2) / 2 + 1)];

    [X, Y] = meshgrid(1:maskSize(1), 1:maskSize(2));

    arg1 = -1.0 * (((X - center(1)).^2 + (Y - center(2)).^2) / (2 * sigma^2));

    %arg2 = omega *(X*cos(theta) + Y*sin(theta)) ;
    arg2 = omega * ((X - center(1)) * cos(theta) + (Y - center(2)) * sin(theta));

    Sxy = exp(arg1) .* sin(arg2);

end
