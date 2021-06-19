clear all; close all; clc;
delete(gcp('nocreate'));
fclose('all');
%add folder and sufbolders to path
addpath(genpath('/home/ifuentef/Documents/flow-control-strategies-with-machine-learning/OpenMLC_FENICS'));

%delete previous data
delete saved_models/*csv;
delete best_model/*csv;
delete input*sh;


%define MLC class
mlc=MLC2('GP_cylinder');

%timed run
tic
mlc.go(25,2);
toc