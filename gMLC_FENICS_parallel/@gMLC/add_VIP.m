function gMLC=add_VIP(gMLC,controllaw,Name)
% gMLC class add_VIP method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;

%% VIPs
    if isempty(gMLC.table.VIP(1).control_law)
        Next_VIP = 1;
    else
        Next_VIP = length(gMLC.table.VIP)+1;
    end
    
%% Estimate - numerical equivalency
    % evaluation
      controllaw = strrep_cl(gMLC.parameters,controllaw,1);
        evaluation_time = gMLC.parameters.ControlLaw.EvalTimeSample;
        control_points = gMLC.parameters.ControlLaw.ControlPoints;
        evap = vertcat(evaluation_time,control_points);
      actuation_limit = gMLC.parameters.ProblemParameters.ActuationLimit;
      to_round = gMLC.parameters.ProblemParameters.RoundEval;
      values = eval_controller_points(controllaw,evap,actuation_limit,to_round);
    % reshape
      ControlPoints = reshape(values,1,[]);
   
%% Add VIP
    VIP.control_law = controllaw;
    VIP.ID = -1;
    VIP.ControlPoints = ControlPoints;
    VIP.distances = [];
    VIP.status = 'not generated';
    VIP.Name = Name;

%% Update properties
    gMLC.table.VIP(Next_VIP) = VIP;    

end %method
