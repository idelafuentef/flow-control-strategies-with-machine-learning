clear all; close all; clc;
delete(gcp('nocreate'));
fclose('all');
%add folder and sufbolders to path
addpath(genpath('/home/ifuentef/Downloads/Probe_number_analysis/11probes/OpenMLC_FENICS_Parallel_11probes'));

%delete previous data
delete saved_models/test_strategy*;

%define MLC class
mlc=MLC2('GP_cylinder');

%timed run
tic
mlc.go(20,2);
toc