function qWavelet = QuantizeWavelet(wavelet, nl, varargin)
    % Accepts a 2d Wavelets basis kernel, and quantizes it using nl for the number of levels
    %
    % in
    % wavelet -> 2D - wavelet kernel array
    % nl -> number of quantization levels
    % *optional: plot the quantized wavelet for debugging and for reporting 
    %
    % out
    % qWavelet - 2D quantized wavelet kernel used for SGW methods

    debugPlots = false  ; 
    
    if nargin > 2
        debugPlots = varargin{1} ; 
    end

    % Assuming that the real and imaginary components will be pre-separated

    % separate into most positive and most negative
    negative = wavelet(wavelet < 0);
    positive = wavelet(wavelet >= 0);

    % only need 1 invocation of max, since the data gets unrasterized using the logical indexing
    Aplus = max(positive);
    Aminus = -1 * max(abs(negative));

    np = floor((nl - 1) / 2);
    nn = floor((nl - 1) / 2);

    q_plus = zeros(1, np);
    q_minus = zeros(1, nn);

    for k = 1:np
        q_plus(k) = 2 * k * (Aplus / (2 * np + 1));
        q_minus(k) = 2 * k * (Aminus / (2 * nn + 1));
    end
    
    range_spc = (Aplus - Aminus) / nl;  
    levels = Aminus + range_spc : range_spc : Aplus - range_spc ; 
    values = [flip(q_minus) 0 q_plus];

    qWavelet = imquantize(wavelet, levels, values) ; 
    %codeblock = [flip(q_minus) 0 q_plus];

    if debugPlots
        figure();  
        imshow(shift_image_values(qWavelet))
        title('Quantized SGW')
    end

end
