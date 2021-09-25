function export_set_EXE(gMLC,opti_type)
% gMLC class step_end method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    cycle = gMLC.history.cycle;
    problem_type = gMLC.parameters.problem_type;

%% External evaluation (To remove)
    % Evaluate initial basket
    if strcmp(problem_type,'external')
      % waiting room
      labels = gMLC.basket.waiting_room.labels;
      gMLC.send_EXE(labels,opti_type);
      gMLC.basket.status.last_operation = 'Send_to_ExE';
      gMLC.basket.status.evaluated = 'nonevaluated';
      gMLC.basket.waiting_room.costs = -1+0*labels;
      if VERBOSE > 0, fprintf('Sent to external evaluation!\n'),end
      return
    end

end %method
