function recon = transform_compress(I, N, xform_type)
%% compresses an image based on a transform
% employs N-largest coefficient technique
% I -> input image array
% N -> number of largest coefficients
% xform_type -> type of transform, options are: DCT, DFT
% recon -> compresses and reconstructs image array using transform and N
% largest techniques

I_double = im2double(I) ; 
dims = size(I);
block_size = [8 8] ; 

if N > 64
    error('N is too large for 8x8 block, try again ...')
end

is1d = dims(1) == 1 || dims(2) == 1 ; 

% consider zero padding the input block arrays ???
    switch lower(xform_type) % switch transform fns based on user selection
    case 'dct'
        if is1d
            xform_fn = @(block) dct(block) ;
            inv_fn = @(block) idct(block) ; 
        else
            xform_fn = @(block) dct2(block) ; 
            inv_fn = @(block) idct2(block) ; 
        end
    case 'dft'
        if is1d
            xform_fn = @(block) fft(block);
            inv_fn = @(block) ifft(block) ; 
        else
            xform_fn = @(block) fft2(block) ; 
            inv_fn = @(block) ifft2(block) ; 
        end
    otherwise
        error('invalid xform type ...')
    end

    % get a function handle for block processing by xforming, retaining N largest, then inverting
    comp_handle = @(block_struct) inv_fn(n_largest(xform_fn(block_struct.data), N)) ; 

    % perform 8 by 8 block processing on image data 
    recon = real(blockproc(I_double, block_size, comp_handle)) ; 
    
end


function largest = n_largest(A, N)
    % gather all the unique values of the coefficients
    %unique_coeffs = unique(A) ; 
    
    % sort in descending order
    %coeffs_sorted = sort(unique_coeffs, 'descend');
    dims = size(A) ; 

    % sort the array and store the largest coefficients
    coeffs_sorted = sort(reshape(A, 1, dims(1)*dims(2)), 'descend');
    n_larg = coeffs_sorted(1:N) ; 

    % create mask by logically comparing to all the coefficients
    mask = zeros(size(A)) ; 
    for coeff = n_larg
        mask = mask | (A==coeff);
    end

    % truncate the non largest coefficients 
    largest = zeros(size(A));
    largest(mask) = A(mask) ; 

end