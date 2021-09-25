%--------------------------------------------------------------------------
%-------------- Experimental Aerodynamics and Propulsion Lab --------------
%-------------------- Aerospace Engineering Group -------------------------
%------------------- Universidad Carlos III de Madrid ---------------------
%--------------------------------------------------------------------------
% Authors: I. de la Fuente, R. Castellanos
%
% Description: Main file to define the case to be evaluated by MLC. It
% contains the description of the MLC parameters to generate the genetic
% operations, the parameters regarding the CFD simulation of the 2D
% cylinder, and some extra parameters from the user.
%
% Important: run mlc=MLC2('GP_cylinder') to create corresponding MLC object
%--------------------------------------------------------------------------

%% Parameters of the problem
parameters.size                             = 100;  % number of parameters of the pool (individuals)
parameters.controls                         = 1;    % number of actuation commands (Nb) = number of polynomials generated
parameters.problem_variables.gamma          = 0.2;  % Relative weight of cost function (used to penalize CL)
parameters.problem_variables.eval_steps     = 4000; % number of evaluation steps (first for first evaluation, rest for reevaluations
parameters.problem_variables.subeval_steps  = 666;  % subinterval in which we evaluate CL and CD (1 shedding cycle = 666 time steps)
parameters.problem_variables.scaling        = 0.01; % scaling factor for the actuation

parameters.problem_variables.parallelworkers= 60;   % parpool workers
parameters.problem_variables.parallel       = 1;    % parallel or serial running (1=parallel, 0=serial)     


if parameters.problem_variables.parallel==1
    delete(gcp('nocreate'));
    parpool(parameters.problem_variables.parallelworkers);
    parameters.evaluation_method            = 'mfile_multi_parallel';% @MLCpop/Evaluate.m -> check options.
else
    parameters.evaluation_method            = 'mfile_multi';% @MLCpop/Evaluate.m -> check options.
end

%% Genetic Programming Parameters 
parameters.sensor_spec      = 0;    % ??? [RODRI]
parameters.sensor_prob      = 0.33; % Probability for a sensor to appear
parameters.leaf_prob        = 0.3;  % Probability og generating a new leaf
parameters.range            = 10;   % ??? [RODRI]
parameters.precision        = 4;    % number of digits???? [RODRI]
parameters.formal           = 0;    % formato (leasp o formato maquina) ENTENDER bien??? [RODRI]
parameters.end_character    = '';   % coletilla ?? [RODRI]
parameters.individual_type  = 'tree'; % understand possibilities?? [RODRI]
parameters.opsetrange       = [1,2,3,5,6,8,9]; % operations(see MLC_tools/opset.m)
parameters.problem_variables.operationstring = {'+','-','*','/','sin',...
    'cos','log','exp','tanh','mod','^'};
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
            
probetags   = {'Probe_u','Probe_v'};
timetags    = {'','_1_2','_1_4','_3_4'};
num_probes  = 5;
i_aux       = 1;
for i_tag=1:numel(probetags)
    for i_time=1:numel(timetags)
        for i_probe=1:num_probes
            parameters.problem_variables.sensors{i_aux}=[probetags{i_tag} timetags{i_time} '[' num2str(i_probe-1) ']'];
            i_aux=i_aux+1;
        end
    end
end
parameters.sensors              = size(parameters.problem_variables.sensors,2);   % number of sensors (Ns)

%%  GP algortihm parameters 
parameters.maxdepth             = 4; % max depth of a tree
parameters.maxdepthfirst        = 4; % initial max depth of a tree
parameters.mindepth             = 1; % min depth of a tree
parameters.mutmindepth          = 2; % min depth of a tree after mutation
parameters.mutmaxdepth          = 4; % max depth of a tree after mutation
parameters.mutsubtreemindepth   = 2; % max depth of a branch after mutation


parameters.generation_method    = 'mixed_ramped_gauss'; % [RODRI]: hay varios pero no sabemos... [LHS??]
parameters.gaussigma            = 3;     % sigma of the gaussian method(?)
parameters.ramp                 = 2:8;   % ramp of the gaussian method(?)
parameters.maxtries             = 10;    % maximum number of tries
parameters.mutation_types       = 1:4;   % types of mutation(up to 4) Rodri: qué tipos de mutación son???


%%  Optimization parameters
parameters.elitism              = 1;  % number of individuals selected for elitism
parameters.probrep              = 0.1; % probability of repetition
parameters.probmut              = 0.3; % probability of mutation
parameters.probcro              = 0.6; % probability of crossover

parameters.selectionmethod      = 'tournament';  % [RODRI]: do we have more options?
parameters.tournamentsize       = 7;  %number of individuals selected for the tournament(Np) [cogemos los Np primeros individuos y generamos nuevas cosas]
parameters.lookforduplicates    = 1;     % Look for duplicates(T,F) [same mathematical expression]
parameters.simplify             = 1;     % Simplify [solves those operations that can directly be applied]
parameters.cascade              = [1 1]; % [RODRI]: ni puta idea


%%  Evaluator parameters
parameters.evaluation_function  = 'Cylinder_problem';   % File in which we refine the problem to solve
parameters.indfile              = 'ind.dat';            % File in which individual data is stored
parameters.Jfile                = 'J.dat';              % File in which cost function data is stored
parameters.exchangedir          = '../@MLC2/evaluator0';
parameters.evaluate_all         = 0;                    % Evaluate all ind (T,F)
parameters.ev_again_best        = 1;                    % Reevaluate best ind (T,F)
parameters.ev_again_nb          = 1;                    % Number of reevaluated ind
parameters.ev_again_times       = 4;                    % Number of reevaluations
parameters.artificialnoise      = 0;                    % Artificial noise imposed (T,F) [RODRI]: ver como mete el ruido, Gaussino?

%% Bad value settings
parameters.badvalue             = 10^36; % J value to apply when Fenics fail!
parameters.badvalues_elim       = 'all'; %'first' (Eliminate only in first generation), 'none' (Do not eliminate), 'all' (eliminate in all generations)
parameters.preevaluation        = 0;     % [RODRI] Apply a pre-evaluation function; 
parameters.preev_function       = '';    % [RODRI] maybe we can define a preevaluation function


%% MLC behaviour parameters 
parameters.save                 = 1;    % save parameters (T,F)
parameters.saveincomplete       = 1;    % save incomplete (T,F)
parameters.verbose              = 4;    % verbosity: output messages (from 0 to 4)
parameters.fgen                 = 250;  % [RODRI] fgen(?)
parameters.show_best            = 1;    % [RODRI] show best(?)
parameters.savedir              = fullfile(pwd,'save_GP');  % save directory


