function qWavlet = QuantizeWavelet(wavelet, nl)
% Accepts a 2d Wavelets basis kernel, and quantizes it using nl for the number of levels
%
% in
% wavelet -> 2D - wavelet kernel array
% nl -> number of quantization levels
%
% out
% qWavelet - 2D quantized wavelet kernel used for SGW methods

% Assuming that the real and imaginary components will be pre-separated

% separate into most positive and most negative 
negative = wavelet(wavelet<0) ; 
positive = wavelet(wavelet>=0) ; 

% only need 1 invocation of max, since the data gets unrasterized using the logical indexing
Aplus = max(positive) ;
-1*Aminus = max(abs(negative)) ; 

np = floor((nl-1)/2) ; 
nn = floor((nl-1)/2) ; 

q_plus = zeros(1, np) ; 
q_minus = zeros(1, nn) ;

for k = 1:np
    q_plus(k) = 2*k *(Aplus/(2*np + 1)) ;
    q_minus(k) = 2*k*(Aminus/(2*nn + 1)) ; 
end

boundaries = [Aminus q_minus q_plus Amax] ;

qvals = (boundaries(1:end-1) + boundaries(2:end)) / 2 ; 

codeblock = [flip(q_minus) 0 q_plus] ; 

end