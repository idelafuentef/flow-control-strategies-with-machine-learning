function gMLC_basket=evaluate(gMLC_basket,gMLC_table,gMLC_parameters)
% gMLCbasket class evaluate method
%
% Evaluates the non-evaluated elements of the basket.
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    BS = gMLC_parameters.basket_size;

if VERBOSE > 2, fprintf('     Evaluation of the basket\n'),end

% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! %
% !!  Add some condition : "external evaluation" then export data for evaluation.  !! %
% !!  Else                                                                         !! %
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! %


%% Which individual to evaluate
% Verify if they are not already evaluated (for internal evaluation)
    ind_to_eval = gMLC_basket.status.individuals_to_evaluate;
    Ne = length(ind_to_eval);
      % Verification
      true_ind_to_eval = [];
      for p=1:Ne
        cost = gMLC_table.individuals(ind_to_eval(p)).cost{1};
        if cost<0
          true_ind_to_eval = [true_ind_to_eval,ind_to_eval(p)];
        end
      end
    ind_to_eval = true_ind_to_eval;
    Ne = length(ind_to_eval);

%% Number of individuals to evaluate
if VERBOSE > 2, fprintf('%i individual(s) to evaluate\n',Ne),end

%% Evaluation loop
    cycle = gMLC_basket.status.cycle;
    for p=1:Ne
      if VERBOSE > 3, fprintf('Evaluation of control law %i/%i: ',p,Ne),end
      ID = gMLC_basket.labels(p);
      indiv_cost=gMLC_table.evaluate(ind_to_eval(p),gMLC_parameters,0);
      gMLC_table.individuals(ID).cost{1}=indiv_cost;
      gMLC_table.individuals(ind_to_eval(p)).evaluation_order = [cycle,p];
      if VERBOSE > 3, fprintf('J = %f\n',indiv_cost),end
    end

%% Update properties
      for p=1:BS
        ID = gMLC_basket.labels(p);
        gMLC_basket.costs(p) = gMLC_table.individuals(ID).cost{1};
      end
      if sum(gMLC_basket.costs<0)
        error('All individuals have not been evaluated')
      end
      gMLC_basket.status.evaluated = 'evaluated';
      gMLC_basket.status.individuals_to_evaluate = []; % for numerical simulation, we could compute several control laws at the same time


if VERBOSE > 2, fprintf('     End of basket Evaluation\n'),end

end %method
