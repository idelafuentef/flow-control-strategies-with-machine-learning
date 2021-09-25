function gMLC=step_initialization(gMLC)
% gMLC class step_initialization method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    cycle = gMLC.history.cycle;
    Name = gMLC.parameters.Name;
    init = gMLC.parameters.initialization;
    exploitation = gMLC.parameters.exploitation;
    exploration = gMLC.parameters.exploration;
    problem_type = gMLC.parameters.problem_type;

%% Step initialization
    if VERBOSE > 0, fprintf('######### INITIALIZATION ##########\n'),end
      % Stock and basket initialization
      if VERBOSE > 1, fprintf(['Stock and basket initialization : ',init,'\n']),end
        switch init
        case 'Monte Carlo'
          gMLC.monte_carlo;
          fact_type = 4;
        case 'Downhill Simplex'
          gMLC.downhill_simplex_initialization;
          fact_type = 5;
        otherwise
          error('Initialization not valid.')
        end
      if VERBOSE > 1, fprintf(['Stock and basket initialization : ',init,'. Done\n\n']),end

      % Exploitation initialization
      if VERBOSE > 1, fprintf(['Exploitation initialization : ',exploitation]),end
        switch exploitation
        case {'none','Downhill Simplex'}
        otherwise
          error('Exploitation type not valid.')
        end
      if VERBOSE > 1, fprintf('. Done\n\n'),end

      % Exploration initialization
      if VERBOSE > 1, fprintf(['Exploration initialization : ',exploration]),end
        switch exploration
        case 'LHS'
          gMLC.stock.generate_LHS(gMLC.table,gMLC.parameters);
        case {'none','Random'}
        otherwise
          error('Exploration not valid.')
        end
      if VERBOSE > 1, fprintf('. Done\n\n'),end

    % Update history and basket status
    if not(strcmp(problem_type,'external'))
      gMLC.history.add_fact(gMLC.parameters,fact_type,gMLC.basket.labels); % Choose the right number
      gMLC.basket.status.cycle=0;
      gMLC.history.cycle(1)=0;
    else
      fprintf('Evaluation can begin!\n')
    end

%% End Step 0
    if VERBOSE > 0, fprintf('###### END OF INITIALIZATION ######\n'),end
    if VERBOSE > 0, fprintf('\n'),end

end %method
