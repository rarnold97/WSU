function Problem1(varargin)

    filename1 = ''; 
    filename2 = ''; 
    filename3 = ''; 

    if nargin == 3  
        filename1 = varargin{1} ; 
        filename2 = varargin{2} ; 
        filename3 = varargin{3} ; 
    else
        filename1 = find_files_from_pattern('801(a)', '*.tif') ; 
        filename1 = filename1{1}; 
        filename2 = find_files_from_pattern('801(b)', '*.tif') ; 
        filename2 = filename2{1} ; 
        filename3 = find_files_from_pattern('801(c)', '*.tif') ; 
        filename3 = filename3{1} ; 
    end

    I1 = imread(filename1) ; 
    I2 = imread(filename2) ; 
    I3 = imread(filename3) ; 

    %calculate the entropy of the image matrices 
    entropy1 = calc_entropy(I1) ; 
    entropy2 = calc_entropy(I2) ; 
    entropy3 = calc_entropy(I3) ; 

    ent1str = num2str(entropy1) ; 
    ent2str = num2str(entropy2) ; 
    ent3str = num2str(entropy3) ; 

    msgStr = ['Figure 8.1a Entropy: ' ent1str newline 'Figure 8.1b Entropy: ' ...
        ent2str newline 'Figure 8.1c Entropy: ' ent3str ] ; 

    msgbox(msgStr)

end