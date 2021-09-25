function [label,gMLC_stock]=select_new_LHS_individual(gMLC_stock,gMLC_table,gMLC_parameters)
% gMLCstock class select_new_LHS_individual method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)


%% TO BE IMPROVED AVOINDING REDUNDANT COMPUTATION


%% Parameters
    VERBOSE = gMLC_parameters.verbose;

%% Data
    stock_labels = gMLC_stock.labels(gMLC_stock.evaluated==0);
    already_evaluated = gMLC_table.evaluated>0;
    already_labels = 1:gMLC_table.number;
    already_labels = already_labels(already_evaluated);

%% Find the best individual in the stock
% For each not evaluated individual in the stock we compute its distance to the
% set of already evaluated individuals.
% And we take the individual that is the furthest away, meaning which distance is
% the highest.

  CP_stock = gMLC_table.ControlPoints(stock_labels,:);
  CP_already_evaluated = gMLC_table.ControlPoints(already_labels,:);

  % Compute the distances
  [idx,Dist_mat] = maxdist(CP_stock,CP_already_evaluated);
  label = stock_labels(idx);
  % Gives the furthest away individual in the stock from the already evaluated individuals
  % Dist_mat is a second argument giving the distance between the elements

  % Update the distance_list %% TO BE UPDATED
  for p=1:length(stock_labels)
    for q=1:length(already_labels)
      ind1 = min(stock_labels(p),already_labels(q));
      ind2 = max(stock_labels(p),already_labels(q));
      idx = u(ind1,ind2);
      gMLC_table.distance_list(idx,2) = Dist_mat(p,q);
    end
  end

%% THINGS TO DO
% switch gMLC_parameters.exploration
%   case 'LHSA1' % On the control points
%   case 'LHSA2' % On the control laws (iterative process; annealing for example)
%   otherwise
%     error('No codded yet, other exploration')
% end

end %method
