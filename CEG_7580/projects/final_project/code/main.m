%% flush buffers, comment out as needed
clc
close('all')

%% add script dependencies to path
scriptFile = mfilename('fullpath') ; 
[scriptPath, ~, ~] = fileparts(scriptFile) ; 

addpath(fullfile(scriptPath, 'fourier')) ; 
addpath(fullfile(scriptPath, 'bookeeping')) ;
addpath(fullfile(scriptPath, 'inputs')) ;
addpath(fullfile(scriptPath, 'filtering')) ;
addpath(fullfile(scriptPath, 'image_handling')) ;

%% set the input parameters and output data bookeeping data structure

% automatically loads the image data based on all image files contained in ../inputs
params = gen_params() ; 
% pass in the number of image datasets 
out = init_out_struct(length(params.filenames)) ; 

%% apply filters and begin processing 

% reference methods for comparison
% the built-in methods apply thinning already 
out = apply_ref_methods(params, out) ; 

% apply the novel methods from the paper
% this also includes the thinning stage 
out = apply_paper_methods(params, out) ; 

%% plot all the results and generate figures
gen_figures(out) ;