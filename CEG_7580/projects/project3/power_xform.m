function I_xform = power_xform(I, c, gamma)
    % performs power law tranformation on an input image
    % I -> input image dataset.  gray level
    % c -> coefficient multiplier
    % gamma -> exponential coefficient
        
        % make sure data isnt integer.  Convert to double if it is
        test_type_val = I(1,1) ; 
        if ~isa(test_type_val, 'double')
           I = im2double(I) ;  
        end
        
        % apply xform
        I_xform = c*I.^gamma ;
        %linearly scale data back to [0-255]
        I_xform = shift_image_values(I_xform) ; 
        
    end