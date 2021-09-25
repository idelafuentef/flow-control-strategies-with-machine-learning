function LandscapeLabels=landscape_description(gMLC)
% gMLC class landscape_description method
% Computes 40 clusters od the Complete basket (data base) and extracts
% representatives for each cluster.
%
% Guy Y. Cornejo Maceda, 10/07/2019
%
% See also step_evolution

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    BadValue = gMLC.parameters.BadValue;
    LandscapeType = gMLC.parameters.LandscapeType;
    cycle = gMLC.history.cycle(1);
    NLandscapeLabels = 40;
    
if VERBOSE > 0, fprintf('  o Landscape description: %s\n',LandscapeType),end

%% Initialiazation
    number = gMLC.table.number;
    labels = transpose(1:number);
    % evaluated
    labels = labels(gMLC.table.evaluated>0);Nlabels = length(labels);
    % good cost or not
    costs = gMLC.table.costs(labels);
    labels_to_cluster = labels(costs<BadValue/10);Nlabels = length(labels_to_cluster);
    ToAdd = zeros(1,NLandscapeLabels);


%% Select the landscape labels
    switch LandscapeType
        case 'CostSection'
            if Nlabels<NLandscapeLabels
                LandscapeLabels = labels_to_cluster;
            else
                NPerSection = floor(Nlabels/NLandscapeLabels);
                LandscapeLabels = labels_to_cluster(1:NPerSection:NPerSection*NLandscapeLabels);
            end
        case 'ClusteringDistance'
            if Nlabels < NLandscapeLabels
                NLandscapeLabels = Nlabels;
            end
            % extract and compute the distance matrix
            gMLC.extract_to_compute_distance;
            gMLC.compute_distance;
            % Cluster (gives the individual the closest to the centroid)
            LandscapeLabels_classes = gMLC.table.cluster_distance(gMLC.parameters,labels_to_cluster,NLandscapeLabels);
            % Choose one element from each cluster
            LandscapeLabels = NaN(NLandscapeLabels,1);
            for p=1:NLandscapeLabels
                LandscapeLabels(p) = LandscapeLabels_classes{p,1};
            end
        case 'ClusteringCorrelation'
            if Nlabels < NLandscapeLabels
                NLandscapeLabels = Nlabels;
            end
            % extract the actions (and other stuff)
            gMLC.extract_to_compute_distance;
            % Cluster (gives the individual the closest to the centroid and the individuals in the cluster)
            LandscapeLabels_classes = gMLC.table.cluster_correlation(gMLC.parameters,labels_to_cluster,NLandscapeLabels);
            % Choose one element from each cluster
            NLandscapeLabels = size(LandscapeLabels_classes,1);
            LandscapeLabels = NaN(NLandscapeLabels,1);
            for p=1:NLandscapeLabels
                LandscapeLabels(p) = LandscapeLabels_classes{p,1};
            end
        otherwise 
            error('Wrong LandscapeType')
    end

%% Update properties
    ToAdd(1:numel(LandscapeLabels))=LandscapeLabels;
    gMLC.landscapebasket = vertcat(gMLC.landscapebasket,[cycle+1,ToAdd]);

end %method
