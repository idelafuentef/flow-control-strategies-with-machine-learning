Restart
mlc.parameters.Name='My_tanh_parallel_test_1';


%% Initialization
% Number of intial Monte Carlo individuals. In most cases we start with 100
% random individuals thus:
mlc.parameters.basket_init_size = 100; 
% Number of individuals to define the simplex subspace. For the fluidic
% pinball and the cavity experiment we choose the 10 best individuals:
mlc.parameters.basket_size = 10;

% Parallel resolution of the secondary regression problem
mlc.parameters.ExternalReconstruction = 1; % PARALLEL
VERBOSE = mlc.parameters.verbose; % PARALLEL


%% Strategy
mlc.parameters.evolution = 1;
mlc.parameters.LandscapeType = 'none';
mlc.parameters.NOffsprings= 10;
mlc.parameters.exploitation = 'Downhill Simplex';
mlc.parameters.WeightedMatrix=1;
mlc.parameters.exploration = 'none';

%% Control law paramaters
mlc.parameters.ControlLaw.InstructionSize.InitMax=20;
mlc.parameters.ControlLaw.InstructionSize.InitMin=1; 
mlc.parameters.ControlLaw.InstructionSize.Max=20;

%% LGPC parameters
mlc.parameters.PopulationSize = 10;
mlc.parameters.NumberGenerations = 2;

%% Options
mlc.parameters.save_data = 0;
mlc.parameters.criterion = 'number of evaluations';
mlc.parameters.number_of_evaluations = 150;

%% Parallel Process
% Start
    if VERBOSE > 0, fprintf('MLC3 is empty, lets initialize\n'),end
    if VERBOSE > 0, fprintf('\n'),end
    mlc.step_initialization;

% Initialization test
    if mlc.history.cycle(1)<0
      mlc.history.cycle(2) = mlc.history.cycle(1)+1;
      fprintf('Lets evaluate the first set!\n')
      return
    end

while not(mlc.criterion)
% Pre-Evolution   
% Build evolution basket
    mlc.build_evolution_basket;
    mlc.save;
    disp('Saved before seconday problem')
    % Substitution
    % ---------- Compute Substitute ----------
%         InterpolationProcess;
        tic
        fprintf('Compute the substitutes:\n')
        parfor p=1:(mlc.parameters.NOffsprings+mlc.parameters.basket_size)
            mlc.interpolate_simplex(p);
        end
        toc
    mlc.save;
    disp('Saved after seconday problem')
    % ---------- Compute Substitute ----------
    % Evolution
    mlc.complete_interpolation_EXE; % with complete_interpolation_EXE
    mlc.history.cycle(2) = mlc.history.cycle(1)+1; % NEEDED ?
    mlc.new_cycle(1);
    % Evolve
    mlc.basket.status.last_operation = 'Subtitute computed'; % no need top interpolate in this phase
    mlc.step_evolution
    
% Exploration step : Downhill simplex 
    NDSIndividuals = mlc.table.number + mlc.parameters.NOffsprings;
    while mlc.table.number<NDSIndividuals
    mlc.new_cycle(1)
    mlc.step_exploitation;
    mlc.step_end;
    mlc.new_cycle(2);
    end

end

% Show
mlc.show_status;
mlc.show(0);

%% Save
mlc.save;
mlc.plot_progress;

% --- END Modifications

%% To see the learning process and best individuals
%mlc.plot_progress;
%mlc.show; % best individual
%mlc.best_individuals % 5 best indviduals

%% end command window output logging
diary off