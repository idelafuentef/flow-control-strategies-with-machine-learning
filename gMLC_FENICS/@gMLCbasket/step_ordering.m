function gMLC_basket=step_ordering(gMLC_basket,gMLC_table,gMLC_parameters)
% gMLCbasket class step_ordering method
%
% Rearrange the labels following the costs.
% Lower costs has lower rank.
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    BS = gMLC_parameters.basket_size;

if VERBOSE > 3, fprintf('    o Ordering : '),end
%% Update properties
    % Individuals informations
        labels = gMLC_basket.labels;
        costs = gMLC_basket.costs;
    % Sort
        [~,idx] = sort(costs);
    % New vertices
	vertices = labels(idx);
    % Update basket
        gMLC_basket.labels = vertices;
        gMLC_basket.costs = costs(idx);
 
    % Stat
        gMLC_basket.status.last_operation = 'ordering';

if VERBOSE > 3, fprintf('Done\n'),end

end %method
