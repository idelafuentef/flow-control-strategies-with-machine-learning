%%  MLC_LQR_script    parameters script for MLC
%%  Type mlc=MLC2('GP_cylinder') to create corresponding MLC object

%% Parameters of the problem
parameters.size=500;                                         % number of parameters of the pool1
parameters.sensors=10;                                       % number of sensors(Ns)
parameters.controls=1;                                      %number of actuation commands(Nb)=number of polynomials generated
parameters.problem_variables.gamma  = 0.2;                  % Relative weight of cost function
parameters.problem_variables.eval_steps = 4000;             % number of evaluation steps (first for first evaluation, rest for reevaluations
parameters.problem_variables.subeval_steps = 666;
% parameters.evaluation_method='mfile_multi';
parameters.evaluation_method='mfile_multi_parallel';

%% Main
%number of individuals  
parameters.sensor_spec=0;
parameters.sensor_prob=0.33;
parameters.leaf_prob=0.3;
parameters.range=10;
parameters.precision=4;
parameters.opsetrange=[1,2,3,5,6,8,9];            %operations(see MLC_tools/opset.m)
% 1  addition       (+)
% 2  substraction   (-)
% 3  multiplication (*)
% 4  division       (%)
% 5  sinus         (sin)
% 6  cosinus       (cos)
% 7  logarithm     (log)
% 8  exp           (exp)
% 9  tanh          (tanh)
% 10 modulo        (mod)
% 11 power         (pow)
parameters.formal=0;
parameters.end_character='';
parameters.individual_type='tree';


%%  GP algortihm parameters 
parameters.maxdepth=20;                                 %max depth of a tree
parameters.maxdepthfirst=5;                             %initial max depth of a tree
parameters.mindepth=5;                                  %min depth of a tree
parameters.mutmindepth=2;                               %min depth of a tree after mutation
parameters.mutmaxdepth=5;                              %max depth of a tree after mutation
parameters.mutsubtreemindepth=2;                        %max depth of a branch after mutation

parameters.generation_method='mixed_ramped_gauss';
parameters.gaussigma=3;                                 %sigma of the gaussian method(?)
parameters.ramp=[2:8];                                  %ramp of the gaussian method(?)
parameters.maxtries=10;                                 %maximum number of tries
parameters.mutation_types=1:4;                          %types of mutation(up to 4)


%%  Optimization parameters
parameters.elitism=10;                  %number of individuals selected for elitism
parameters.probrep=0.1;
parameters.probmut=0.3;
parameters.probcro=0.6;

parameters.selectionmethod='tournament';
parameters.tournamentsize=parameters.size/100;          %number of individuals selected for the tournament(Np)
parameters.lookforduplicates=1;                         %look for duplicates(T,F)
parameters.simplify=1;                                  %simplify(?)
parameters.cascade=[1 1];


%%  Evaluator parameters
parameters.evaluation_function='Cylinder_problem';      %look for stable system
parameters.indfile='ind.dat';                           %where individual data is stored
parameters.Jfile='J.dat';                               %where cost function data is stored
parameters.exchangedir='../@MLC2/evaluator0';
parameters.evaluate_all=0;                              %evaluate all ind (T,F)
parameters.ev_again_best=1;                             %reevaluate best ind (T,F)
parameters.ev_again_nb=5;                               %number of reevaluated ind
parameters.ev_again_times=4;                            %number of reevaluations
parameters.artificialnoise=0;                           %artificial noise imposed (T,F)

%% Bad value settings
parameters.badvalue=10^36;
% parameters.badvalues_elim='first';
%parameters.badvalues_elim='none';
parameters.badvalues_elim='all';
parameters.preevaluation=0;
parameters.preev_function='';


%% MLC behaviour parameters 
parameters.save=1;                                      %save parameters (T,F)
parameters.saveincomplete=1;                            %save incomplete (T,F)
parameters.verbose=4;                                   %output messages (from 0 to 4)
parameters.fgen=250;                                    %fgen(?)
parameters.show_best=1;                                 %show best(?)
parameters.savedir=fullfile(pwd,'save_GP');             %save directory



