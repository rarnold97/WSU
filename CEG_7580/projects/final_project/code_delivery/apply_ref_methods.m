function res = apply_ref_methods(params, out_struct)

    for i = 1:length(params.I)
        % consider adding more specific parameters to the invocations of edge
        % the most prevalent example would be the threshold parameter

        I = params.I{i} ;         

        tStart = tic ; 
        out_struct.I_canny{i} = edge(I, 'Canny', [0.04, 0.1], 1) ; 
        out_struct.Canny_runtime(i) = toc(tStart) ; 

        out_struct.I_LoG{i} = edge(I, 'log') ; 

        out_struct.I_sobel{i} = edge(I, 'sobel') ; 
    end


    res = out_struct ; 

end 