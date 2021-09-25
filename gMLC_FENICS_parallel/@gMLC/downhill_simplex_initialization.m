function gMLC=downhill_simplex_initialization(gMLC)
% gMLC class downhill_simplex_initialization method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    BIS = gMLC.parameters.basket_init_size;
    BS = gMLC.parameters.basket_size;

%% Step
    % Generate the initial individuals
      gMLC.basket.generate_random(gMLC.table,gMLC.parameters);

    % Stock labels
      labels = gMLC.basket.initial_individuals.labels;

% SEE MONTE CARLO
      % Evaluate stock
      % if VERBOSE > 2, fprintf('     Evaluation of the basket\n'),end
      % cycle = gMLC.basket.status.cycle;
      % for p=1:BIS
      %   gMLC.table.evaluate(labels(p),gMLC.parameters,0);
      %   gMLC.table.individuals(labels(p)).evaluation_order = [cycle,p];
      %   if VERBOSE > 3, fprintf('\n'),end
      % end
      % gMLC.stock.evaluated(:) = 1;
      % if VERBOSE > 2, fprintf('     End of basket Evaluation\n'),end
      %
      % % Best individuals
      % costs = NaN(BIS,1);
      % for p=1:BIS
      %     costs(p) = gMLC.table.individuals(labels(p)).cost{1};
      % end
      % [best_costs,idx] = sort(costs);


  % Fill the basket adequately
    % Take the most performant individual and take the closest one to it.
    % TO BE DONE
    error('Not coded yet...')
    gMLC.basket.labels = labels(idx(1:BS));
    gMLC.basket.costs = best_costs((1:BS));
    gMLC.basket.status.last_operation = 'Filled from Monte Carlo';
    gMLC.basket.status.evaluated = 'evaluated';

%% Update properties

end %method
