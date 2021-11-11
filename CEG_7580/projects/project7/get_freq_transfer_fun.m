function Huv =  get_freq_transfer_fun(u,v, filterType, varargin)
% u -> u dimension of 2D frequency domain, pased in as a mesh MxN
% v -> v dimension of 2D frequency domain, pased in as a mesh MxN
% filterType -> string determining what type of filter transfer function to apply
% supported filterTypes:
%   > gaussian (high/lowpass)
%   > ideal (high/lowpass)
%   > butterworth (high/lowpass)
%   > dft - for returning frequency domain fn only, just returns ones
%
% varargin{1} -> options struct: defines defaults and filter parameters, depending on what filter is used
% options: > D0 - cutoff frequency
%          > n - butterworth parameter
%          > center - user defined center coordinates for P by Q grid in frequency domain. 2 element vector
%          > pass_type - string for 'highpass' or 'lowpass'


    % set default arguements if user does not pass in options struct
    if nargin >=1
        options = varargin{1};
    else 
        options = struct('D0',50,'n',1,'center',[], 'pass_type', 'gaussian', 'notche_idx', [], 'return_transfer', false);
    end

    % error handle for improper dimensions
    if any(size(u) ~= size(v))
        error('please pass in equal sized meshes for u and v')
    end

    if length(size(u)) > 2 || length(size(v)) > 2
        error('improper dimensions, pass in nxm dimensioned u and v domains ...')
    end

    % take in passed in u,v domains
    dims_u = size(u) ;
    dims_v = size(v) ;
    
    % user just passed in dimensions, create grid
    if (dims_u(1) == 1 && dims_u(2) == 1) && (dims_v(1)==1 && dims_v(2) == 1)
        u = 1:dims_u ; 
        v = 1:dims_v ; 

        [u, v] = meshgrid(u,v) ;
    
    else
        %user passed in a spaced array
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

    % set default center to be in middle
    if isempty(options.center)
        center = [0 0] ; 
        
        IS_M_EVEN = ~mod(M,2);
        IS_N_EVEN = ~mod(N,2);

        % check if even or odd. Estimate the center
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
        % user passed in the center
        center = options.center ;
    end

    % get the transfer function
    switch filterType
        
        case 'lowpass'
            % compute the distance parameter
            D = sqrt((u - center(1)).^2 + (v - center(2)).^2) ;

            %compute centered transfer function
            if strcmp(options.pass_type, 'gaussian')

                Huv = exp(-1*D.^2 ./ (2*options.D0^2)) ;

            elseif strcmp(options.pass_type, 'butterworth')
                Huv = 1 ./ (1 + (D./options.D0).^(2*options.n)) ;
            
            elseif strcmp(options.pass_type, 'ideal')
                D(D<=options.D0) = 1 ; 
                D(D>options.D0) = 0 ;
                Huv = D ; 

            elseif strcmp(options.pass_type, 'notche')
                if isempty(options.notche_idx)
                    error('If using a notche filter, provide coordinates of notche centers as a Nx2 array ...')
                end

                big_pi = zeros(length(options.D0), size(u,1), size(u,2)) ; 
                cent = options.center ; 
                for i=1:length(options.D0)
 
                    D0 = options.D0(i) ; 
                    notche_center = options.notche_idx(i,:) ; 
                    uk = notche_center(1);
                    vk = notche_center(2);

                    %Dk = sqrt((u - center(1) - uk).^2 + (v - center(2) - vk).^2) ; 
                    Dk = sqrt((u - uk).^2 + (v - vk).^2) ;
                    big_pi(i,:,:) = exp(-1*Dk.^2 ./(2*D0^2)) ; 
                end
                Huv = squeeze(prod(big_pi)) ;

            else 
                error('Please enter a valide pass filter type: gaussian or butterworth ...')
            end
        
        case 'highpass'
            % compute the distance parameter
            D = sqrt((u - center(1)).^2 + (v - center(2)).^2) ;

            %compute centered transfer function
            if strcmp(options.pass_type, 'gaussian')
                LP = exp(-1*D.^2 ./ (2*options.D0^2)) ;
                Huv = 1 - LP ;
            elseif strcmp(options.pass_type, 'butterworth')
                Huv = 1 ./ (1 + (options.D0./D).^(2*options.n)) ; 
            elseif strcmp(options.pass_type, 'ideal')
                D(D<options.D0) = 0 ; 
                D(D>=options.D0) = 1 ; 
                Huv = D ; 

                 % modification for project 7
            % the primary difference for notche is that vector quantities are passed instead of scalars
            elseif strcmp(options.pass_type, 'notche')
                if isempty(options.notche_idx)
                    error('If using a notche filter, provide coordinates of notche centers as a Nx2 array ...')
                end

                big_pi = zeros(length(options.D0), size(u,1), size(u,2)) ; 
                cent = options.center ; 
                for i=1:length(options.D0)
 
                    D0 = options.D0(i) ; 
                    notche_center = options.notche_idx(i,:) ; 
                    uk = notche_center(1);
                    vk = notche_center(2);

                    %Dk = sqrt((u - center(1) - uk).^2 + (v - center(2) - vk).^2) ; 
                    Dk = sqrt((u - uk).^2 + (v - vk).^2) ;
                    big_pi(i,:,:) = 1 - ( exp(-1*Dk.^2 ./(2*D0^2)) ); 
                end
                Huv = squeeze(prod(big_pi)) ;

            else 
                error('Please enter a valide pass filter type: gaussian or butterworth ...')
            end

        case 'dft'
            % will multiply Fuv simply by 1 in the caller function
            Huv = ones(size(u)) ; 
        otherwise 
            error('unrecognized input, please try again ...')

    end

end