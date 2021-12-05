function list = gen_file_list(varargin)
    %this used relative referencing.  Use correct dir if this is not desired
    % as the argument to varargin{1}

    if nargin >=1
        rootDir = varargin{1} ; 
    else
        [scriptDir] = fileparts(mfilename('fullpath')) ; 
        rootDir = fileparts(scriptDir) ; 
    end

    %dataDir = fullfile(rootDir,  'inputs') ; 
    dataDir = fullfile(scriptDir) ; 

    files = dir([dataDir, filesep, '*.tif']) ; 

    L = length(files) ; 
    
    list = cell(1, L) ; 

    for k = 1:L 
        list{k} = fullfile(files(k).folder, files(k).name);
    end

end