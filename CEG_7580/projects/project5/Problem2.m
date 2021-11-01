function Problem2()

    %discrete function of 4 points
    fx = [1 4 -3 0] ; 
    wavelet = 'haar' ; 

    [c, l] = wavedec(fx, 2, wavelet) ; 
    
    origValues = waverec(c,l, wavelet) ; 
    
    msgbox(['Coefficients: {', num2str(c(1)), ' ', num2str(c(2)), ...
        ' ', num2str(c(3)), ' ', num2str(c(4)), '}', newline, ...
        'Inverse DWT Results: {', num2str(origValues(1)), ' ', ... 
        num2str(origValues(2)), ' ', num2str(origValues(3)), ' ', ...
        num2str(origValues(4)), '}'])
    
end