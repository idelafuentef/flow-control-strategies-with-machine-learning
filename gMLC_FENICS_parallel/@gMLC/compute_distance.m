function compute_distance(gMLC)
% gMLC class compute_distance method
%
% Compute the prior distance between the evaluated individuals.
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    Name = gMLC.parameters.Name;
    InputNumber = gMLC.parameters.ProblemParameters.InputNumber;
    number = gMLC.table.number;
    OutputNumber = gMLC.parameters.ProblemParameters.OutputNumber;
    BadValue = gMLC.parameters.BadValue;
    number_ic = gMLC.parameters.ProblemParameters.InitialCondition;


%% Extract evaluated individuals
    logical_eval = gMLC.table.evaluated>0; % Here, we should also test if their cost is not bas value
    logical_costs = gMLC.table.costs(1:number)<BadValue;
    logical_labels = logical(logical_eval(1:length(logical_costs)).*logical_costs);
    labels = 1:number;
    labels = labels(logical_labels);
    Nl = length(labels);

%% Load Distances already computed if exist
      dir_Distance = ['save_runs/',Name,'/Proximity_map/Distances.mat'];
      if exist(dir_Distance,'file')
          Distances = load(dir_Distance);
          Distances = Distances.MNij;
%           load(dir_Distance);
      else
          Distances = [1,-1,-1];
      end

%% Load data to compute distance
    global CL
    global Costs
    global Actu
    global Time

    load(['save_runs/',Name,'/Proximity_map/CL.mat']);
    load(['save_runs/',Name,'/Proximity_map/Costs.mat']);
    load(['save_runs/',Name,'/Proximity_map/Time.mat']);
    load(['save_runs/',Name,'/Actuations/Actu.mat']);
        Actu = reshape(Actu,[],OutputNumber*number_ic,number);

    if InputNumber>1
        global SSS
        load(['save_runs/',Name,'/Sensors/SSS.mat']);
        SSS = reshape(SSS,[],InputNumber*number_ic,number);
    end
%% Distance function
    eval(['Distance=@',gMLC.parameters.problem,'_distance;']);

%% Compute distance and store
    MNij = -1*ones(number*(number-1)/2,3);
    MNij(1:size(Distances,1),:) = Distances;

    for p=2:Nl
        for q=1:(p-1)
            idx = u(labels(q),labels(p));
            if MNij(idx,2)<0
                [Dist1,Dist2] = Distance(labels(q),labels(p));
                MNij(idx,:)=[idx,Dist1,Dist2];
            end
        end
    end

%% Save
    save(dir_Distance,'MNij');

%% labels
    logical_eval = gMLC.table.evaluated>0; % Here, we should also test if their cost is not bas value
    logical_costs = gMLC.table.costs(1:number)<BadValue;

    % labels of indivuduals evaluated and with a good cost
    logical_labels = logical(logical_eval(1:length(logical_costs)).*logical_costs);

    number_good = sum(logical_labels); % number of good individuals to plot

%% Matrix reconstruction
       % allocation
    Mij_all  = zeros(number,number);
    Nij_all  = zeros(number,number);

    % Reconstruct
    for p=1:length(MNij)
        IDXP = MNij(p,1);
        if IDXP>0
            [ii,jj]=v(IDXP);
            Mij_all(ii,jj) = MNij(IDXP,2); Mij_all(jj,ii) = MNij(IDXP,2);
            Nij_all(ii,jj) = MNij(IDXP,3); Nij_all(jj,ii) = MNij(IDXP,3);
        end
    end

    % Remove individuals not computed or diverged
    Mij = Mij_all(logical_labels,logical_labels);
    Nij = Nij_all(logical_labels,logical_labels);

    % Compute alpha
    a1 = max(max(Mij));
    a2 = max(max(Nij));
    alpha = (a1/a2)^2;

    % Matrix
    Mat = Mij.^2+alpha*Nij.^2;

%% Compute Coordinates
    % Matrice of distances squared
    D2 = Mat;

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
    save(['save_runs/',Name,'/Proximity_map/Gamma.mat'],'Gamma')
    save(['save_runs/',Name,'/Proximity_map/lambda.mat'],'lambda')

end %method
