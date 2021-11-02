function Problem3(varargin)
    
    
    if nargin >= 1
        filename = varargin{1} ; 
    else
        filename = find_files_from_pattern('0809(a)','*.tif') ;
        filename = filename{1} ; 
    end

    I = imread(filename) ; 
    I_dbl = im2double(I) ; 

    I_dft8 = transform_compress(I, 8, 'dft') ; 
    I_dft8_int = shift_image_values(I_dft8) ; 
    
    I_dct8 = transform_compress(I, 8, 'dct') ; 
    I_dct8_int = shift_image_values(I_dct8) ; 

    rms_err_dft8 = RMS(I_dbl, I_dft8) ; 
    snrms_err_dft8 = snrms(I_dbl, I_dft8) ; 

    rms_err_dct8 = RMS(I_dbl, I_dct8) ; 
    snrms_err_dct8 = snrms(I_dbl, I_dct8) ;

    objection_level = 1 ; 
    I_dct_obj = transform_compress(I, objection_level, 'dct') ; 
    I_dct_obj_int = shift_image_values(I_dct_obj) ; 

    rms_err_dct_obj = RMS(I_dbl, I_dct_obj) ;
    snrms_err_dct_obj = snrms(I_dbl, I_dct_obj) ;
    
    fig = figure() ; 
    set(0, 'CurrentFigure', fig) ; 

    subplot(1,3, 1)
    imshow(I_dft8_int)
    title('DFT 8x8 block')

    subplot(1,3, 2)
    imshow(I_dct8_int)
    title('DCT 8x8 block')

    subplot(1,3, 3)
    imshow(I_dct_obj_int)
    title(['Objectionable Image N = ', num2str(objection_level)])
    
    msgRms = ['rms error with DFT 8 Largest: ', num2str(rms_err_dft8), newline ...
        'rms error with DCT 8 Largest: ', num2str(rms_err_dct8), newline ...
        'rms error with DCT ',num2str(objection_level),': ' , num2str(rms_err_dct_obj)] ;
    
    msgSnrms = ['SNRms error with DFT 8 Largest: ', num2str(snrms_err_dft8), newline ...
        'SNRms error with DCT 8 Largest: ', num2str(snrms_err_dct8), newline ...
        'SNRms error with DCT ', num2str(objection_level), ': ', num2str(snrms_err_dct_obj)] ; 

    msg =[msgRms, newline, newline, msgSnrms] ; 
    msgbox(msg)
      
end
