% INITIALIZATION script
% Loads all the folders needed.
% Should be executed at the beginning of every run
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

% 
%     <program>  Copyright (C) <year>  <Name of author>
%     This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
%     This is free software, and you are welcome to redistribute it
%     under certain conditions; type `show c' for details.

clear;clc;
%% MATLAB random number
    rng('shuffle');
    
%% Add paths
    addpath('gMLC_tools/');
    addpath(genpath('Plant'));
    addpath(genpath('save_runs/'));
    % Additional other tools
    addpath(genpath('Other_tools/'));
    % Clustering
    addpath('Clustering');

    more off;
    
    delete(gcp('nocreate'))
    parpool(60)
%% Initialiase the gMLC class
    mlc=gMLC('cylinder');
