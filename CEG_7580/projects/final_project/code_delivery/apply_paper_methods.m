function res = apply_paper_methods(params, out)

    for i = 1:length(params.I)

        %% first smoothen the image using a gaussian smoothing function
        % using one sigma for now
        % consider commenting out
        %params.I{i} = imgaussfilt(params.I{i}, 1);

        %% apply the different filtering methods

        % collect the other runtimes 
        params.nl = 3 ; 
        [~, out.SGW_runtime(1,i)] = SGW(params.I{i}, params, Scheme.SIMPLE);
        [~, out.SGW_eff_runtime(1,i)] = SGW(params.I{i}, params, Scheme.EFFICIENT);

        params.nl = 7 ;
        [~, out.SGW_runtime(3,i)] = SGW(params.I{i}, params, Scheme.SIMPLE);
        [~, out.SGW_eff_runtime(3,i)] = SGW(params.I{i}, params, Scheme.EFFICIENT);

        % 2 for the nl == 5 level
        params.nl = 5 ;
        [SGW_feat, out.SGW_runtime(2,i)] = SGW(params.I{i}, params, Scheme.SIMPLE);
        [SGW_eff_feat, out.SGW_eff_runtime(2,i)] = SGW(params.I{i}, params, Scheme.EFFICIENT);


        % more processing might be required using phis
        %[GW_feat, GW_phis, out.GW_runtime(i)] = apply_GW_filt(params.I{i}, params, Filter.FREQUENCY);
        [GW_feat, GW_phis, out.GW_runtime(i)] = apply_GW_filt(params.I{i}, params, Filter.SPATIAL);

        out.I_SGW{i} = SGW_feat ; 
        out.I_SGW_eff{i} = SGW_eff_feat ; 
        out.I_GW{i} = GW_feat ; 

        %% apply built-in thinning method to results 
        SGW_mask = imbinarize(SGW_feat, 0);
        SGW_eff_mask = imbinarize(SGW_eff_feat, 0);
        GW_mask = imbinarize(GW_feat, 0);

        out.I_SGW_thin{i} = uint8(params.strong * bwmorph(SGW_mask, 'thin', Inf));
        out.I_SGW_eff_thin{i} = uint8(params.strong * bwmorph(SGW_eff_mask, 'thin', Inf));
        out.I_GW_thin{i} = uint8(params.strong * bwmorph(GW_mask, 'thin', Inf));

    end

    res = out;

end
