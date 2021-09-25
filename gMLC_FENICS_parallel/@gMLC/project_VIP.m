function project_VIP(gMLC)
% gMLC class project_VIP method
%
% Plot the VIPs in the proximity map
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    Name = gMLC.parameters.Name;
    number = gMLC.table.number;

%% Extract evaluated individuals
    logical_labels = gMLC.table.evaluated>0;
    labels = 1:gMLC.table.number;
    labels = labels(logical_labels);
    Nl = length(labels);
    
%% Number of VIPS
    NbVIPs = length(gMLC.table.VIP);
    
%% Is there any VIPs?
    if isempty(gMLC.table.VIP(1).control_law)
        fprintf(' No VIPs :)\n')
        return
    end
%% Compute distance of VIPs and store if it has not been done
    for p=1:NbVIPs
        % Control points
        set1 = gMLC.table.VIP(p).ControlPoints;
        
        % Complete the distance list for the VIPs
        NbVIPdistances = size(gMLC.table.VIP(p).distances,1);
        if NbVIPdistances<(Nl+p-1)
            gMLC.table.VIP(p).distances = [gMLC.table.VIP(p).distances;-1*ones(Nl+p-1-NbVIPdistances,2)];
        end
        
        % Loop over the individuals
        for q=1:Nl
            if gMLC.table.VIP(p).distances(labels(q),2)<0
                set2 = gMLC.table.ControlPoints(labels(q),:);
                gMLC.table.VIP(p).distances(labels(q),:) = [labels(q),CP_distance(set1,set2)];
            end
        end
        
        % Loop over the VIPs
        for k=1:(p-1)
            set2 = gMLC.table.VIP(k).ControlPoints;
            gMLC.table.VIP(p).distances(q+k,:) = [-k,CP_distance(set1,set2)];
        end
        
    end
                

%% labels
    logical_labels = gMLC.table.evaluated>0; % Here, we should also test if their cost is not bas value
    number_good = sum(logical_labels); % number of good individuals to plot
    
%% Matrix reconstruction
    % allocation
    Mij_all  = zeros(number,number);
    Mij_VIP = zeros(Nl+NbVIPs,Nl+NbVIPs);

    % distance list
    DL = gMLC.table.distance_list;
    DL_clean = DL(DL(:,2)>=0,:);

    % Reconstruct
    for p=1:length(DL_clean)
        [ii,jj]=v(DL_clean(p,1));
        Mij_all(ii,jj) = DL_clean(p,2); Mij_all(jj,ii) = DL_clean(p,2);
    end

    % Add the distances in the VIP Matrix
    Mij_VIP(1:Nl,1:Nl) = Mij_all(logical_labels,logical_labels);
    
    % Add the VIP distances
    for p=1:NbVIPs
        Mij_VIP(Nl+p,1:(Nl+p-1)) = gMLC.table.VIP(p).distances(:,2);
        Mij_VIP(1:(Nl+p-1),Nl+p) = gMLC.table.VIP(p).distances(:,2);
    end
    
    % Distance matrix
    Mij = Mij_VIP;
    
%% Compute Coordinates
    % Matrice of distances squared
    D2 = Mij.^2;

    % Matrix of the Euclidean inner product B
    dimMij = size(Mij,1);
    C = eye(dimMij)-(1/dimMij)*ones(dimMij,dimMij);
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


%% labels
%     map_labels = logical_labels.*cumsum(logical_labels); % indices in the map corresponding to a given individual

%% Costs
    Costs = gMLC.table.costs(labels);

    % Sort individuals following their performance and give new values
    z=Costs;
    [~,IDX_Costs] = sort(Costs);
    num = flip(1:number_good);
    z(IDX_Costs)=num/number_good*100;

    % Delaunay triangulation
    x=Gamma(:,1);
    y=Gamma(:,2);
    tri=delaunay(x(1:Nl),y(1:Nl));

%% Mapping quality
    la = max(lambda);
    qua = sum(la(1:2))/sum(abs(la));
    fprintf('Mapping quality after projection: %f\n',qua)

%% Plot
    Name = [Name,'-prior-VIP projection'];
    figure
    % Contour and fill
    [~,h]=tricontf(x(1:Nl),y(1:Nl),tri,z);
    set(h,'edgecolor','none');

    % Individuals
    hold on
        indiv = 1:number_good;
        scatter(x(indiv),y(indiv),20,'o','filled','MarkerFaceColor',[1,0,0]);
    hold off

    % colormap(cmp)
    colormap(gray)

    % Label and stuff
    FS = 30;
    xlabel('$\gamma_1$','Interpreter','latex','FontSize',FS)
    ylabel('$\gamma_2$','Interpreter','latex','FontSize',FS)
    box on
    grid on
        mx = min(x);
        Mx = max(x);
            Dx = Mx-mx;
        my = min(y);
        My = max(y);
            Dy = My-my;
    axis([mx-0.1*Dx Mx+0.1*Dx my-0.1*Dy My+0.1*Dy])

    ax = gca;
    ax.FontSize = 16;
    set(gcf,'color','w')
    title([Name,' - ',num2str(round(qua,2))])
    set(gca,'DataAspectRatio',[1 1 1]);
    set(gcf, 'Position', 10+[0 0 1000 Dy*1000/Dx])

%% Addition VIP
    % Plot VIPs
    hold on
        scatter(x((Nl+1):end),y((Nl+1):end),20,'*','MarkerEdgeColor',[0,0,1]);
    hold off
    
    % Plot indicators
    for p=1:NbVIPs
        text(x(Nl+p)+0.005*Dx,y(Nl+p)+0.005*Dy,gMLC.table.VIP(p).Name,'FontSize',10,'Interpreter','latex','Color',[0,0,1]);
    end

end %method
