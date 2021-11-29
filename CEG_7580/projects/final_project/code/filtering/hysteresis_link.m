function linkedMat = hysteresis_link(I, neigborhood, varargin)

    %error handle
    if neighborhood ~= 4 && neighborhood ~= 8
        error('invalid neighborhood size input, must be 4 or 8 ...')
    end

    weak = 25; strong = 255 ; 
    if nargin == 3
        weak = varargin{1}; strong = varargin{2};
    end

    [M,N] = size(I) ; 

    linkedMat = zeros(size(I)) ; 

    % I hate for loops but I am referencing source code from :
    % @link : https://towardsdatascience.com/canny-edge-detection-step-by-step-in-python-computer-vision-b49c3a2d8123
    for i = 2:M-1 
        for j = 2:N-1 
            if I(i,j) == weak 
                try
                    % examine the neighborhood around the pixel element
                    % this method uses either 4 or 8 block neighborhoods
                    truth = false ; 

                    if neighborhood == 8
                        truth = (I(i+1, j-1) == strong) || (I(i+1, j) == strong)  || (I(i+1, j+1) == strong) ...
                        || (I(i, j-1)==strong) || (I(i, j+1)) == strong ...
                        || (I(i-1, j-1) == strong) || (I(i-1, j) == strong) || (I(i-1, j+1)==strong) ; 

                    elseif neighborhood == 4
                        truth = (I(i+1, j)==strong) || (I(i-1, j)==strong) || ... 
                            (I(i, j+1)==strong) || (I(i, j-1)==strong) ; 
                    end
                    
                    if truth          
                        linkedMat(i,j) = strong ; 
                    end
                catch ME 
                    continue
                end
            end
        end
    end

    % convert to integers so imshow will render correctly 
    linkedMat = uint8(linkedMat) ; 

end