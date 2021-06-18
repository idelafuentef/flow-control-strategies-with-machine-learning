clear all; close all; clc;
delete(gcp('nocreate'));
fclose('all');
%add folder and sufbolders to path
addpath(genpath('/home/ifuentef/Downloads/Probe_number_analysis/OpenMLC_FENICS_Parallel_5probes'));

%delete previous data
delete saved_models/test_strategy*;
% delete *sh;

%define MLC class
mlc=MLC2('GP_cylinder');

%timed run
tic
mlc.go(25,2);
toc