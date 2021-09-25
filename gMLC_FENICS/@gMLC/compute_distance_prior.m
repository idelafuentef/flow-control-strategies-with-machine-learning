function compute_distance_prior(gMLC)
% gMLC class compute_distance method
%
% Compute the prior distance between the evaluated individuals.
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    Name = gMLC.parameters.Name;
    BadValue = gMLC.parameters.BadValue_plot;
    number = gMLC.table.number;

%% Extract evaluated individuals
    logical_labels = gMLC.table.evaluated>0;
    labels = 1:gMLC.table.number;
    labels = labels(logical_labels);
    Nl = length(labels);

%% Complete the distance list
    Nb_Nl = Nl*(Nl-1)/2;
    Nb_DL = size(gMLC.table.distance_list,1);
    if Nb_DL<Nb_Nl
        gMLC.table.distance_list = [gMLC.table.distance_list;-1*ones(Nb_Nl-Nb_DL,2)];
    end

%% Compute distance and store
    for p=2:Nl
        for q=1:(p-1)
            idx = u(labels(q),labels(p));
            if gMLC.table.distance_list(idx,2)<0
                set1 = gMLC.table.ControlPoints(labels(q),:);
                set2 = gMLC.table.ControlPoints(labels(p),:);
                gMLC.table.distance_list(idx,:) = [idx,CP_distance(set1,set2)];
            end
        end
    end

%% Test
    number = sum(logical_labels);
    Nb_dist = number*(number-1)/2;
    Nb_dist_computed = sum(gMLC.table.distance_list(:,2)>=0);
    if Nb_dist~=Nb_dist_computed
      fprintf('Error number of distance computed %i/%i\n',Nb_dist_computed,Nb_dist)
    end

%% labels
    logical_eval = gMLC.table.evaluated>0; % Here, we should also test if their cost is not bas value
    logical_costs = gMLC.table.costs(1:number)<BadValue;

    logical_labels = logical(logical_eval(1:length(logical_costs)).*logical_costs);
%     labels = 1:number;
%     labels = labels(logical_labels);

    number_good = sum(logical_labels); % number of good individuals to plot

%% Matrix reconstruction
       % allocation
    Mij_all  = zeros(number,number);

    % distance list
    DL = gMLC.table.distance_list;
    DL_clean = DL(DL(:,2)>=0,:);

    % Reconstruct
    for p=1:length(DL_clean)
        [ii,jj]=v(DL_clean(p,1));
        Mij_all(ii,jj) = DL_clean(p,2); Mij_all(jj,ii) = DL_clean(p,2);
    end

    % Remove individuals not computed or diverged
    Mij = Mij_all(logical_labels,logical_labels);



%% Compute Coordinates
    % Matrice of distances squared
    D2 = Mij.^2;

    % Matrix of the Euclidean inner product B
    C = eye(number_good)-(1/number_good)*ones(number_good,number_good);
    B = C*((-1/2)*D2)*C;
    % symmetrization in order to erase computation errors
    B = (1/2)*(B+B');

    % Eigendecomposition of B (eigenvalues sorted)
    [V,lambda] = eig(B);

    % Reorganization of data
    [~,lambda_indices] = sort(max(real(lambda)),'descend');
    V = V(:,lambda_indices);
    lambda = lambda(:,lambda_indices);
    lambda = lambda(lambda_indices,:);

    % Computation of Gamma
    sqrtlambda  = lambda;
    sqrtlambda(sqrtlambda~=0)=sqrt(lambda(lambda~=0));
    Gamma = V*sqrtlambda;

    %% Save
    save(['save_runs/',Name,'/Proximity_map/Gamma_prior.mat'],'Gamma')
    save(['save_runs/',Name,'/Proximity_map/lambda_prior.mat'],'lambda')

end %method
