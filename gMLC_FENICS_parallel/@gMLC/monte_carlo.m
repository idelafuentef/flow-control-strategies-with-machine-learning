function gMLC=monte_carlo(gMLC)
% gMLC class monte_carlo method
%
% This method fills the stock with a given number of individuals and
% evaluates them.
% The 10 (BS) best individuals are then transferred to the basket.
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    BIS = gMLC.parameters.basket_init_size;
    BS = gMLC.parameters.basket_size;
    problem_type = gMLC.parameters.problem_type;
    InitializationClustering = gMLC.parameters.InitializationClustering;
    LandscapeType = gMLC.parameters.LandscapeType;
    BadValue = gMLC.parameters.BadValue;

%% Initialization step
      % Generate the initial individuals
      gMLC.basket.generate_random(gMLC.table,gMLC.parameters);

      % Stock labels
      labels = gMLC.basket.initial_individuals.labels;

      % Evaluate initial basket
      if strcmp(problem_type,'external')
        gMLC.send_EXE(labels,'MonteCarlo');
        gMLC.basket.status.last_operation = 'Send_to_ExE';
        gMLC.basket.status.evaluated = 'nonevaluated';
        gMLC.basket.waiting_room.labels = labels;
        gMLC.basket.waiting_room.costs = -1+0*labels;
        return
      end

      %% Evaluate basket (original)
%       if VERBOSE > 2, fprintf('     Evaluation of the basket\n'),end
%       cycle = gMLC.basket.status.cycle;
%       for p=1:BIS
%         gMLC.table.evaluate(labels(p),gMLC.parameters,0);
%         gMLC.table.individuals(labels(p)).evaluation_order = [cycle,p];
%         if (VERBOSE > 4) && not(mod(p,10)), fprintf('\n'),end
%       end
%       if VERBOSE > 2, fprintf('     End of basket Evaluation\n'),end

%% Evaluate basket (modified by Philipp version03)
      if VERBOSE > 2, fprintf('     Evaluation of the basket\n'),end
      cycle = gMLC.basket.status.cycle;
      
      ListIndivs(1:BIS) = gMLCind();
      for p = 1:BIS
          ListIndivs(p) = gMLC.table.individuals(labels(p));
      end
      temp1 = gMLC.parameters;
      parfor p = 1:BIS
%       parfor p = 1:BIS
         my_ind = ListIndivs(p);
         disp(['Starting evaluation of ID ',num2str(p)])
         my_ind.evaluate(temp1,0);
         disp(['Evaluation of ID ',num2str(p),' done.'])
         ListIndivs(p) = my_ind;
      end
      for p = 1:BIS
        gMLC.table.individuals(labels(p)) = ListIndivs(p);
        gMLC.table.individuals(labels(p)).evaluation_order = [cycle,p];
        % Update properties
        J = gMLC.table.individuals(labels(p)).cost{1};
        if (~isnan(J))&&(~isinf(J))
            gMLC.table.evaluated(labels(p))=1;
        else
            gMLC.table.evaluated(labels(p))=NaN;
        end
        if (VERBOSE > 4) && not(mod(p,10)), fprintf('\n'),end
      end
      if VERBOSE > 2, fprintf('     End of basket Evaluation\n'),end
      
%% Clustering or not?
        % What are the costs?
        costs = gMLC.table.costs(labels);
        
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
                  LandscapeLabels_classes = gMLC.table.cluster_distance(gMLC.parameters,labels_to_cluster,NLandscapeLabels);
                  % Choose one element from each cluster
                  LandscapeLabels = NaN(NLandscapeLabels,1);
                  for p=1:NLandscapeLabels
                      LandscapeLabels(p) = LandscapeLabels_classes{p,1};
                  end
              case 'ClusteringCorrelation'
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
    for p=1:gMLC.table.number
        gMLC.table.individuals(p).vertices = p;
        gMLC.table.individuals(p).coefficients = 1;
    end
        
    % Fill basket
    gMLC.basket.labels = vertices;
    gMLC.basket.costs = gMLC.table.costs(vertices); 
    if InitializationClustering
        gMLC.basket.status.last_operation = ['Filled from Monte Carlo - ',LandscapeType];
    else
        gMLC.basket.status.last_operation = 'Filled from Monte Carlo';
    end
    gMLC.basket.status.evaluated = 'evaluated';

%% Update properties
      % Nothing to update

end %method
