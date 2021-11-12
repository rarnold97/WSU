function Problem4(varargin)

    if nargin >= 1
        pattern = varargin{1} ; 
    else
        pattern = '0733';
    end

    I = load_image(pattern, '*.tif') ; 
    %I_dbl = im2double(I) ; 

    R = I(:,:, 1) ; 
    G = I(:,:, 2) ; 
    B = I(:,:, 3) ; 

    %H_R = localhisteq(R, [5 5], 8) ; 
    %H_G = localhisteq(G, [5 5], 8) ; 
    %_B = localhisteq(B, [5 5], 8) ; 

    % equalize the components
    H_R = histeq(R, gray(256)) ; 
    H_G = histeq(G, gray(256)) ; 
    H_B = histeq(B, gray(256)) ; 
    
    % loop through all the bins and apply transfer function values
    Ra = R; Ga = G; Ba=B;
    for i = 1:256
       Ra(R==i-1) = R(R==i-1)*H_R(i,1) ;
       Ga(G==i-1) = G(G==i-1)*H_G(i,1) ;
       Ba(B==i-1) = B(B==i-1)*H_B(i,1) ;
    end

    I_a = zeros([size(I, 1), size(I, 2), 3]) ;
    I_a(:,:, 1) = Ra ; 
    I_a(:,:, 2) = Ga ; 
    I_a(:,:, 3) = Ba ;
    
    % compute the average transfer function
    H_avg = (H_R + H_G + H_B) ./3 ;
    % same as before, but use average now 
    Rnew = R; Gnew = G; Bnew = B;
    for i = 1:256
       Rnew(R==i-1) = R(R==i-1)*H_avg(i,1) ;
       Gnew(G==i-1) = G(G==i-1)*H_avg(i,1) ;
       Bnew(B==i-1) = B(B==i-1)*H_avg(i,1) ;
    end

    I_new = zeros([size(I, 1), size(I, 2), 3]) ; 
    I_new(:,:,1) = Rnew ; 
    I_new(:,:,2) = Gnew ; 
    I_new(:,:,3) = Bnew ; 

    %% display results

    %show histogram transfer functions
    fig = figure();
    set(0, 'CurrentFigure', fig);

    subplot(2,2, 1)
    rgbplot(H_R) ;
    title('R Transfer Fn')
    xlabel('r (input intensity)')
    ylabel('H(r)')

    subplot(2,2, 2)
    rgbplot(H_G) ;
    title('G Transfer Fn')
    xlabel('r (input intensity)')
    ylabel('H(r)')

    subplot(2,2, 3)
    rgbplot(H_B) ;
    title('B Transfer Fn')
    xlabel('r (input intensity)')
    ylabel('H(r)')

    subplot(2,2, 4)
    rgbplot(H_avg) ;
    title('Average Transfer Fn')
    xlabel('r (input intensity)')
    ylabel('H(r)')


    fig = figure();
    set(0, 'CurrentFigure', fig);

    subplot(2,2,1)
    imshow(Ra)
    title('R Component Part a')
    subplot(2,2,2)
    imshow(Ga)
    title('G Component Part a')
    subplot(2,2,3)
    imshow(Ba)
    title('B Component Part a')
    subplot(2,2,4)
    imshow(I)
    title('Reference Image')

    fig = figure();
    set(0, 'CurrentFigure', fig);

    subplot(2,2,1)
    imshow(Rnew)
    title('R Component Part a')
    subplot(2,2,2)
    imshow(Gnew)
    title('G Component Part b')
    subplot(2,2,3)
    imshow(Bnew)
    title('B Component Part c')
    subplot(2,2,4)
    imshow(I)
    title('Reference Image')

    fig = figure();
    set(0, 'CurrentFigure', fig);

    subplot(1,3,1)
    imshow(I)
    title('Original Image')

    subplot(1,3,2)
    imshow(uint8(I_a))
    title('Histogram Uniquely Applied to each RGB Component')

    subplot(1,3,3)
    imshow(uint8(I_new))
    title('Average Histogram Apllied to Each RGB Component')


end
