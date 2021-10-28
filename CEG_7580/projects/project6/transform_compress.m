function compressed = transform_compress(I, N, xform_type)
%% compresses an image based on a transform
% employs N-largest coefficient technique
% I -> input image array
% N -> number of largest coefficients
% xform_type -> type of transform, options are: DCT, DFT
% compressed -> compressed image array 

I_double = im2double(I) ; 
dims = size(I);
block_size = [8 8] ; 

if N > 64
    error('N is too large for 8x8 block, try again ...')
end

is1d = dims(1) == 1 || dims(2) == 1 ; 

% consider zero padding the input block arrays ???
    switch lower(xform_type)
    case 'dft'
        if is1d
            xform_fn = @(block) dct(block) ; 
        else
            xform_fn = @(block) dct2(block) ; 
        end
    case 'dct'
        if is1d
            xform_fn = @(block) fft(block);
        else
            xform_fn = @(block) fft2(block) ; 
        end
    otherwise
        error('invalid xform type ...')
    end

    comp_handle = @(A) n_largest(xform_fn(A), N) ; 

    compressed = nlfilter(I_double, block_size, comp_handle) ; 
    
end


function largest = n_largest(A, N)

    unique_coeffs = unique(A) ; 
    coeffs_sorted = sort(unique_coeffs, 'descend');
    n_larg = coeffs_sorted(1:N) ; 

    mask = zeros(size(A)) ; 
    for coeff = n_larg
        mask = mask | (A==coeff);
    end

    largest = zeros(size(A));
    largest(mask) = A(mask) ; 

end