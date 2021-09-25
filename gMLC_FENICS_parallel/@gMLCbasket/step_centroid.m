function gMLC_basket=step_centroid(gMLC_basket,gMLC_table,gMLC_parameters)
% gMLCbasket class step_centroid method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    N_EP = gMLC_parameters.ControlLaw.ControlPointNumber;
    MI = gMLC_parameters.ProblemParameters.OutputNumber;
    N_CP = N_EP*MI;
    BS = gMLC_parameters.basket_size;
    BadValue = gMLC_parameters.BadValue;

if VERBOSE > 3, fprintf('    o Centroid : '),end

%% Compute centroid
    % Initialization
      centroid = NaN(1,N_CP);
    % Individuals
      labels = gMLC_basket.labels;
      costs = gMLC_basket.costs;
      Jend = gMLC_basket.costs(end);
      good_indiv = costs < gMLC_parameters.BadValue/10^3;
      labels = labels(good_indiv);
    % Control points
      ControlPoints(:,:) = gMLC_table.ControlPoints(labels(1:(end-1)),:);
    % Centroid
      centroid(:) = mean(ControlPoints,1);

%% Update properties
    % Centroid
      gMLC_basket.centroid = centroid;
    % Stat
      gMLC_basket.status.last_operation = 'centroid';

if VERBOSE > 3, fprintf('Done\n'),end

%% Next step
 % if Jcentroid >= Jend
   gMLC_basket.step_reflect(gMLC_table,gMLC_parameters);
 % end


end %method
