function gMLC_basket=step_reflect(gMLC_basket,gMLC_table,gMLC_parameters)
% gMLCbasket class step_reflect method
%
% Reflection and evaluation of the individual
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    N_EP = gMLC_parameters.ControlLaw.ControlPointNumber;
    MI = gMLC_parameters.ProblemParameters.OutputNumber;
    N_CP = N_EP*MI;
    WeightedMatrix = gMLC_parameters.WeightedMatrix;
    problem_type = gMLC_parameters.problem_type;

if VERBOSE > 3, fprintf('    o Reflect : \n'),end

%% Compute reflection
    % Best individual
    J1 = gMLC_basket.costs(1);
    % Individual to reflect and centroid
    IDend = gMLC_basket.labels(end);
    Jend = gMLC_basket.costs(end);
    Jend_minus_one = gMLC_basket.costs(end-1);

    if WeightedMatrix
        Indr = gMLCind;
        Indr.basket_labels = gMLC_basket.labels;
        Indr.DS_coeff(gMLC_table,1);
    else
        % Initialization
        reflected = NaN(1,N_CP);
        % Control points
        to_reflect = gMLC_table.ControlPoints(IDend,:);
        centroid = gMLC_basket.centroid;
        % Reflection
        reflected(:) = 2*centroid-to_reflect;

        %% Build the control law
        % Call MLC
        Indr = gMLCind;
        qua = Indr.build_to_fit(reflected,gMLC_table,gMLC_parameters);
        Indr.description.quality = qua;
    end

%% Update individual
    Indr.description.subtype = 'reflected';
    Indr.description.parents = IDend;
    % Add to table
    ID=gMLC_table.add(Indr,gMLC_parameters);
    % To evaluate
    gMLC_basket.status.individuals_to_evaluate = [gMLC_basket.status.individuals_to_evaluate;ID];

%% Evaluation
% External evaluation test
    if strcmp(problem_type,'external')
      if VERBOSE > 2, fprintf('     External evaluation. '),end
      gMLC_basket.waiting_room.labels = [gMLC_basket.waiting_room.labels;ID];
      if VERBOSE > 3, fprintf('Ready.\n'),end
        % Continue the simplex
        gMLC_basket.step_expanse(gMLC_table,gMLC_parameters);
        gMLC_basket.step_single_contraction(gMLC_table,gMLC_parameters);
        % Update
        gMLC_basket.status.last_operation = 'reflect';
      return
    end
% The control law is evaluated here, so no need to put in the individuals_to_evaluate array.
% But if there were to not be evaluated, they need to be added to the array
% (cf external part)
    cycle = gMLC_basket.status.cycle+1;
    Jr = gMLC_table.evaluate(ID,gMLC_parameters,0); % visu
    N_ev = length(gMLC_basket.status.individuals_to_evaluate);
    gMLC_table.individuals(ID).evaluation_order = [cycle,N_ev];

%% Update properties
    % Individuals informations
        gMLC_basket.waiting_room.labels = [gMLC_basket.waiting_room.labels;ID];
        gMLC_basket.waiting_room.costs = [gMLC_basket.waiting_room.costs;Jr];
    % Stat
        gMLC_basket.status.last_operation = 'reflect';

if VERBOSE > 3, fprintf('Done\n'),end

%% Next step
  % TEST
  % gMLC_basket.step_single_contraction(gMLC_table,gMLC_parameters);
%   gMLC_basket.step_shrink(gMLC_table,gMLC_parameters);

 if Jr >= Jend_minus_one
   gMLC_basket.step_single_contraction(gMLC_table,gMLC_parameters);
 elseif Jr<J1
   gMLC_basket.step_expanse(gMLC_table,gMLC_parameters);
 end

end %method
