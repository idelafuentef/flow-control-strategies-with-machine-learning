function gMLC=monte_carlo(gMLC_basket,gMLC_table,gMLC_parameters)
% gMLC class monte_carlo method
%
% This method fills the stock with a given number of individuals and
% evaluates them.
% The 10 (BS) best individuals are then transferred to the basket.
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    BIS = gMLC_parameters.basket_init_size;
    BS = gMLC_parameters.basket_size;
    problem_type = gMLC_parameters.problem_type;
    InitializationClustering = gMLC_parameters.InitializationClustering;
    LandscapeType = gMLC_parameters.LandscapeType;
    BadValue = gMLC_parameters.BadValue;

%% Initialization step
      % Generate the initial individuals
      gMLC_basket.generate_random(gMLC_table,gMLC_parameters);

      % Stock labels
      labels = gMLC_basket.initial_individuals.labels;

      % Evaluate initial basket
      if strcmp(problem_type,'external')
        gMLC.send_EXE(labels,'MonteCarlo');
        gMLC_basket.status.last_operation = 'Send_to_ExE';
        gMLC_basket.status.evaluated = 'nonevaluated';
        gMLC_basket.waiting_room.labels = labels;
        gMLC_basket.waiting_room.costs = -1+0*labels;
        return
      end

      % Evaluate basket
      if VERBOSE > 2, fprintf('     Evaluation of the basket\n'),end
      cycle = gMLC_basket.status.cycle;
      
      if gMLC_parameters.parallel==0
          for p=1:BIS
            gMLC_table.evaluate(labels(p),gMLC_parameters,0);
            gMLC_table.individuals(labels(p)).evaluation_order = [cycle,p];
            if (VERBOSE > 4) && not(mod(p,10)), fprintf('\n'),end
          end
      else
          parfor p=1:BIS
            indiv_cost=evaluate(labels(p),gMLC_parameters,0);
            individuals(labels(p)).cost=indiv_cost;
            individuals(labels(p)).evaluation_order = [cycle,p];
            if (VERBOSE > 4) && not(mod(p,10)), fprintf('\n'),end
          end
      end
      if VERBOSE > 2, fprintf('     End of basket Evaluation\n'),end

%% Clustering or not?
        % What are the costs?
        costs = gMLC_table.costs(labels);
        
        % Clutering or not?
      if InitializationClustering
          if VERBOSE > 0, fprintf('  o Landscape description: %s\n',LandscapeType),end

          % Initialization
          NLandscapeLabels = BS;
          labels_to_cluster = labels(costs<BadValue/10);Nlabels = length(labels_to_cluster);
          
          if Nlabels<BS
              error('Not enough individuals in to Cluster (because of MC or BadValue)\n')
          end
          % Cluster following the type
          switch LandscapeType
              case 'CostSection'
                      NPerSection = floor(BIS/NLandscapeLabels);
                      LandscapeLabels = labels_to_cluster(1:NPerSection:NPerSection*NLandscapeLabels);
              case 'ClusteringDistance'
                  % extract and compute the distance matrix
                  gMLC.extract_to_compute_distance;
                  gMLC.compute_distance;
                  % Cluster (gives the individual the closest to the centroid)
                  LandscapeLabels_classes = gMLC_table.cluster_distance(gMLC_parameters,labels_to_cluster,NLandscapeLabels);
                  % Choose one element from each cluster
                  LandscapeLabels = NaN(NLandscapeLabels,1);
                  for p=1:NLandscapeLabels
                      LandscapeLabels(p) = LandscapeLabels_classes{p,1};
                  end
              case 'ClusteringCorrelation'
                  % extract the actions (and other stuff)
                  gMLC.extract_to_compute_distance;
                  % Cluster (gives the individual the closest to the centroid and the individuals in the cluster)
                  LandscapeLabels_classes = gMLC_table.cluster_correlation(gMLC_parameters,labels_to_cluster,NLandscapeLabels);
                  % Choose one element from each cluster
                  NLandscapeLabels = size(LandscapeLabels_classes,1);
                  LandscapeLabels = NaN(NLandscapeLabels,1);
                  for p=1:NLandscapeLabels
                      LandscapeLabels(p) = LandscapeLabels_classes{p,1};
                  end
              otherwise
                  error('Wrong LandscapeType')
          end
          % LandscapeLabels -> vertices
          vertices = LandscapeLabels;
          if sum(isnan(vertices)), error('Clustering failed to give enough individuals'),end
          
      else % No cluster - just take the best individuals
      % Best individuals
        [~,idx] = sort(costs);
      % vertices
    	vertices = labels(idx(1:BS));
      end
      
    % Initialize the vertices in the database
    for p=1:gMLC_table.number
        gMLC_table.individuals(p).vertices = p;
        gMLC_table.individuals(p).coefficients = 1;
    end
        
    % Fill basket
    gMLC_basket.labels = vertices;
    gMLC_basket.costs = gMLC_table.costs(vertices); 
    if InitializationClustering
        gMLC_basket.status.last_operation = ['Filled from Monte Carlo - ',LandscapeType];
    else
        gMLC_basket.status.last_operation = 'Filled from Monte Carlo';
    end
    gMLC_basket.status.evaluated = 'evaluated';

%% Update properties
      % Nothing to update
   gMLC.basket=gMLC_basket;
   gMLC.table=gMLC_table;
   gMLC.parameters=gMLC_parameters;

end %method
