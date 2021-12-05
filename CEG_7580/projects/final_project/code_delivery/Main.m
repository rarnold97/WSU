%% flush buffers, comment out as needed
clc
close('all')

%% add script dependencies to path

%scriptFile = mfilename('fullpath') ; 
%[scriptPath, ~, ~] = fileparts(scriptFile) ; 

%addpath(fullfile(scriptPath, 'fourier')) ; 
%addpath(fullfile(scriptPath, 'bookeeping')) ;
%addpath(fullfile(scriptPath, 'inputs')) ;
%addpath(fullfile(scriptPath, 'filtering')) ;
%addpath(fullfile(scriptPath, 'image_handling')) ;

% with addpath, we can be sure that Lenna and the fish are discoverable 

%% set the input parameters and output data bookeeping data structure

% automatically loads the image data based on all image files contained in ../inputs
params = gen_params() ; 

% set the proportionality constant of thresholding and method type
params.alpha = 0.04 ; 
params.method = 4 ; 
%params.method = 5 ; 

% lenna and the fish are used in a lot of the intermediate figures 
lenna = find_files_from_pattern('Lenna','*.tif') ;
params.lenna = imread(lenna{1}) ; 

fish = find_files_from_pattern('fish_test', '*.tif') ; 
params.fish = rgb2gray(imread(fish{1})) ;

% pass in the number of image datasets 
out = init_out_struct(length(params.filenames)) ; 

%% apply filters and begin processing 

% reference methods for comparison
% the built-in methods apply thinning already 
out = apply_ref_methods(params, out) ; 

% apply the novel methods from the paper
% this also includes the thinning stage 
out = apply_paper_methods(params, out) ; 

% generate all the intermediate figures examining the effects of the parameters
out = gen_inter_data(params, out) ; 

%% plot all the results and generate figures
gen_figures(out, params) ;