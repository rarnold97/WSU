function gen_figures(res, params)
    %% function to display all processing results
    %
    % in
    %
    % res -> data structure containing all the image results


    % plot figure 4 in the paper
    fig4 = figure();
    set(0, 'CurrentFigure', fig4);

    subplot(2,7, 8)
    imshow(params.lenna)
    
    subplot(2,7, 1)
    imshow(params.fish)

    for i = 1:length(res.lenna_test_angle)
        subplot(2,7, i+1) 
        imshow(res.fish_test_angle{i}) ; 

        subplot(2,7, i+1+7)
        imshow(res.lenna_test_angle{i})
    end

    % plot figure 5 and 6 in paper
    fig5 = figure() ; 
    set(0, 'CurrentFigure', fig5);
    for ii = 1:3
        subplot(2,3, ii) 
        imshow(res.fish_test_level_freq{ii})

        subplot(2,3, ii+3)
        imshow(res.lenna_test_level_freq{ii})
    end

    fig6 = figure() ; 
    set(0, 'CurrentFigure', fig6);

    ctr = 1 ; 
    for jj = 4:6
        subplot(2,3, ctr)
        imshow(res.fish_test_level_freq{jj}) 

        subplot(2,3, ctr+3)
        imshow(res.fish_test_level_freq{jj})

        ctr = ctr + 1;
    end

    % plot figure 7 in paper

    fig7 = figure() ; 
    set(0, 'CurrentFigure', fig7);

    for kk = 1:length(res.lenna_test_freq)
        subplot(2,4, kk)
        imshow(res.lenna_test_freq{kk})

        subplot(2,4, kk+4)
        imshow(res.fish_test_freq{kk})
    end

    % generate figure 8 from paper
    fig8 = figure() ; 
    set(0, 'CurrentFigure', fig8);

    subplot(2,6, 1)
    imshow(res.I_GW{params.i_fish})

    subplot(2,6,2)
    imshow(res.I_SGW{params.i_fish})

    subplot(2,6,3)
    imshow(res.I_SGW_eff{params.i_fish})

    subplot(2,6, 4)
    imshow(res.I_GW_thin{params.i_fish})

    subplot(2, 6, 5)
    imshow(res.I_SGW_thin{params.i_fish})

    subplot(2,6, 6)
    imshow(res.I_SGW_eff_thin{params.i_fish})

    subplot(2,6, 7)
    imshow(res.I_GW{params.i_lenna})

    subplot(2,6, 8)
    imshow(res.I_SGW{params.i_lenna})

    subplot(2,6, 9)
    imshow(res.I_SGW_eff{params.i_lenna})

    subplot(2,6, 10)
    imshow(res.I_GW_thin{params.i_lenna})

    subplot(2,6, 11)
    imshow(res.I_SGW_thin{params.i_lenna})

    subplot(2,6, 12)
    imshow(res.I_SGW_eff_thin{params.i_lenna})

    % generate the composite image shown in figure 10
    %fig10 = figure() ; 
    %set(0, 'CurrentFigure', fig10);

    n = length(params.I);
    for iii = 1:n
        fig10 = figure() ; 
        set(0, 'CurrentFigure', fig10);
        
        %rowStart = (iii-1)*5 ; 
        
        %original image
        subplot(1,5, 1)
        imshow(params.I{iii})

        %sobel
        subplot(1,5, 2)
        imshow(res.I_sobel{iii})

        % LoG - laplacian of gradient
        subplot(1,5, 3)
        imshow(res.I_LoG{iii})

        % Canny 
        subplot(1,5, 4)
        imshow(res.I_canny{iii})

        %SGW, assuming after applying thinning ?? (they didnt specify )
        subplot(1,5, 5)
        imshow(res.I_SGW{iii})
    end


end
