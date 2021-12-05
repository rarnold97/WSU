function res = gen_inter_data(params, out)

    %% first examine the effect of orientation and compare to the maximum feature
    out = part1(params, out); 
    %% examine the different number of quantization levels
    out = part2(params, out) ; 
    %% examine the effect of frequency
    out = part3(params, out) ; 
    
    res = out ; 

end


function out = part1(params, out)
    

    params.nl = 3 ; 

    % pass in true to return the phi values, which is non default behavior
    lenna_phis = SGW(im2double(params.lenna), params, Scheme.SIMPLE, true) ; 
    fish_phis = SGW(im2double(params.fish), params, Scheme.SIMPLE, true) ; 


    % based on how I initialized the parameters, omega = 0.3pi at the first four angles is the 
    % beginning 4 elements of phi

    fig4_phis_lenna = lenna_phis(:,:,1:4) ; 
    fig4_phis_fish = fish_phis(:,:,1:4) ; 

    [phi_max1_lenna, phi_max2_lenna] = get_top2_max(fig4_phis_lenna);
    [phi_max1_fish, phi_max2_fish]  = get_top2_max(fig4_phis_fish);

    %% apply thresholding
    %[T1_lenna, T2_lenna] = GetThresholds(im2double(params.lenna), params.method) ; 
    %[T1_fish, T2_fish] = GetThresholds(im2double(params.fish), params.method) ; 
    [T1_lenna, T2_lenna] = GetThresholds(im2double(phi_max1_lenna), params.method) ; 
    [T1_fish, T2_fish] = GetThresholds(im2double(phi_max1_fish), params.method) ; 
    
    lenna_extract = make_edges(phi_max1_lenna, phi_max2_lenna, T1_lenna, T2_lenna) ; 
    fish_extract = make_edges(phi_max1_fish, phi_max2_fish, T1_fish, T2_fish) ;

    lenna_thresh = hysteresis_link(lenna_extract, params.neighborhood) ; 
    fish_thresh = hysteresis_link(fish_extract, params.neighborhood) ; 

    %s.lenna_test_angle = cell(1, 6) ; 
    %s.fish_test_angle  = cell(1, 6) ; 

    for index = 1:4
        out.lenna_test_angle{index} = fig4_phis_lenna(:,:,index) ; 
        out.fish_test_angle{index} = fig4_phis_fish(:,:, index) ; 
    end

    out.lenna_test_angle{5} = phi_max1_lenna ; 
    out.fish_test_angle{5} = phi_max1_fish ; 

    out.lenna_test_angle{6} = lenna_thresh ; 
    out.fish_test_angle{6} = fish_thresh ; 

end

function out = part2(params, out)

    for i = 1:length(params.nl_effect)
        params.nl = params.nl_effect(i) ; 

        lenna_phis_56 = SGW(im2double(params.lenna), params, Scheme.SIMPLE, true) ; 
        fish_phis_56 = SGW(im2double(params.fish), params, Scheme.SIMPLE, true) ; 

        fig5_phis_lenna = lenna_phis_56(:,:,1:4) ; 
        fig5_phis_fish = fish_phis_56(:,:,1:4) ;
        
        fig6_phis_lenna = lenna_phis_56(:,:,5:end) ; 
        fig6_phis_fish = fish_phis_56(:,:, 5:end) ; 

        [phi_max_lenna1a,phi_max_lenna2a] = get_top2_max(fig5_phis_lenna) ; 
        [phi_max_fish1a, phi_max_fish2a] = get_top2_max(fig5_phis_fish) ; 

        [phi_max_lenna1b,phi_max_lenna2b] = get_top2_max(fig6_phis_lenna) ; 
        [phi_max_fish1b, phi_max_fish2b] = get_top2_max(fig6_phis_fish) ; 

        [T1_lenna1, T2_lenna1] = GetThresholds(phi_max_lenna1a, params.method) ; 
        [T1_lenna2, T2_lenna2] = GetThresholds(phi_max_lenna1b, params.method) ; 
        [T1_fish1, T2_fish1] = GetThresholds(phi_max_fish1a, params.method) ; 
        [T1_fish2, T2_fish2] = GetThresholds(phi_max_fish1b, params.method) ; 

        lenna_extract1 = make_edges(phi_max_lenna1a,phi_max_lenna2a, T1_lenna1, T2_lenna1) ; 
        lenna_extract2 = make_edges(phi_max_lenna1b,phi_max_lenna2b, T1_lenna2, T2_lenna2) ;

        fish_extract1 = make_edges(phi_max_fish1a, phi_max_fish2a, T1_fish1, T2_fish1) ; 
        fish_extract2 = make_edges(phi_max_fish1b, phi_max_fish2b, T1_fish2, T2_fish2) ; 
        
        lenna_thresh1 = hysteresis_link(lenna_extract1, params.neighborhood) ;  
        lenna_thresh2 = hysteresis_link(lenna_extract2, params.neighborhood) ;  

        fish_thresh1 = hysteresis_link(fish_extract1, params.neighborhood) ; 
        fish_thresh2 = hysteresis_link(fish_extract2, params.neighborhood) ; 

        %s.lenn_test_level_freq = cell(1, 6) ; 
        %s.fish_test_level_freq = cell(1, 6) ; 

        out.lenna_test_level_freq{i} = lenna_thresh1 ; 
        out.lenna_test_level_freq{i+3} = lenna_thresh2 ; 

        out.fish_test_level_freq{i} = fish_thresh1 ; 
        out.fish_test_level_freq{i+3} = fish_thresh2 ; 

    end

end

function out = part3(params, out)

    params.thetas = params.thetas(1:4) ; % we are only looking at one omeaga at a time now
    
    sigmaa = 1.6 ; 
    %sigmaa = 1.5 ; 
    sigmab = 0.8 ; 
    %sigmab = 0.35 ;
    sig_eff = ones(4, 4) ; 
    sig_eff(1,:) = sig_eff(1,:) * sigmaa ; 
    sig_eff(2,:) = params.sigmas(1:4) ; 
    %sig_eff(3,:) = [0.7 0.7 0.7 0.7] ; 
    sig_eff(3,:) = params.sigmas(5:8) ; 
    sig_eff(4,:) = sig_eff(4,:) * sigmab;

    params.nl = 5 ; % set to five levels 
    for j = 1:length(params.omega_effect)
        omega = params.omega_effect(j) ; 
        params.frequencies = omega * ones(1,4) ; 
        params.sigmas = sig_eff(j, :) ; 

        sgw_lenna_freq = SGW(im2double(params.lenna), params, Scheme.EFFICIENT, false) ; 
        sgw_fish_freq = SGW(im2double(params.fish), params, Scheme.EFFICIENT, false) ;

        out.lenna_test_freq{j} = sgw_lenna_freq ; 
        out.fish_test_freq{j} = sgw_fish_freq ; 
    end
end

function [max1, max2] = get_top2_max(page_data)
    page_ranked = sort(page_data, 3, 'descend') ; 

    max1 = page_ranked(:,:, 1) ; 
    max2 = page_ranked(:,:, 2) ; 
end

function extracted = make_edges(phi1, phi2, T1, T2)
    extracted = zeros(size(phi1)) ; 

    cond1 = and(phi1 > T1 , phi2 <=T1) ; 
    cond2 = and(phi1 <=T1, phi2 >T1) ; 
    extracted(or(cond1, cond2)) = 1; % weak edge
    extracted(and(phi1<T1, phi2<T1)) = 0; % not an edge
    extracted(phi1+phi2 > T2) = 2; % strong edge
end