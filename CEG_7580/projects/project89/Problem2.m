function Problem2(varargin)
    % accepts optional inputs:
    % varargin{1} file pattern or filename or showHisto (true/false)
    % varargin{2} showHisto (true/false) -> if also passing in the file regexp

    % set defaults
    pattern = '1035'; showHisto = false;

    if nargin >= 1

        if isstring(varargin{1})
            pattern = varargin{1};
        else
            showHisto = varargin{1};
        end

    end

    if nargin >= 2 % whether or not to plot histogram
        showHisto = varargin{2};
    end

    I = load_image(pattern);

    if showHisto
        % histogram only
        fig = figure();
        set(0, 'CurrentFigure', fig);
        % genereate histogram for testing
        [histgram, N] = imhist(I);

        bar(N, histgram)

        xlabel('Pixel Value')
        ylabel('Count')
        title('Image Histogram')
    else

        %I_dbl = im2double(I) ;

        %set default parameters
        T0 = 50;
        T = T0;
        Tprev = T0;

        deltaStop = 1; % end criteria in discrete
        deltaT = inf;

        count = 1;
        % iterate until minimum discrete threshold is met
        while deltaT > deltaStop

            % form the mask and its compliment
            G1_mask = I > T; G2_mask = I <= T;
            G1 = I(G1_mask); G2 = I(G2_mask);

            % calculate the means
            m1 = mean(mean(G1)); m2 = mean(mean(G2));
            % replace the previous
            Tprev = T;
            % calculate the new threshold
            T = 0.5 * (m1 + m2);
            % compare thresholds
            deltaT = T - Tprev;

            % how about we dont cause an infinite loop yeah?
            if count > 1000000
                warning('algorithm did not converge, exiting ...')
                break
            end

            count = count + 1;
        end

        % apply threshold
        mask = I > T;
        I_thresh = zeros(size(I));

        % we want black outlines
        I_thresh(mask) = 255;

        % display results
        fig = figure();
        set(0, 'CurrentFigure', fig);

        subplot(1, 3, 1)
        imshow(I)
        title('Original Image')

        subplot(1, 3, 2)
        [histgram, N] = imhist(I);
        bar(N, histgram)
        xlabel('Pixel Value')
        ylabel('Count')
        title('Input Histogram')

        subplot(1, 3, 3)
        imshow(I_thresh)
        title('Segmented Image')

    end

end
