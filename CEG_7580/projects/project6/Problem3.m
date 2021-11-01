function Problem3(varargin)
    
    
    if nargin >= 1
        filename = varargin{1} ; 
    else
        filename = find_files_from_pattern('0809(a)','*.tif') ;
        filename = filename{1} ; 
    end

    I = imread(filename) ; 
    %I_dbl = im2double(I) ; 

    I_dft8 = transform_compress(I, 8, 'dft') ; 
    I_dft8_int = shift_image_values(I_dft8) ; 
    
    I_dct8 = transform_compress(I, 8, 'dct') ; 
    I_dct8_int = shift_image_values(I_dct8) ; 

    rms_err_dft8 = RMS(I_dft8_int, I) ; 
    snrms_err_dft8 = snrms(I_dft8_int, I) ; 

    rms_err_dct8 = RMS(I_dct8_int, I) ; 
    snrms_err_dct8 = snrms(I_dct8_int, I) ;

    objection_level = 3 ; 
    I_dct_obj = transform_compress(I, objection_level, 'dct') ; 
    I_dct_obj_int = shift_image_values(I_dct_obj) ; 

    rms_err_dct_obj = RMS(I_dct_obj_int, I) ;
    snrrms_err_dct_obj = snrms(I_dct_obj_int, I) ;
    
end
