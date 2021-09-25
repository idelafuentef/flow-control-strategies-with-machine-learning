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

function [J,sys]=Cylinder_problem(ind,gen_param,i,fig)
    
    verb=gen_param.verbose;
    gamma_J=gen_param.problem_variables.gamma;                  %Relative weight of lift coefficient with respect to drag


%% Interpret individual
%- Evaluation steps (from GP_cylinder)
eval_steps      = gen_param.problem_variables.eval_steps;
subeval_steps   = gen_param.problem_variables.subeval_steps;

%- From LISP format to str
m               = simplify_my_LISP(ind.value);
m               = readmylisp_to_formal_MLC(m);

%- Apply the sensor name
sensors = gen_param.problem_variables.sensors;
for s = numel(sensors)-1:-1:0
    m = strrep(m,['S' num2str(s)],sensors{s+1}); % replace S# with the corresponding sensor
end
m   = strrep(m,' ','');   % Eliminate spaces
m   = strrep(m,'.*','*'); % Eliminate . in operations (avoid python cracks)

%-Define jets based on equation: custom scaling of 0.01 is applied.
jet = [num2str(gen_param.problem_variables.scaling) '*(' m ')'];
  
    
%% Simulation
%- Notify user about the simulation under evaluation
if verb, fprintf('(%i) Simulating ...\n',i); end
    
try
%     %- Impose the tentative values for sensors [RODRI: provide or check for reasonable values]
%     sensorvalue = [ones(1,4)*0.01 70 ones(1,4)*0.06 70];
%     for s = 1:numel(sensors), eval([sensors{s} '=' num2str(sensorvalue(s)) ';']); end    
%     %- Check if the jet value is valid for Fenics
%     if abs(eval(jet))>0.01, disp('Over the limits'); error('Over the limits'); end
    %- Check if any sensor is included, RODRIGO, ahora esta codeado con C, si usas otra cosa que?
    if contains(jet,'C')==0, disp('No sensors included'); error('No sensors included'); end
    
    %- Substitute functions by their python name
    operations = gen_param.problem_variables.operationstring;
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
    fileID       = fopen(['./bashfiles/input' num2str(i) '.sh'],'w');
    python_input = ['python3 ./perform_learning.py' ' "' jet1 '"' ' "' jet2 '" ' num2str(eval_steps) ' ' num2str(i) ];
    python_input = strcat(python_input,' > NUL');
    fprintf(fileID,python_input);
    fclose(fileID);
    
    %- Give execution perimissio-ns
    system('./permission.sh');
    %- Execute batch script
    system(['./bashfiles/input' num2str(i) '.sh']);
    
    %- Check warning: if Failure -> crashed case
    if strncmp(lastwarn,'Failure',7)
        warning('reset'); sys.crashed=1;
    else
        sys.crashed=0;
    end
    %- Notify the user:
    if verb; fprintf('(%i) Simulation finished.\n',i); end

catch % When simulation crashes:
    sys = []; sys.crashed=1;
    if verb; fprintf('(%i) Simulation crashed.\n',i); end
end

%% Assign values to the crashed cases
if sys.crashed == 1
    J = gen_param.badvalue;
    if verb>1; fprintf('(%i) Bad fitness: sim crashed\n',i); end
else
    try % por si ha fallado durante la simulación de Fenics
        %retrieve resulting data from csv file
        output=table2cell(readtable(['saved_models/test_strategy' num2str(i) '.csv']));
        
        %compute C_D and C_L based on final region and factorize
        C_D=mean(cell2mat(output(end-subeval_steps:end,3)))*(-20);
        C_L=mean(cell2mat(output(end-subeval_steps:end,4))*(20));
        
        %compute J, based on Rabault reward function (3.18 = 0.159*20)
        J=1+(C_D-3.18)+gamma_J*abs(C_L);  %3.18 is a proxy value, corresponding to CD when there is no control
        if verb==4
            fprintf(['(%i) C_D = ' num2str(C_D) '\n'],i)
            fprintf(['(%i) C_L = ' num2str(C_L) '\n'],i)
            fprintf(['(%i) J = ' num2str(J) '\n'],i)
        end
        %Print python input
        fprintf(['(%i) jet = ' jet '\n'],i);
    catch
        sys=[]; sys.crashed=1;
        J=gen_param.badvalue;
        fprintf('(%i) Not able to read csv\n',i)
    end
end
end