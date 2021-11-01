function plotwavelet2(C,S,levels,wavelet, intensities)
%% Disclaimer: I borrowed and modified this source code from the matlab filexchange.
% Credit goes to the original author: Benjamin Tremoulheac.
%
%   Plot wavelet image (2D) decomposition.
%   A short and simple function for displaying wavelet image decomposition
%   coefficients in 'tree' or 'square' mode
%
%   Required : MATLAB, Image Processing Toolbox, Wavelet Toolbox
%
%   plotwavelet2(C,S,level,wavelet,rv,mode)
%
%   Input:  C : wavelet coefficients (see wavedec2)
%           S : corresponding bookkeeping matrix (see wavedec2)
%           level : level decomposition 
%           wavelet : name of the wavelet
%           intensities : rescale value, typically the length of the colormap
%                (see "Wavelets: Working with Images" documentation)
%
%   Output:  none
%
%   Example:
%
%     % Load image
%     load wbarb;
%     % Define wavelet of your choice
%     wavelet = 'haar';
%     % Define wavelet decomposition level
%     level = 2;
%     % Compute multilevel 2D wavelet decomposition
%     [C S] = wavedec2(X,level,wavelet);
%     % Define colormap and set rescale value
%     colormap(map); rv = length(map);
%     % Plot wavelet decomposition using square mode
%     plotwavelet2(C,S,level,wavelet,rv,'square');
%     title(['Decomposition at level ',num2str(level)]);
%
%
%   Benjamin Tremoulheac, benjamin.tremoulheac@univ-tlse3.fr, Apr 2010

A = cell(1,levels); H = A; V = A; D = A;
for k = 1:levels
    A{k} = appcoef2(C,S,wavelet,k); % approx
    [H{k}, V{k}, D{k}] = detcoef2('a',C,S,k); % details  
    
    % scale the data so that it is more visible
    % scaling to be integers from [1, intensities]
    A{k} = wcodemat(A{k},intensities);
    H{k} = wcodemat(H{k},intensities);
    V{k} = wcodemat(V{k},intensities);
    D{k} = wcodemat(D{k},intensities);
end
    % create a giant array from all of the sub images
    % each scale level contains a tile for the approximate coefficients
    % and the vertical, horizontal and diagonal coefficients
    dec = cell(1,levels);
    dec{levels} = [A{levels} H{levels} ; V{levels} D{levels}];
    
    for k = levels-1:-1:1
        dec{k} = [imresize(dec{k+1},size(H{k})) H{k} ; V{k} D{k}];
    end
    
    imshow(uint8(dec{1}));
    
end