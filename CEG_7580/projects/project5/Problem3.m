function Problem3(varargin)

if nargin >= 1
    files = cell(varargin(1)) ; 
else
    files = find_files_from_pattern('30(a)');
end

%decomposition parameters
levels = 3; w = 'haar' ; intensities = 256 ;

for f = files
    
    file = f{1} ; 
   
    %% part b
    I = imread(file) ; 
    I_double = im2double(I) ; 
    
    % start performing the wavelet decomposition for 3 total levels
    [c, s] = wavedec2(I_double, 3, w) ; 
    
    %extract the levels of the decomposition
    [H1, V1, D1] = detcoef2('all', c, s, 1) ;
    [H2, V2, D2] = detcoef2('all', c, s, 2) ; 
    [H3, V3, D3] = detcoef2('all', c, s, 3) ;
    
    a1 = appcoef2(c,s,w,1);
    a2 = appcoef2(c,s,w,2);
    a3 = appcoef2(c,s,w,3);

    fig1 = figure() ; 
    set(0, 'CurrentFigure', fig1) ; 
    plot_wavelet_level(a1, H1, V1, D1, 'Level 1 Wavelet Decomposition')

    fig2 = figure() ; 
    set(0, 'CurrentFigure', fig2) ; 
    plot_wavelet_level(a2, H2, V2, D2, 'Level 2 Wavelet Decomposition')

    fig3 = figure() ; 
    set(0, 'CurrentFigure', fig3) ; 
    plot_wavelet_level(a3, H3, V3, D3, 'Level 3 Wavelet Decomposition')
        
    %% part c
    I_rec = waverec2(c, s, w) ; 
    max_err = max(max(abs(I_rec - I_double) )) ;  
    
    %setup plot object
    fig4 = figure() ; 
    set(0, 'CurrentFigure', fig4) ; 
    
    imshow(shift_image_values(I_rec))
    title(['Reconstructed Image from ' num2str(levels) ' level decomposision, ' ...
        'Max Error: ' num2str(max_err)])


    %% part d
    % note that the detail coefficients are already scaled as part of the
    % plotwavelet2 function to replicate figure in book
    
    fig5 = figure() ; 
    set(0, 'CurrentFigure', fig5) ; 
    
    plotwavelet2(c,s,levels, w, intensities)
    title('Display of Scaled Wavelet Decompositions, Retaining Sampled Image Sizes')
        

end