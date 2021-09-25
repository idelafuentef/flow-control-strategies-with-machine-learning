function extract_to_compute_distance(gMLC)
% gMLC class extract_to_compute_distance method
%
% Creates files that makes the computation of distances faster
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    Name = gMLC.parameters.Name;
    number = gMLC.table.number;
    act_lim = gMLC.parameters.ProblemParameters.ActuationLimit;
    OutputNumber = gMLC.parameters.ProblemParameters.OutputNumber;
    InputNumber = gMLC.parameters.ProblemParameters.InputNumber;
    t0 = gMLC.parameters.ProblemParameters.T0;
    tmax = gMLC.parameters.ProblemParameters.Tmax;
    dt = gMLC.parameters.ProblemParameters.dt;
    param = gMLC.parameters; param.save_data = 1;
    number_ic = gMLC.parameters.ProblemParameters.InitialCondition;
    BadValue = gMLC.parameters.BadValue;

%% Allocation
    CL = cell(number,OutputNumber);
    Costs = zeros(number,1);

%% Extract evaluated individuals
    % labels evaluated and non bad (logical)
    logical_eval = gMLC.table.evaluated>0; % Here, we should also test if their cost is not bas value
    logical_costs = gMLC.table.costs(1:number)<BadValue;

    % labels evaluated and non bad (indices)
    logical_labels = logical(logical_eval(1:length(logical_costs)).*logical_costs);

    % labels
    labels = 1:gMLC.table.number;
    labels = labels(logical_labels);

%% Load if exists
N0labels1 = 1; N0labels2 = 1;
if exist(['save_runs/',Name,'/Proximity_map/CL.mat'],'file')
     CLOld = load(['save_runs/',Name,'/Proximity_map/CL.mat']);
     CLOld = CLOld.CL;
     N0labels1 = size(CLOld,1);
     CL(1:N0labels1,:) = CLOld;
     N0labels1 = N0labels1+1;

end
if exist(['save_runs/',Name,'/Proximity_map/Costs.mat'],'file')
    CostsOld = load(['save_runs/',Name,'/Proximity_map/Costs.mat']);
    CostsOld = CostsOld.Costs;
    N0labels2 = size(CostsOld,1);
    Costs(1:N0labels2) = CostsOld;
    N0labels2 = N0labels2+1;
end
N0labels = min(N0labels1,N0labels2);

%% Extraction
labels1 = labels(labels>=N0labels); % add only those missing
for p=1:length(labels1)
		bi = gMLC.table.individuals(labels1(p)).control_law;
		bi = strrep_cl(gMLC.parameters,bi,1); % test
		bi = limit_to(bi,act_lim);
        CL(labels1(p),:) = bi;
        Costs(labels1(p)) = gMLC.table.individuals(labels1(p)).cost{1};
end

% %% Reduction
% [uII,IA,IC] = unique(labels);

%% Save
save(['save_runs/',Name,'/Proximity_map/CL.mat'],'CL');
save(['save_runs/',Name,'/Proximity_map/Costs.mat'],'Costs');

%% Append sensors
% Initialization
Time = transpose(t0:dt:tmax);

if InputNumber >1
    SSS = inf(length(Time),InputNumber*number_ic,number);
    N0labels = 1;
    if exist(['save_runs/',Name,'/Sensors/SSS.mat'],'file')
        SSSOld = load(['save_runs/',Name,'/Sensors/SSS.mat']);
        SSSOld = SSSOld.SSS;
        SSSOld = reshape(SSSOld,length(Time),InputNumber*number_ic,[]);
        SSS(:,:,1:size(SSSOld,3)) = SSSOld;
        N0labels = size(SSSOld,3)+1;
    end
    labels2 = labels(labels>=N0labels); % add only those missing
    for p=1:length(labels2)
            nami = ['save_runs/',Name,'/Sensors/ID',num2str(labels2(p)),'.dat'];
            if not(exist(nami,'file'))
                gMLC.table.individuals(labels2(p)).evaluate(param,0,1); %visu,force_eval
            end
            SSi = load(nami,'-ascii');
            size_SSi = size(SSi,1);
            SSS(1:size_SSi,:,labels2(p)) = SSi(:,2:end);
            if (VERBOSE > 4) && not(mod(p,10)), fprintf('\n'),end
    end
%     Time = SSi(:,1); % already defined
    % Save sensor data
    SSS=reshape(SSS,[],InputNumber*number_ic);
    save(['save_runs/',Name,'/Sensors/SSS.mat'],'SSS');
end

    % Save time
    if not(exist(['save_runs/',Name,'/Proximity_map/Time.mat'],'file'))
        save(['save_runs/',Name,'/Proximity_map/Time.mat'],'Time');
    end

    % Actuation
    Actu = inf(length(Time),OutputNumber*number_ic,number);
    N0labels = 1;
    if exist(['save_runs/',Name,'/Actuations/Actu.mat'],'file')
        ActuOld = load(['save_runs/',Name,'/Actuations/Actu.mat']);
        ActuOld = ActuOld.Actu;
        ActuOld = reshape(ActuOld,length(Time),OutputNumber*number_ic,[]);
        Actu(:,:,1:size(ActuOld,3)) = ActuOld;
        N0labels = size(ActuOld,3)+1;
    end
    labels3 = labels(labels>=N0labels); % add only those missing
    for p=1:length(labels3)
            nami = ['save_runs/',Name,'/Actuations/ID',num2str(labels3(p)),'.dat'];
            if not(exist(nami,'file'))
                gMLC.table.individuals(labels3(p)).evaluate(param,0,1);%visu, force_eval
            end
            Actui = load(nami,'-ascii');
            size_Actui = size(Actui,1);
            Actu(1:size_Actui,:,labels3(p)) = Actui(:,2:end);
%             if (VERBOSE > 4) && not(mod(p,10)), fprintf('\n'),end
    end
    % Save actuation
    Actu=reshape(Actu,[],OutputNumber*number_ic);
    save(['save_runs/',Name,'/Actuations/Actu.mat'],'Actu');
end %method
