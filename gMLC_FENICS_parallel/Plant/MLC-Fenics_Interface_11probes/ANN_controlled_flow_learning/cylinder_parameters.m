function parameters = cylinder_parameters()

    % cylinder_parameters sets the parameters for the cylinder simulation problem.
	%
	% Guy Y. Cornejo Maceda, 01/24/2020
	%
	% See also MLC.

	% Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
	% CC-BY-SA
    %% Options and problem
      parameters.Name = 'cylinder';
      parameters.dummy = 0; % doesn't work yet
      parameters.verbose = 5;
      parameters.save_data = 0;
      parameters.number_of_evaluations = 15; % stopping criterion
      % Problem
      parameters.problem = 'cylinder';
      parameters.problem_type = 'internal'; % 'external'
      parameters.external_interpolation = 0;% Compute the secondary MLC problem outside the original session

    
    %% Parallel computing
    parameters.parallel=1;
    parameters.numworkers=60;
    
    %% gMLC parameters
      parameters.basket_init_size = 100;
      parameters.basket_size = 100;
      parameters.stock_size = 10^(3);
      % parameters.criterion = 'find better than';
      parameters.criterion = 'number of cycles';
      % other parameters
      parameters.BadValue = 10^36;
      parameters.BadValue_plot = 10^3;
      parameters.ratio_import = 0; % half of the individuals are imported
      % types of steps
          % initialization
          parameters.initialization = 'Monte Carlo'; % Downhill Simplex(not coded yet)
          parameters.InitializationClustering = 0; %
          % exploitation
      parameters.exploitation = 'Downhill Simplex';
      parameters.WeightedMatrix = 0; % 0:GPC interpolation, 1:coefficient interpolation
          % exploration
      parameters.exploration = 'none'; % LHS (Latin Hypercube Sampling)(not coded yet), Random
      parameters.exploration_parameters = 10; % Number of new indivduals to explore
          % evolution
      parameters.evolution = 0;
      parameters.NOffsprings = 10;
          % landscape description
      parameters.LandscapeType = 'CostSection'; % 'CostSection','ClusteringDistance', 'ClusteringCorrelation', 'none'
      % individuals tests
      parameters.duplicate_test = 1; % TO BE DONE
      parameters.other_test = 0;
      % centroid
      parameters.to_build = [];
      parameters.explore_centroid = 0; % should never been used
      % explore the initial condition
      parameters.explo_IC=1;
      
    %% Problem parameters
        % Problem variables
        % The inputs and outputs are considered from the controller point
        % of view. Thus ouputs are the controllers (plasma, jets) and
        % inputs are sensors and time dependent functions.
        % Outputs - Number of control laws
        
      % Inputs - Number of sensors and time dependent functions
            % si(t)
            ProblemParameters.NumberSensors = 22;
            ProblemParameters.Sensors = {'a0','a1','a2','a3','a4','a5','a6','a7','a8','a9','a10',...
                'a11','a12','a13','a14','a15','a16','a17','a18','a19','a20','a21'}; % name in the problem
          % hi(t)
            ProblemParameters.NumberTimeDependentFunctions = 0; % sin(wt)... multifrequency-forcing
            ProblemParameters.TimeDependentFunctions(1,1) = {'u'}; % syntax in MATLAB/Octave
            ProblemParameters.TimeDependentFunctions(2,1) = {'u'}; % syntax in the problem (if null then comment)
        ProblemParameters.InputNumber = ProblemParameters.NumberSensors+ProblemParameters.NumberTimeDependentFunctions; 

      % Outputs
        ProblemParameters.OutputNumber = 1; % Number outputs
        ProblemParameters.UnsteadyOutputs = 1;
        ProblemParameters.SteadyOutputs  = 0; % T=0 in the evaluation of the controller
          if ProblemParameters.UnsteadyOutputs+ProblemParameters.SteadyOutputs~=ProblemParameters.OutputNumber
            error('Number of outputs is not well defined')
          end
      
      % Control Syntax
        Sensors = cell(1,ProblemParameters.NumberSensors); %*
        TDF = cell(1,ProblemParameters.NumberTimeDependentFunctions); %*
        for p=1:ProblemParameters.NumberSensors,Sensors{p} = ['s(',num2str(p),')'];end %*
        for p=1:ProblemParameters.NumberTimeDependentFunctions,TDF{p} = ['h(',num2str(p),')'];end %*
        ControlSyntax = horzcat(Sensors,TDF); %*
        
      % other parameters
      ProblemParameters.fortran_evaluation = 0;
      ProblemParameters.T0 = -2; % Care control points
      ProblemParameters.Tmax = 2;
      ProblemParameters.dt = 1e-4;
      ProblemParameters.TmaxEv = 5;
  		% number of initial conditions
  		ProblemParameters.InitialCondition = 1;
  		
      % actuation limitation -[lower bound,upper bound]
      ProblemParameters.ActuationLimit = [-0.01,0.01];
      % Costs
        ProblemParameters.J0 = 1; % User defined
        ProblemParameters.Jmin = 0;
        ProblemParameters.Jmax = inf;
      % round evaluation of control points and J (?)
      ProblemParameters.RoundEval = 6;
      % Estimate performance
      ProblemParameters.EstimatePerformance = 'mean'; % default 'mean', if drift 'last', 'worst', 'best'
      ProblemParameters.PathExt = '../../../Pinball_MLC_OUTPUT/Costs'; % Pinball
      
      % Simulation
        ProblemParameters.gamma  = 0.2;                  % Relative weight of cost function
        ProblemParameters.eval_steps = 4000;             % number of evaluation steps (first for first evaluation, rest for reevaluations
        ProblemParameters.subeval_steps = 666;
        
      % Definition
      parameters.ProblemParameters = ProblemParameters;
    

%% Control law parameters
        % Number of instructions
        ControlLaw.InstructionSize.InitMax=20;
        ControlLaw.InstructionSize.InitMin=1;
        ControlLaw.InstructionSize.Max=20;
        % Operators
        ControlLaw.OperatorIndices = [1,2,3,5,6,9];
            %   implemented:     - 1  addition       (+)
            %                    - 2  substraction   (-)
            %                    - 3  multiplication (*)
            %                    - 4  division       (%)
            %                    - 5  sinus         (sin)
            %                    - 6  cosinus       (cos)
            %                    - 7  logarithm     (log)
            %                    - 8  exp           (exp)
            %                    - 9  tanh          (tanh)
            %                    - 10 square        (.^2)
            %                    - 11 modulo        (mod)
            %                    - 12 power         (pow)
            %
        ControlLaw.Precision = 6; % Precision of the evaluation of the control law % to change also in my_div and my_log
        
        % Registers
        % Number of variable registers
            VarRegNumberMinimum = ProblemParameters.OutputNumber+ProblemParameters.InputNumber; %*
            ControlLaw.VarRegNumber = VarRegNumberMinimum + 3; % add some memory slots if needed  
            % Number of constant registers
            ControlLaw.CstRegNumber = 4;
            ControlLaw.CstRange = [repmat([-1,1],ControlLaw.CstRegNumber,1)]; % Range of values of the random constants
            % Total number of registers
            ControlLaw.RegNumber = ControlLaw.VarRegNumber + ControlLaw.CstRegNumber;  %* % variable registers and constante registers (operands)
            
            % Register initialization
                NVR = ControlLaw.VarRegNumber; %*
                RN = ControlLaw.RegNumber; %*
                r{RN}='0'; %*
                r(:) = {'0'}; %*
                % Variable registers
                for p=1:ProblemParameters.InputNumber %*
                    r{p+ProblemParameters.OutputNumber} = ControlSyntax{p}; %*
                end
                % Constant registers
                minC = min(ControlLaw.CstRange,[],2); %*
                maxC = max(ControlLaw.CstRange,[],2); %*
                dC = maxC-minC; %*
                for p=NVR+1:RN %*
                    r{p} = num2str(dC(p-NVR)*rand+minC(p-NVR)); %*
                end %*
            ControlLaw.Registers = r; %*
        % Control law estimation
        ControlLaw.ControlPointNumber = 1000; %1000?
        ControlLaw.SensorRange = [repmat([-2 2],ProblemParameters.NumberSensors,1)]; % Range for sensors
            Nbpts = ControlLaw.ControlPointNumber; %*
            Rmin = min(ControlLaw.SensorRange,[],2); %*
            Rmax = max(ControlLaw.SensorRange,[],2); %*
            dR = Rmax-Rmin; %*
        ControlLaw.EvalTimeSample = rand(1,Nbpts)*ProblemParameters.Tmax; %*
        ControlLaw.ControlPoints = rand(ProblemParameters.NumberSensors,Nbpts).*dR+Rmin; %*
    % Definition
    parameters.ControlLaw = ControlLaw; %*
    
    %% LGPC parameters
  		parameters.PopulationSize = 100;
  		parameters.NumberGenerations = 2;
  		parameters.EvaluationFunction = parameters.problem;
  		% optimization parameters
  		parameters.OptiMonteCarlo = 1; %optimization of the first generation (remove duplicates, redundants..)
  		parameters.RemoveBadIndividuals = 1;
  		parameters.RemoveRedundants = 1; % create always new individuals compared to (CrossGenRemoval=0) the last generation, (CrossGenRemoval=1) the whole data base
  		parameters.CrossGenRemoval = 1;
  		parameters.ExploreIC = 0; % For gMLC, should be 0
  		parameters.MaxIterations = 100; % for remove_duplicates_operators and redundants, max number of iterations of the operations when we don't satisfy the test.
  		% multiple evaluations
  		parameters.MultipleEvaluations = 0;
  		% Selection parameters
  		parameters.TournamentSize = 7;
  		parameters.p_tour = 1;
  		% Selection genetic operator parameters
  		parameters.Elitism = 1;
        parameters.CrossoverProb = 0.6;
        parameters.MutationProb = 0.3;
        parameters.ReplicationProb = 0.1;
%         parameters.GeneticProbabilities = [0.60,0.30];
  		% Other genetic parameters
  		parameters.MutationType = 'at_least_one';
  		parameters.MutationRate = 0.05;
  		parameters.CrossoverPoints = 1;
  		parameters.CrossoverMix = 1;
  		parameters.CrossoverOptions = {'gives2'};
        % Other parameters
  		parameters.Pretesting = 0; %remove individuals who have no effective instruction or other tests

  	%% Constants
  		parameters.PHI = 1.61803398875;

  	%% Other parameters
  		parameters.LastSave = '';
    
end

