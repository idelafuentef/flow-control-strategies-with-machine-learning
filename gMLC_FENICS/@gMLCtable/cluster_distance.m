function LandscapeLabels=cluster_distance(gMLC_table,gMLC_parameters,labels_to_cluster,NLandscapeLabels)
% gMLC class cluster_distance method
% Now the exhaustive help text
% descibing inputs, processing and outputs
%
% Guy Y. Cornejo Maceda, 08/27/209
%
% See also SIN, COS, TheOtherFunction.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
    number = gMLC_table.number;
    Name = gMLC_parameters.Name;
    BadValue = gMLC_parameters.BadValue;

%% Load
    load(['save_runs/',Name,'/Proximity_map/Gamma.mat']);
    load(['save_runs/',Name,'/Proximity_map/lambda.mat']);

%% labels
    logical_eval = gMLC_table.evaluated>0; % Here, we should also test if their cost is not bas value
    logical_costs = gMLC_table.costs(1:number)<BadValue/10;
    logical_labels = logical(logical_eval(1:length(logical_costs)).*logical_costs);
    % map labels (to improve)
    map_labels = logical_labels.*cumsum(logical_labels); % indices in the map corresponding to a given individual
    map_labels(map_labels==0) = NaN;

%% Extract sumatrix
    labels_to_pseudo = map_labels(labels_to_cluster); % pseudo-label vector
    subGamma = Gamma(labels_to_pseudo,labels_to_pseudo);

%% Cluster the individuals
    [classes,centers] = kmeans(subGamma,NLandscapeLabels,'Replicates',100,'MaxIter',100);

%% Compute the representative individuals
    LandscapeLabels = cell(NLandscapeLabels,2);
    for p=1:NLandscapeLabels
      % compute closest to center
      coord_classes = subGamma;
      [~,closest2center] = min(sum(abs(coord_classes-centers(p,:)).^2,2));
      % fill variable
      LandscapeLabels{p,1}=labels_to_cluster(closest2center);
      LandscapeLabels{p,2}=labels_to_cluster(labels_to_pseudo(classes==p));
    end

end %method
