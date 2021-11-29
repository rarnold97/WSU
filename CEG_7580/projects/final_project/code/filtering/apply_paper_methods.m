function res = apply_paper_methods(params, out)

    for i = 1:length(params.I)

        %% first smoothen the image using a gaussian smoothing function
        % using one sigma for now
        % consider commenting out
        params.I{i} = imgaussfilt(params.I{i}, 1);

        %% apply the different filtering methods
        [SGW_feat, out.SGW_runtime] = SGW(params.I{i}, params, Scheme.SIMPLE);
        [SGW_eff_feat, out.SGW_eff_runtime] = SGW(params.I{i}, params, Scheme.EFFICIENT);

        % more processing might be required using phis
        [GW_feat, GW_phis, G out.GW_runtime] = apply_GW_filt(params.I{i}, params);

        %% apply built-in thinning method to results 
        SGW_mask = imbinarize(SGW_feat, 0);
        SGW_eff_mask = imbinarize(SGW_eff_feat, 0);
        GW_mask = imbinarize(GW_feat, 0);

        out.I_SGW{i} = uint8(255 * bwmorph(SGW_mask, 'thin', Inf));
        out.I_SGW_eff{i} = uint8(255 * bwmorph(SGW_eff_mask, 'thin', Inf));
        out.I_GW{i} = uint8(255 * bwmorph(GW_mask, 'thin', Inf));

    end

    res = out;

end
