function Sxy = GaborImag(maskSize, omega, theta, varargin)
% Computes the imaginary component of a Gabor wavelet, as recommended by the journal paper
%
% In
% maskSize -> MXN kernel dims, 2 element vector
% omega -> Sinusoidal frequency component
% theta -> Orientation in degrees
% varargin{1} -> optionally pass in sigma.  Defaulting to 3

    theta = (pi/180.0) * theta ;  % convert to radians 
    if length(maskSize)~=2
        error('Improper dims for mask size, pass in a 2 element vector describing 2D kernel dimensions ...')
    end

    if nargin > 3
        sigma = varargin{1} ; 
    else
        % set default sigma if not passed in varargin{1}
        sigma = 2 ; % not very well defined, probably fine to be in the range 1-3.  Wikipedia source uses 3 
    end

    center = [floor(maskSize(1)/2) + 1 , floor(maskSize(2)/2 + 1)]; 

    [X, Y] = meshgrid(1:maskSize(1), 1:maskSize(2)) ; 

    arg1 = -1.0*(((X-center(1)).^2 + (Y-center(2)).^2)/(2*sigma^2)) ; 

    %arg2 = omega *(X*cos(theta) + Y*sin(theta)) ; 
    arg2 = omega *((X-center(1))*cos(theta) + (Y-center(2))*sin(theta)) ; 

    Sxy = exp(arg1) .* sin(arg2) ; 

end