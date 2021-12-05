
function imageFiles = find_files_from_pattern(patternStr, varargin)
% load the image file names into a cell structure, based on figure pattern
% pattern string -> patternStr

    ext = '*.tif' ; 
    if nargin > 1
        ext = varargin{1} ; 
    end

    [currDir] = fileparts(mfilename('fullpath')) ; 
    files = dir(fullfile(currDir, ext)) ; 
    imageFiles = {} ; 

    for k = 1:length(files)
        baseFileName = files(k).name ; 
        if contains(baseFileName, patternStr)
            fullFileName = fullfile(currDir, baseFileName);
            imageFiles(end+1) = {fullFileName} ; 
        end
    end

end