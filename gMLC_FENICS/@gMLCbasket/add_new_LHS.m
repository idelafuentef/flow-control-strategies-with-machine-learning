function gMLC_basket=add_new_LHS(gMLC_basket,gMLC_stock,gMLC_table,gMLC_parameters)
% gMLCbasket class add_new_LHS method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    BS = gMLC_parameters.basket_size;
    N_ope = gMLC_parameters.MaxIterations;
    stock_test = gMLC_parameters.stock_test;

if VERBOSE > 2, fprintf('     Add new individual from stock - Start\n'),end

%% Select a new individual in the stock
    % Selection
    IDs = gMLC_stock.select_new_LHS_individual(gMLC_table,gMLC_parameters);
    % To evaluate
    gMLC_basket.status.individuals_to_evaluate = [gMLC_basket.status.individuals_to_evaluate;IDs];

%% Evaluation
    % The control law is evaluated here, so no need to put in the individuals_to_evaluate array.
    % But if there were to not be evaluated, they need to be added to the array
        Js=gMLC_table.evaluate(IDs,gMLC_parameters,0); % visu
          cycle = gMLC_basket.status.cycle+1;
          N_ev = length(gMLC_basket.status.individuals_to_evaluate)+1;
        gMLC_table.individuals(IDs).evaluation_order = [cycle,N_ev];


%% Update properties
    % Individuals informations
        gMLC_basket.waiting_room.labels = [gMLC_basket.waiting_room.labels;IDs];
        gMLC_basket.waiting_room.costs = [gMLC_basket.waiting_room.costs;Js];
    % Stat
        gMLC_basket.status.last_operation = 'LHS addition';


if VERBOSE > 2, fprintf('     Add new individual from stock - End\n'),end

end %method
