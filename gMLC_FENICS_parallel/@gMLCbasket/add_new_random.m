function gMLC_basket=add_new_random(gMLC_basket,gMLC_table,gMLC_parameters)
% gMLCbasket class add_new_random method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    N_ope = gMLC_parameters.MaxIterations;
    explo_param = gMLC_parameters.exploration_parameters; % Number of new indivduals to explore

if VERBOSE > 2, fprintf('     Add new random individual(s) - Start\n'),end

%% Create a new individual
  % Initialization
    IDs = zeros(explo_param,1);
  % Loop
    for p=1:explo_param(1)
      is_ok = false;
        compt = 0;
        while not(is_ok) && (compt<N_ope) % Test
          Ind = gMLCind;
          Ind.generate(gMLC_parameters);
          Ind.description.type = 'Random';

          % is_ok1 = stock_test(Ind,gMLC_parameters);
          is_ok2 = Ind.duplicate_test(gMLC_table,gMLC_parameters);
          is_ok3 = Ind.other_test(gMLC_parameters);
          is_ok = is_ok2 && is_ok3;%is_ok1 && is_ok2 && is_ok3;
          compt = compt+1;
        end
        IDs(p)=gMLC_table.add(Ind,gMLC_parameters);
    end
    % To evaluate
      gMLC_basket.status.individuals_to_evaluate = [gMLC_basket.status.individuals_to_evaluate;IDs];
%% Evaluation
    % The control law is evaluated here, so no need to put in the individuals_to_evaluate array.
    % But if there were to not be evaluated, they need to be added to the array
    cycle = gMLC_basket.status.cycle+1;
    for p=1:explo_param(1)
        Js=gMLC_table.evaluate(IDs(p),gMLC_parameters,0); % visu
          N_ev = length(gMLC_basket.status.individuals_to_evaluate)+p-explo_param(1);
        gMLC_table.individuals(IDs(p)).evaluation_order = [cycle,N_ev];
        if (VERBOSE > 4) && not(mod(p,10)), fprintf('\n'),end
    end


%% Update properties
    % Individuals informations
        gMLC_basket.waiting_room.labels = [gMLC_basket.waiting_room.labels;IDs];
        gMLC_basket.waiting_room.costs = [gMLC_basket.waiting_room.costs;Js];
    % Stat
            gMLC_basket.status.last_operation = 'Random addition';

if VERBOSE > 2, fprintf('\n     Add new random individual(s) - End\n'),end

end %method
