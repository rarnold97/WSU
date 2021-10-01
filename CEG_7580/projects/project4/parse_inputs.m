function options_out = parse_inputs(options, varargin)

    %# define defaults at the beginning of the caller code so that you do not need to
    %# scroll way down in case you want to change something or if the help is
    %# incomplete
    
    %# read the acceptable names
    optionNames = fieldnames(options);
    
    %# count arguments
    nArgs = length(varargin{1});
    if round(nArgs/2)~=nArgs/2
        error('EXAMPLE needs propertyName/propertyValue pairs')
    end
    
    for pair = reshape(varargin{1},2,[]) %# pair is {propName;propValue}
        inpName = pair{1};     
        if any(strcmp(inpName,optionNames))
            %# overwrite options. If you want you can test for the right class here
            %# Also, if you find out that there is an option you keep getting wrong,
            %# you can use "if strcmp(inpName,'problemOption'),testMore,end"-statements
            options.(inpName) = pair{2};
        else
            error('%s is not a recognized parameter name',inpName)
        end
    end

    options_out = options ;

end