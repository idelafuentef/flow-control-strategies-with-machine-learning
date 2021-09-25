function gMLC=step_exploration(gMLC)
% gMLC class step_exploration method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    cycle = gMLC.history.cycle;
    exploration = gMLC.parameters.exploration;

    if VERBOSE > 0, fprintf('########## EXPLORATION ##########\n'),end
%% Exploration type
      % Exploration type
      switch exploration
      case 'Random'
        gMLC.basket.add_new_random(gMLC.table,gMLC.parameters);
        fact_type = 21;
      case 'LHS'
        gMLC.basket.add_new_LHS(gMLC.stock,gMLC.table,gMLC.parameters);
        fact_type = 22;
      case 'none'
        gMLC.basket.status.last_operation = 'no exploration';
        fact_type = -Inf;
        if VERBOSE > 0, fprintf(' No exploration\n'),end
      otherwise
        error('Exploration error')
      end

      % Evaluate
      % gMLC.basket.evaluate(gMLC.table,gMLC.parameters);

      % Update basket (from waiting_room)
      gMLC.stock.update(gMLC.table,gMLC.parameters);
      labels=gMLC.basket.update(gMLC.table,gMLC.parameters);

      % Update history
      if not(isinf(fact_type))
          gMLC.history.add_fact(gMLC.parameters,fact_type,labels);
      end

  %% End Step1
    if VERBOSE > 0, fprintf('###### END OF EXPLORATION #######\n'),end
    if VERBOSE > 0, fprintf('\n'),end

end %method
