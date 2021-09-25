function I_xform = power_xform(I, c, gamma, varargin)
    % performs power law tranformation on an input image
    % I -> input image dataset.  gray level
    % c -> coefficient multiplier
    % gamma -> exponential coefficient
    % optional *
    % arg1 -> return as shifted int, or just double
        
        asInt = true ;
        if nargin > 3
            asInt = varargin{1};
        end 

        % make sure data isnt integer.  Convert to double if it is
        test_type_val = I(1,1) ; 
        if ~isa(test_type_val, 'double')
           I = im2double(I) ;  
        end
        
        % apply xform
        I_xform = real(c*I.^gamma) ;

        if asInt
            %linearly scale data back to [0-255], if user so chooses
            I_xform = shift_image_values(I_xform) ; 
        end
        
    end