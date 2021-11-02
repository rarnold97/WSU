function ms = snrms(f, fhat)
%% 
% computes SNRms of a given array of image values, f, and its decompressed estimate, fhat
% fhat -> estiamated image values
% f -> original values
% ms -> output SNRms value

    top = sum(fhat.^2) ; 

    if length(top) > 1
        top = sum(top) ; 
    end

    bot = sum((fhat - f).^2) ; 

    if length(bot) > 1
        bot = sum(bot);
    end

    ms = top / bot ;

end