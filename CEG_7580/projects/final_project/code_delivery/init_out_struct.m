function s = init_out_struct(nImages)
% initializes an output result data structure to pass along between functions
% mostly organizational
%
% out -> s : result data structure 

    s = struct();

    % paper filtering results 
    s.I_SGW = cell(1, nImages); 
    s.I_GW = cell(1, nImages);
    s.I_SGW_eff = cell(1, nImages); 

    s.I_SGW_thin = cell(1, nImages); 
    s.I_GW_thin = cell(1, nImages);
    s.I_SGW_eff_thin = cell(1, nImages); 

    % intermediate figure results
    s.lenna_test_angle = cell(1, 6) ; 
    s.fish_test_angle  = cell(1, 6) ; 

    % elements 1-3 are omega = 0.3 pi 
    s.lenna_test_level_freq = cell(1, 6) ; 
    s.fish_test_level_freq = cell(1, 6) ; 

    % examining frequency
    s.lenna_test_freq = cell(1, 4) ; 
    s.fish_test_freq = cell(1, 4) ; 
    

    % validation results
    s.I_canny = cell(1, nImages); 
    s.I_LoG = cell(1, nImages);
    s.sobel = cell(1, nImages);

    % runtime stuff 
    s.SGW_runtime = zeros(3, nImages) ; 
    s.SGW_eff_runtime = zeros(3, nImages) ; 
    s.GW_runtime = zeros(1, nImages) ; 
	s.Canny_runtime = zeros(1, nImages) ; 

    % minimax threshold stuff
    s.T1 = 0.1 * ones(1, nImages) ; 
    s.T2 = 2 * s.T1; 


end