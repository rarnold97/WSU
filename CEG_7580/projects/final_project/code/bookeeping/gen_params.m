function params = gen_params()
    % generate a data structure that employs the parameters
    % solved in the paper.  The research group did the heavy
    % lifting here.  I dont make the rules, just follow them :)

    params = struct() ; 

    % number of quantization levels
    params.nl = 5 ; 

    params.frequencies = [0.3 * pi, 0.3 * pi, 0.3 * pi, 0.3 * pi, 0.5 * pi, 0.5 * pi, 0.5 * pi, 0.5 * pi] ;
    params.thetas = [0.0, pi / 4, pi / 2, 3 * pi / 4, 0, pi / 4, pi / 2, 3 * pi / 4];
    
    sigma1  = 1.0 ; sigma2 = 0.5 ; sigma3 = 0.8 ; 
    params.sigmas = [sigma3 sigma1 sigma3 sigma1 sigma2 sigma2 sigma2 sigma2] ;

    params.maskSize = [7, 7] ; 

    % experimental flags
    params.method = 1 ; % threshold generation method 
    %params.method = 4 ;

    params.neighborhood = 8 ; 
    params.strong = 255 ;
    params.weak = 25 ;  

    % graph flags
    params.showQuantPlots = false ; 

    %image data 
    params.filenames = gen_file_list() ; 

    params.I = cell(1, length(params.filenames)) ; 
    for i = 1:length(params.filenames)
        params.I{i} = imread(params.filenames{i}) ; 
        if length(size(params.I{i})) > 2 
           params.I{i} = rgb2gray(params.I{i}) ; 
        end
    end

end
    
    

