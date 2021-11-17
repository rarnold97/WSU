function Problem5(varargin)
% accepts optional inputs:
% varargin{1} file pattern or filename or showHisto (true/false)
% varargin{2} showHisto (true/false) -> if also passing in the file regexp

    % do the standard load of the image 
    % set defaults
    pattern = '0920' ; showHisto = false ; 
    if nargin >=1
        if isstring(varargin{1})
            pattern = varargin{1} ;
        else
            showHisto = varargin{1} ; 
        end
    end

    if nargin>=2 % whether or not to plot histogram
        showHisto = varargin{2} ; 
    end

    I = load_image(pattern) ; 

    % first, threshold the image and erode 
    [histgram, counts] = imhist(I) ; 
    
    if showHisto
        fig = figure();
        set(0, 'CurrentFigure', fig);
        bar(counts, histgram)
        xlabel('Pixel Value')
        ylabel('Count')
        title('Chicken Histogram')
    end

    % by examining the histogram, I was able to trial and error determine a global threshold
    %T = otsuthresh(counts) ; 
    T = 203 ; 

    I_thresh = zeros(size(I)) ; 
    I_thresh(I>T) = 1 ; 

    se = strel('rectangle', [5 5]) ; 
    I_erode = imerode(I_thresh, se) ; 

    % compute the connected components 
    CC = bwconncomp(I_erode) ; 

    conn_total = CC.NumObjects ; 

    % generate table of the connected segment results
    conn_comps = 1:1:conn_total ; 
    conn_comps = conn_comps' ; 
    conn_counts = ones(conn_total, 1) ; 

    for i = 1:conn_total
        conn_counts(i) = length(CC.PixelIdxList{i}) ; 
    end

    tb = array2table([conn_comps conn_counts], 'VariableNames', {'Connected Comp.', 'Number of Pixels'}) ;

    % display the table in the command window
    clc % clear existing contents 
    disp(tb)

    %display results 
    fig = figure();
    set(0, 'CurrentFigure', fig);

    subplot(3,1 ,1)
    imshow(I)
    title('Original Image')

    subplot(3, 1, 2)
    % displaying the negative
    imshow(not(I_thresh))
    title('Negative of Thresholded Image')

    subplot(3, 1,3)
    imshow(I_erode)
    title('Eroded Image')
end