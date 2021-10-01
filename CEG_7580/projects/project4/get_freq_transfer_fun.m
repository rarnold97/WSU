function Huv =  get_freq_transfer_fun(u,v, filterType, varargin)
% u -> u dimension of 2D frequency domain, pased in as a mesh MxN
% v -> v dimension of 2D frequency domain, pased in as a mesh MxN

    if nargin >=1
        options = varargin{1};
    else 
        options = struct('D0',50,'n',1,'center',[], 'pass_type', 'gaussian');
    end

    if any(size(u) ~= size(v))
        error('please pass in equal sized meshes for u and v')
    end

    if length(size(u)) > 2 || length(size(v)) > 2
        error('improper dimensions, pass in nxm dimensioned u and v domains ...')
    end

    dims_u = size(u) ;
    dims_v = size(v) ;
    
    if (dims_u(1) == 1 && dims_u(2) == 1) && (dims_v(1)==1 && dims_v(2) == 1)
        u = 1:dims_u ; 
        v = 1:dims_v ; 

        [u, v] = meshgrid(u,v) ;
    
    else
        IS_U_Vector = dims_u(1) == 1 || dims_u(2) == 1 ; 
        IS_V_Vector = dims_v(1) == 1 || dims_v(2) == 1 ;

        if IS_U_Vector && IS_V_Vector
            [u, v] = meshgrid(u,v);
        elseif (~IS_U_Vector && IS_V_Vector) || (IS_U_Vector && ~IS_V_Vector)
            error('Either pass in both vectors or both matrices, do not missmatch for u and v ...')
        end
    end
    
    [M, N] = size(u) ; % size of v will be the same

    % we are assuming that we are dealing with a symmetric, centered input matrix
    % in most cases, we will need to know the center

    if isempty(options.center)
        center = [0 0] ; 
        
        IS_M_EVEN = ~mod(M,2);
        IS_N_EVEN = ~mod(N,2);

        if IS_M_EVEN
            center(1) = floor(M/2) ;
        else
            center(1) = floor(M/2) + 1 ; 
        end
        
        if IS_N_EVEN
            center(2) = floor(N/2) ;
        else
            center(2) = floor(N/2) + 1;
        end
    else  
        center = options.center ;
    end

    switch filterType

        case 'lowpass'

            D = sqrt((u - center(1)).^2 + (v - center(2)).^2) ;

            if strcmp(options.pass_type, 'gaussian')

                Huv = exp(-1*D.^2 ./ (2*options.D0^2)) ;

            elseif strcmp(options.pass_type, 'butterworth')
                Huv = 1 ./ (1 + (D./options.D0).^(2*options.n)) ;

            else 
                error('Please enter a valide pass filter type: gaussian or butterworth ...')
            end
        
        case 'highpass'

            D = sqrt((u - center(1)).^2 + (v - center(2)).^2) ;

            if strcmp(options.pass_type, 'gaussian')
                LP = exp(-1*D.^2 ./ (2*options.D0^2)) ;
                Huv = 1 - LP ;
            elseif strcmp(options.pass_type, 'butterworth')
                LP = 1 ./ (1 + (D./options.D0).^(2*options.n)) ; 
                Huv = 1 - LP ;
            else 
                error('Please enter a valide pass filter type: gaussian or butterworth ...')
            end

        case 'ideal'
            D = sqrt((u - center(1)).^2 + (v - center(2)).^2) ; 
            D(D<options.D0) = 0;
            D(D>=options.D0) = 1;
            Huv = D ; 
        otherwise 
            error('unrecognized input, please try again ...')

    end

end