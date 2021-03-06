function parameters = cylinder_5probes_parameters()
    % cylinder_parameters sets the parameters for the cylinder simulation problem.
	%
	% Guy Y. Cornejo Maceda, 01/24/2020
	%
	% See also MLC.

	% Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
	% CC-BY-SA
    %% Options
	parameters.verbose = 2; 
    
    %% Parallel computing
    parameters.parallel=1;
    parameters.numworkers=60;
    
    %% Sensors
    probetags   = {'Probe_u','Probe_v'};
    timetags    = {'','_1_2','_1_4','_3_4'};
    num_probes  = 5;
    i_aux       = 1;
    for i_tag=1:numel(probetags)
        for i_time=1:numel(timetags)
            for i_probe=1:num_probes
                ProblemParameters.SensorTags{i_aux}=[probetags{i_tag} timetags{i_time} '[' num2str(i_probe-1) ']'];
                i_aux=i_aux+1;
            end
        end
    end
    
    ProblemParameters.operationstring = {'+','-','*','/','sin','cos','log','exp','tanh','mod','^'};
    
    %% Problem parameters
    % Problem
        parameters.Name = 'cylinder_5probes'; % mlc.save_matlab('GenN'); ,mlc.load_matlab('Toy','GenN_moins_un')
        parameters.EvaluationFunction = 'cylinder_5probes'; % external for fortran or experimental
        % Problem variables
        % The inputs and outputs are considered from the controller point
        % of view. Thus ouputs are the controllers (plasma, jets) and
        % inputs are sensors and time dependent functions.
        % Outputs - Number of control laws
        ProblemParameters.OutputNumber = 1; % Number of OutputNumber

    % Inputs - Number of sensors and time dependent functions
        % si(t)
        ProblemParameters.NumberSensors = numel(ProblemParameters.SensorTags);
        for tag_i=1:ProblemParameters.NumberSensors
            ProblemParameters.Sensors{tag_i} = ['a' num2str(tag_i)]; % name in the problem
        end
        % hi(t)
        ProblemParameters.NumberTimeDependentFunctions = 0; % sin(wt)... multifrequency-forcing
        ProblemParameters.TimeDependentFunctions(1,1) = {'u'}; % syntax in MATLAB/Octave
        ProblemParameters.TimeDependentFunctions(2,1) = {'u'}; % syntax in the problem (if null then comment)
        ProblemParameters.InputNumber = ProblemParameters.NumberSensors+ProblemParameters.NumberTimeDependentFunctions; 

    % Control Syntax
        Sensors = cell(1,ProblemParameters.NumberSensors); %*
        TDF = cell(1,ProblemParameters.NumberTimeDependentFunctions); %*
        for p=1:ProblemParameters.NumberSensors,Sensors{p} = ['s(',num2str(p),')'];end %*
        for p=1:ProblemParameters.NumberTimeDependentFunctions,TDF{p} = ['h(',num2str(p),')'];end %*
        ControlSyntax = horzcat(Sensors,TDF); %*
        % Maximum evaluation time otherwise returns an bad value
        ProblemParameters.TmaxEv = 5; % otherwise bad
        % Evaluation
        ProblemParameters.NPointsPeriod = 51; % Number of points per period
        ProblemParameters.NPeriods = 25; % Number of periods
        ProblemParameters.T0 = 0; % Not always used
        ProblemParameters.Tmax = 2*pi*ProblemParameters.NPeriods/1; % omega=1
            time = linspace(ProblemParameters.T0,ProblemParameters.Tmax,...
                ProblemParameters.NPointsPeriod*ProblemParameters.NPeriods+1);
        ProblemParameters.dt = time(2)-time(1);
        ProblemParameters.InitialCondition = [sqrt(0.1) 0 0 0]; % on the limit cycle of the unstable oscillator.
        % Round evaluation of control points and J
        ProblemParameters.RoundEval = 6;
        
        % Actuation limitation : [lower bound,upper bound]
        ProblemParameters.ActuationLimit = [-0.01,0.01];
        % Costs
        ProblemParameters.J0 = 1; % User defined
        ProblemParameters.Jmin = 0;
        ProblemParameters.Jmax = inf;
        % Round evaluation
        ProblemParameters.EstimatePerformance = 'mean'; % default 'mean', if drift 'last', 'worst', 'best'
    
    % Simulation
        ProblemParameters.gamma  = 0.2;                  % Relative weight of cost function
        ProblemParameters.eval_steps = 4000;             % number of evaluation steps (first for first evaluation, rest for reevaluations
        ProblemParameters.subeval_steps = 666;
        
    % Definition
    parameters.ProblemParameters = ProblemParameters; %*

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
    
    %% MLC parameters
    % Population size
    parameters.PopulationSize = 200;
    % Optimization parameters
    parameters.OptiMonteCarlo = 1; % Optimization of the first generation (remove duplicates, redundants..)
    parameters.RemoveBadIndividuals = 1; % Remove indiviuals which evaluation failed
    parameters.RemoveRedundants = 1; % Remove already evaluated individuals
    parameters.CrossGenRemoval = 1; % Remove the individuals if they have already been evaluated in an earlier generation
    parameters.ExploreIC = 1; % Evaluate the initial condition of registers (here:b=0)
    % For remove_duplicates_operators and redundants, maximum number of
    % iterations of the operations when the test is not satisfied.
    parameters.MaxIterations = 10; % better around 100 (-> MaxInterations)
    % Reevaluate individuals (noise and experiment)
    parameters.MultipleEvaluations = 0;
    % Stopping criterion
    parameters.Criterion = 'number of evaluations'; % (not yet)
    % Selection parameters
    parameters.TournamentSize = 7;
    parameters.p_tour = 1;
    % Selection genetic operator parameters
    parameters.Elitism = 1;
    parameters.CrossoverProb = 0.6;
    parameters.MutationProb = 0.3;
    parameters.ReplicationProb = 0.1;
    % Other genetic parameters
    parameters.MutationType = 'at_least_one';
    parameters.MutationRate = 0.05;
    parameters.CrossoverPoints = 1;
    parameters.CrossoverMix = 1;
    parameters.CrossoverOptions = {'gives2'};
    % Other parameters
    parameters.BadValue = 10^36;
    parameters.Pretesting = 0; % (not yet) remove individuals who have no effective instruction

%% Constants
    parameters.PHI = 1.61803398875;

%% Other parameters
    parameters.LastSave = '';
    
end

