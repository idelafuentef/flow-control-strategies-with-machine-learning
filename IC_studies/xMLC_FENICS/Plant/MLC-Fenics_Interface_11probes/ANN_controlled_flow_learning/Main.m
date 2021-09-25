clear all; close all; clc;
delete(gcp('nocreate'));
fclose('all');
%add folder and sufbolders to path
addpath(genpath('/home/ifuentef/Documents/flow-control-strategies-with-machine-learning/xMLC_FENICS'));

%delete previous data
delete saved_models/test_strategy*;

%define MLC class
mlc=MLC2('GP_cylinder');

%timed run
tic
mlc.go(15,2);
toc