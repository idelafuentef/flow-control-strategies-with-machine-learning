%%  default    parameters script for MLC
%%  Type mlc=MLC2 to create corresponding MLC object
parameters.size=1000;
parameters.sensors=1;
parameters.sensor_spec=0;
parameters.controls=1;
parameters.sensor_prob=0.33;
parameters.leaf_prob=0.3;
parameters.range=10;
parameters.precision=4;
parameters.opsetrange=1:9; 
parameters.formal=1;
parameters.end_character='';
parameters.individual_type='tree';
%%  GP algortihm parameters 
parameters.maxdepth=15;
parameters.maxdepthfirst=5;
parameters.mindepth=2;
parameters.mutmindepth=2;
parameters.mutmaxdepth=15;
parameters.mutsubtreemindepth=2;
parameters.generation_method='mixed_ramped_gauss'; % 50% full 50% random gaussian distrib
% parameters.generation_method='random_maxdepth';
% parameters.generation_method='fullga';
% parameters.generation_method='fixed_maxdepthfirst';
% parameters.generation_method='random_maxdepthfirst';
% parameters.generation_method='full_maxdepthfirst';
% parameters.generation_method='mixed_maxdepthfirst'; %% 50% at full, 50% random, at maxdepthfirst
% parameters.generation_method='mixed_ramped_even';   %% 50% full, 50% random with ramped depth
parameters.gaussigma=3;
parameters.ramp=2:8;
parameters.maxtries=10;
parameters.mutation_types=1:4;
%%  Optimization parameters
parameters.elitism=10;
parameters.probrep=0.1;
parameters.probmut=0.4;
parameters.probcro=0.5;
parameters.selectionmethod='tournament';
parameters.tournamentsize=7;
parameters.lookforduplicates=1;
parameters.simplify=0;
parameters.cascade=[1 1];

%% Evaluation method (select one of them)
% parameters.evaluation_method='test';      %just test, not meaningful
% parameters.evaluation_method='mfile_multi'; %multithread evaluation (need
% verbose=4 probably)
% parameters.evaluation_method='mfile_all';
parameters.evaluation_method='mfile_standalone'; %default

%%  Evaluator parameters 
parameters.evaluation_function='toy_problem';
parameters.indfile='ind.dat';
parameters.Jfile='J.dat';
parameters.exchangedir=fullfile(pwd,'evaluator0');
parameters.evaluate_all=0;
parameters.ev_again_best=0;
parameters.ev_again_nb=5;
parameters.ev_again_times=5;
parameters.artificialnoise=0;
parameters.execute_before_evaluation='';

%% Bad value settings
parameters.badvalue=1e+36;                          
parameters.badvalues_elim='first';                  
% parameters.badvalues_elim='none';
% parameters.badvalues_elim='all';

parameters.preevaluation=0;
parameters.preev_function='';

%% Problem variables (Tf,Tevmax and objective only active in Dyn Sys)
parameters.problem_variables.gamma=0.1;
% parameters.problem_variables.Tf=10;
% parameters.problem_variables.Tevmax=1;
% parameters.problem_variables.objective=0;
%% MLC behaviour parameters 
parameters.save=1;
parameters.saveincomplete=1;
parameters.verbose=2;       
parameters.fgen=250; 
parameters.show_best=1;
parameters.savedir=fullfile(pwd,'save_GP');