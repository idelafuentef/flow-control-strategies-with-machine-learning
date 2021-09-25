Initialization
Restart
mlc=gMLC('oscillator'); % /!\ To load a different problem.
% See the plant/oscillator folder for more information on a problem.
mlc.parameters.Name='My_oscillator';

%% Initial parameters
% Number of intial Monte Carlo individuals. In most cases we start with 100
% random individuals thus:
mlc.parameters.basket_init_size = 100; 
% Number of individuals to define the simplex subspace. For the fluidic
% pinball and the cavity experiment we choose the 10 best individuals:
mlc.parameters.basket_size = 10;

%% Strategy
    % Exploitation
% mlc.parameters.exploitation = 'none';
mlc.parameters.WeightedMatrix=1; % Yes for acceleration
    % Exploration
mlc.parameters.exploration = 'none';
    % Evolution
mlc.parameters.evolution = 1;
mlc.parameters.LandscapeType = 'none';
mlc.parameters.NOffsprings= 10;

%% Control law paramaters
mlc.parameters.ControlLaw.InstructionSize.InitMax=50;
mlc.parameters.ControlLaw.InstructionSize.InitMin=1  ;
mlc.parameters.ControlLaw.InstructionSize.Max=50;

%% LGPC parameters
mlc.parameters.PopulationSize = 10;
mlc.parameters.NumberGenerations = 2;

%% Options and go
mlc.parameters.save_data = 0;
% mlc.go(3);
mlc.parameters.number_of_evaluations = 150;
mlc.parameters.criterion = 'number of evaluations';
mlc.mlc2boost;
mlc.show;
% mlc.save;