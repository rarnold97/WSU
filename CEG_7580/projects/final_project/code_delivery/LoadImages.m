function I_arr = LoadImages()

    lenna = 'Lenna.tif';
    peppers = 'peppers.tif';
    polygons = 'polygons.tif';
    words = 'text.tif';

    if ~isfile(lenna)
        [file, filepath] = uigetfile('*.tif', 'Find Lenna Image file') ; 
        lenna = fullfile(filepath, file) ;
    end

    if ~isfile(peppers)
        [file, filepath] = uigetfile('*.tif', 'Locate Peppers Image file');
        peppers = fullfile(filepath, file) ;
    end

    if ~isfile(polygons)
        [file, filepath] = uigetfile('*.tif', 'Locate Polygons Image file');
        polygons = fullfile(filepath, file) ; 
    end


    if ~isfile(words)
        [file, filepath] = uigetfile('*.tif', 'Locate Words Image file');
        words = fullfile(filepath, file) ; 
    end


    I_arr = cell(1,4) ;

    I_arr{1} = im2double(imread(lennna)) ; 
    I_arr{2} = im2double(imread(peppers)) ;
    I_arr{3} = im2double(imread(polygons)) ; 
    I_arr{4} = im2double(imread(words)) ;

end