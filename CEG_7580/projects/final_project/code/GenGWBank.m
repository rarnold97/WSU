function filters = GenGWBank(varargin)
% Purpose is to generate a filter bank to convolve the input images with
% the parameters are hard coded, as they were pre-selected in the journal paper
%
% in -> varargin{1} *optional: 2 element vector describing kernel
% dimensions
%
% out -> SGW (quantized) filters to be used in edge detection analysis via Image convolution

% debug parameter
%showQuantPlots = true ; 
showQuantPlots = false ; 
% this default value makes the images look the best for the report 
maskSize = [7 7] ;
if nargin >=1
    maskSize = varargin{1} ; 
end
% allowing use of the default sigma for the gaussian component of the wavelet
nl = 5 ; 
 
frequencies = [0.3*pi, 0.3*pi, 0.3*pi, 0.3*pi, 0.5*pi, 0.5*pi, 0.5*pi, 0.5*pi] ; 
thetas = [0.0, pi/4, pi/2, 3*pi/4, 0, pi/4, pi/2, 3*pi/4] ;

sigma1  = 1.0 ; sigma2 = 0.5 ; sigma3 = 0.8 ; 
%sigmas = [sigma1 sigma1 sigma1 sigma1 sigma2 sigma2 sigma2 sigma2] ; 
sigmas = [sigma3 sigma1 sigma3 sigma1 sigma2 sigma2 sigma2 sigma2] ; 

filters = cell(1,length(frequencies)) ; 


% going to create a figure demonstrating replication
fig = figure();
set(0, 'CurrentFigure', fig) ; 

for i = 1:length(frequencies)

    omega = frequencies(i) ; 
    theta = thetas(i) ; 
    sigma = sigmas(i) ; 

    sgw = GaborImag(maskSize, omega, theta, 'sigma', sigma , 'asDeg', false) ; 
    sgw_quant = QuantizeWavelet(sgw, nl, showQuantPlots) ; 
    filters{i} = sgw_quant ; 
    
    %plot results
    subplot(2,4, i)
    imshow(shift_image_values(sgw_quant))
    title(['SGW Kernel theta = ' num2str(theta) ' omega = ' num2str(omega)])
end

end