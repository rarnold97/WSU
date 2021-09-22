function fun = get_filter_handle(filterType, varargin)
% returns a proper function handle for convoluting using blockproc
% arg1: filterType -> string indicating the type of filter
% arg2 (variable arg): mask dims, 2 element vector [m,n]

    switch filterType

    case 'smoothing'

    case 'laplace'
        kernel = [-1 -1 -1; -1 8 -1; -1 -1 -1] ;
        c = 1.0 ; 
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

    otherwise 
        error('Invalid filter type option, try again ...')
        return
    end
end