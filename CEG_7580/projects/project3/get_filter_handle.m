function fun = get_filter_handle(filterType, varargin)
% returns a proper function handle for convoluting using blockproc
% arg1: filterType -> string indicating the type of filter
% arg2 (variable arg): mask dims, 2 element vector [m,n]

    switch filterType
    
    case 'average'
        mask_size = [3, 3] ; 
        if nargin > 1
            mask_size = varargin{1} ; 
            if length(mask_size) ~= 2
                error('Improper mask size, must be 2-element vector...')
            end
        end

        N = mask_size(1) * mask_size(2) ;
        fun = @(block_mat) sum(sum(block_mat/N)) ;

    case 'median'
        fun = @(block_mat) median(median(block_mat)) ;
        
    case 'smoothing'

    case 'laplace'
        %for kernel in figure 3.45 a
        choice = 'd';
        kernel = [-1 -1 -1; -1 8 -1; -1 -1 -1] ;
        c = 1.0 ; 

        if nargin > 1 
            choice = varargin{1};
        end

        switch choice 
            case 'a'
                c = -1.0 ; 
                kernel = [0 1 0; 1 -4 1; 0 1 0];
            case 'b'
                c = -1.0 ;
                kernel = [1 1 1; 1 -8 1; 1 1 1];
            case 'c'
                kernel = [0 -1 0; -1 4 -1; 0 -1 0];
            case 'd'
                kernel = [-1 -1 -1; -1 8 -1; -1 -1 -1] ;
            otherwise
                error('invalid figure kernel choice, options are a, b, c, d ...')
        end

        fun = @(block_mat) sum(sum(c*kernel.*block_mat)); 
    case 'sobel'
        kernel_x = [-1 -2 -1; 0 0 0; 1 2 1] ; 
        kernel_y = [-1 0 1; -2 0 2; -1 0 1] ;

        % syntax of the gradient operation:
        % M(x,y) = |gx| + |gy|

        fun = @(block_mat) ...
            abs(sum(sum(kernel_x.*block_mat))) + abs(sum(sum(kernel_y.*block_mat))) ; 

    case 'box'

        maskDims = [] ; 
        if nargin > 1
            maskDims = varargin{1} ; 
            if length(maskDims) ~= 2
                error('invalid mask dims, please try again ...')
            end
        else  
            %default as presented in textbook chapter 3
            maskDims = [5, 5] ;
        end

        mn = maskDims(1) * maskDims(2) ; 

        kernel = (1/mn) * ones(5) ; 
        fun = @(block_mat) sum(sum(kernel .* block_mat)) ; 

    case 'gaussian'

        K = 1.0 ; 
        sigma = 1.0;
        maskDims = [3,3] ;

        if nargin > 1
            maskDims = varargin{1} ; 
            if length(size(maskDims)) ~= 2
                error('Pass in 2 element vector for mask dims!')
            end
        end

        if nargin >= 2
            K = varargin{2} ; 
        end
        if nargin >=3
            sigma = varargin{3};
        end

        if (maskDims(1)==3 && maskDims(2)==3)
            %obtained from textbook, 4th ed. Chapter 3.5, page 168, Fig.3.35
            kernel = (1/4.8976) * [0.3679 0.6065 0.3679; 0.6065 1.00 0.6065; 0.3679 0.6065 0.3679];
        
        else 
            % we must derive the kernel in this case 
            distMat = zeros(maskDims);
            center = [floor(maskDims(1)/2)+1, floor(maskDims(2)/2)+1] ; 
            
            for i = 1:maskDims(1)
                for j = 1:maskDims(2)
                    distMat(i, j) = sqrt((i-center(1))^2 + (j-center(2))^2) ;
                end
            end

            arg = -1*(distMat.^2 / (2*sigma^2)) ; 
            w = K .* exp(arg) ; 
            mag = sum(sum(w));

            kernel = (1/mag) .* w ; 
        end
        
        fun = @(block_mat) sum(sum(kernel.*block_mat)) ; 
        
    otherwise 
        error('Invalid filter type option, try again ...')
    end
end