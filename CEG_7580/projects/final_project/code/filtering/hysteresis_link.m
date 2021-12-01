function linkedMat = hysteresis_link(features, neighborhood)

    %error handle
    if neighborhood ~= 4 && neighborhood ~= 8
        error('invalid neighborhood size input, must be 4 or 8 ...')
    end
    
    abovet1=features>=1;                                     % points above lower threshold
    seed_indices=sub2ind(size(abovet1),find(features==2));   % indices of points above upper threshold
    hys=imfill(~abovet1,seed_indices, neighborhood);              % obtain all connected regions in abovet1 that include points with values above t2
    hys=hys & abovet1;
    I_link = zeros(size(features)) ; 
    I_link(hys) = 255 ; 
    I_link = uint8(I_link) ;

    linkedMat = I_link ; 

end