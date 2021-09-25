%--------------------------------------------------------------------------
%-------------- Experimental Aerodynamics and Propulsion Lab --------------
%-------------------- Aerospace Engineering Group -------------------------
%------------------- Universidad Carlos III de Madrid ---------------------
%--------------------------------------------------------------------------
% Authors: I. de la Fuente, R. Castellanos
%
% Description: Definition of the optimization problem for 2D cylinder wake
%
% Inputs:
%   - Individual id (number)
%   - MLC parameters
%   - Counter
%   - fig?
% Outputs:
%   - Cost function
%   - System output
%--------------------------------------------------------------------------


function J_out=cylinder_11probes_problem(Arrayb,parameters,visu,ind)
    % cylinder flow stabilization
    % The function cylinder_problem computes the cost of the actuation b for the
    % jets located on the upper and lower sides of the cylinder
    % The input is the string expression of the control law in a cell.
    % Examples : Arrayb = {'0'};
    %            Arrayb = {'cos(10*t)'};
    %            Arrayb = {'a1^2'};
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also read, mat2lisp, simplify_my_LISP.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA
    
    %% Parameters
    ActuationLimit = parameters.ProblemParameters.ActuationLimit(2);
    gamma = parameters.ProblemParameters.gamma; %penalization coefficient
    
    %number of evaluation steps ()
    eval_steps=parameters.ProblemParameters.eval_steps;
    subeval_steps=parameters.ProblemParameters.subeval_steps;
    
%     %% Control law synthesis
%     % bound the actuation
%     BoundArrayb = limit_to(Arrayb,ActuationLimit); 
%     % control law
%     % The i-th control law is the i-th element of Arrayb.
%     bx=BoundArrayb{1};
%     eval(['b = @(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)(' bx ');']);
    
    
    %% Interpret individual    
    
    jet=Arrayb{1};
    sensors = parameters.ProblemParameters.SensorTags;
    for s = numel(sensors):-1:1
        jet = strrep(jet,['a' num2str(s)],sensors{s}); % replace S# with the corresponding sensor
    end
    jet   = strrep(jet,' ','');   % Eliminate spaces
    jet   = strrep(jet,'.*','*'); % Eliminate . in operations (avoid python cracks)

    %-Define jets based on equation: custom scaling of 0.01 is applied.
    jet = [num2str(ActuationLimit) '*(' jet ')'];    
    jet=strrep(jet,' ','');
    jet=strrep(jet,'.*','*');    
    
    fprintf('\n')
    fprintf('(%i) Simulating ...\n',ind)
    
    try
        %- Check if any sensor is included
        if contains(jet,'Probe')==0, disp('No sensors included'); error('No sensors included'); end

        %- Substitute functions by their python name
        operations = parameters.ProblemParameters.operationstring;
        for o = 5:numel(operations)
            switch operations{o}
                case {'cos','sin','log','exp','tanh','mod'}
                jet = strrep(jet,operations{o},['np.' operations{o}]);
                case '^'
                jet = strrep(jet,operations{o},'**');
                otherwise 
                error('No operation defined'); 
            end
        end
        
        %- Write batch script
        jet1 = jet; jet2 = ['-' jet];
        fileID       = fopen(['./bashfiles/input' num2str(ind) '.sh'],'w');
        python_input=['python3 perform_learning.py' ' "' jet1 '"' ' "' jet2 '" ' num2str(eval_steps) ' ' num2str(ind) ];
        python_input=strcat(python_input,' > NUL');
        fprintf(fileID,python_input);
        fclose(fileID);
        
        %- Give execution perimissio-ns
        system('./permission.sh');
        %- Execute batch script
        system(['./bashfiles/input' num2str(ind) '.sh']);
        
        
        fprintf('(%i) Simulation finished.\n',ind);
        crashed=0;
    catch err
        crashed=1;
        fprintf('(%i) Simulation crashed.\n',ind)
    end
    
    
    if crashed==1
        J=parameters.BadValue;
    else
        try
            %retrieve resulting data from csv file
            output=table2cell(readtable(['saved_models/test_strategy' num2str(ind) '.csv']));
            
            %compute C_D and C_L based on final region and factorize
            C_D=mean(cell2mat(output(end-subeval_steps:end,3)))*(-20);
            C_L=mean(cell2mat(output(end-subeval_steps:end,4))*(20));
            
            %compute J, based on Rabault reward function (3.18 = 0.159*20)
            J=1+(C_D-3.18)+gamma*abs(C_L);  %3.18 is a proxy value, corresponding to CD when there is no control
           
            fprintf('(%i) C_D = %f\n',ind,C_D)
            fprintf('(%i) C_L = %f\n',ind,C_L)
            fprintf('(%i) J   = %f\n',ind,J)
            %Print python input
            fprintf(['(%i) jet = ' jet1 '\n'],ind);
        catch err
            crashed=1;
            J=parameters.BadValue;  
            fprintf('(%i) Not able to read csv\n',ind)
        end
    end
    
    J_out={J};
end