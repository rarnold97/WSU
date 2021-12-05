function gen_figures(res, params)
    %% function to display all processing results
    %
    % in
    %
    % res -> data structure containing all the image results


    % plot figure 4 in the paper
    fig4 = figure();
    set(0, 'CurrentFigure', fig4) ; 
    figHeaders = ['a', 'b', 'c', 'd', 'e', 'f', 'g'] ; 
    
    [ha, ~] = tight_subplot(2,7, [0.01, 0.03], [0.1 0.01], [0.01, 0.01]);
    axes(ha(1))
    imshow(params.fish)
    title(figHeaders(1))
    for i = 1:length(res.fish_test_angle)
       axes(ha(i+1));
       imshow(res.fish_test_angle{i})
       title(figHeaders(i+1))
    end
    axes(ha(8))
    imshow(params.lenna)
    for i = 1:length(res.lenna_test_angle)
       axes(ha(i+7+1))
       imshow(res.lenna_test_angle{i})
    end

    % plot figure 5 and 6 in paper
    fig5 = figure() ; 
    set(0, 'CurrentFigure', fig5);
    figHeaders = ['a', 'b', 'c'] ; 
    for ii = 1:3
        subplot(2,3, ii) 
        imshow(res.fish_test_level_freq{ii})
        title(figHeaders(ii))

        subplot(2,3, ii+3)
        imshow(res.lenna_test_level_freq{ii})
    end

    fig6 = figure() ; 
    set(0, 'CurrentFigure', fig6);

    ctr = 1 ; 
    for jj = 4:6
        subplot(2,3, ctr)
        imshow(res.fish_test_level_freq{jj}) 
        title(figHeaders(jj-3))

        subplot(2,3, ctr+3)
        imshow(res.lenna_test_level_freq{jj})

        ctr = ctr + 1;
    end

    % plot figure 7 in paper

    fig7 = figure() ; 
    set(0, 'CurrentFigure', fig7);
    figHeaders = ['a', 'b', 'c', 'd'] ; 

    for kk = 1:length(res.lenna_test_freq)
        subplot(2,4, kk)
        imshow(res.lenna_test_freq{kk})
        title(figHeaders(kk))

        subplot(2,4, kk+4)
        imshow(res.fish_test_freq{kk})
    end

    % generate figure 8 from paper
    fig8 = figure() ; 
    set(0, 'CurrentFigure', fig8);
    
    [ha, ~] = tight_subplot(2,6, [0.01, 0.03], [0.1 0.01], [0.01, 0.01]);
    figHeaders = ['a','b','c', 'd', 'e', 'f'] ;

    axes(ha(1))
    imshow(res.I_GW{params.i_fish})
    title(figHeaders(1))

    axes(ha(2))
    imshow(res.I_SGW{params.i_fish})
    title(figHeaders(2))

    axes(ha(3))
    imshow(res.I_SGW_eff{params.i_fish})
    title(figHeaders(3))

    axes(ha(4))
    imshow(res.I_GW_thin{params.i_fish})
    title(figHeaders(4))

    axes(ha(5))
    imshow(res.I_SGW_thin{params.i_fish})
    title(figHeaders(5))

    axes(ha(6))
    imshow(res.I_SGW_eff_thin{params.i_fish})
    title(figHeaders(6))

    axes(ha(7))
    imshow(res.I_GW{params.i_lenna})

    axes(ha(8))
    imshow(res.I_SGW{params.i_lenna})

    axes(ha(9))
    imshow(res.I_SGW_eff{params.i_lenna})

    axes(ha(10))
    imshow(res.I_GW_thin{params.i_lenna})

    axes(ha(11))
    imshow(res.I_SGW_thin{params.i_lenna})

    axes(ha(12))
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
        title('a')

        %sobel
        subplot(1,5, 2)
        imshow(res.I_sobel{iii})
        title('b')

        % LoG - laplacian of gradient
        subplot(1,5, 3)
        imshow(res.I_LoG{iii})
        title('c')

        % Canny 
        subplot(1,5, 4)
        imshow(res.I_canny{iii})
        title('d')

        %SGW, assuming after applying thinning ?? (they didnt specify )
        subplot(1,5, 5)
        imshow(res.I_SGW_eff{iii})
        title('e')
    end
    
    SGW_runtimes = res.SGW_runtime(:,1) ; 
    SGW_eff_runtimes = res.SGW_eff_runtime(:, 1) ; 
    GW_runtime = res.GW_runtime(1) ; 
    percent_increase = 100* abs(SGW_eff_runtimes - GW_runtime) / GW_runtime ; 
    % generate runtime table using lenna as the reference image 
    table = {'Algorithm' '3 Level Runtime (s)', '5 Level Runtime (s)', '7 Level Runtime (s)' ; ...
            'SGW Efficient', SGW_eff_runtimes(1), SGW_eff_runtimes(2), SGW_eff_runtimes(3) ; ...
            'SGW', SGW_runtimes(1), SGW_runtimes(2), SGW_runtimes(3) ; ...
            'GW' , GW_runtime, GW_runtime, GW_runtime ; ...
            'Percent Increase Runtime GW->SGW_efficient', percent_increase(1), percent_increase(2), percent_increase(3)};
        
    T = cell2table(table(2:end, :));
    T.Properties.VariableNames = table(1, :) ; 
    disp(T)

end
