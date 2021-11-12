function I = load_image(pattern, varargin)
    %% implements the rinse and repeat of loading an image, converting to double, etc
    % inputs
    %
    % pattern -> image filename or filename pattern to look for
    % *optional -> varargin{1}, ext -> defaults to .tif
    %
    % outputs -> returns image

    ext = '' ; 
    if nargin >= 1
        ext = varargin{1} ;
    else
        ext = '*.tif' ; 
    end

    filename = find_files_from_pattern(pattern, ext) ; 
    % dereference the image from the cell array.  just gonna take the first element in the case of duplicates

    filename = filename{1} ; 

    I = imread(filename) ; 

end