function proximity_map(gMLC,Step,save)
% gMLC class proximity_map method
%
% Compute proxmity map from a distance based on the control points only.
% The color scale corresponds to the performance of each control law.
% Darker colors denote poor performance.
% Removal of bad invididuals should be added later.
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    Name = gMLC.parameters.Name;
    BadValue = gMLC.parameters.BadValue;
    number = gMLC.table.number;
    BS = gMLC.parameters.basket_size;
    zoom = gMLC.parameters.zoom;
    if nargin<2, Step = -1;save=0;end
    if nargin<3, save=0;end

%% Load
    load(['save_runs/',Name,'/Proximity_map/Gamma.mat']);
    load(['save_runs/',Name,'/Proximity_map/lambda.mat']);

%% labels
    logical_eval = gMLC.table.evaluated>0; % Here, we should also test if their cost is not bas value
    logical_costs = gMLC.table.costs(1:number)<BadValue;
    logical_labels = logical(logical_eval(1:length(logical_costs)).*logical_costs);
    labels = 1:number;
    labels = labels(logical_labels);

    number_good = sum(logical_labels); % number of good individuals to plot

    % map labels (to improve)

    map_labels = logical_labels.*cumsum(logical_labels); % indices in the map corresponding to a given individual
    map_labels(map_labels==0) = NaN;

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
        [xu,uidx] = unique(x);
        yu = y(uidx);
        zu = z(uidx);
    tri=delaunay(xu,yu);

%% Mapping quality
    la = max(lambda);
    qua = sum(la(1:2))/sum(abs(la));
    fprintf('Mapping quality : %f\n',qua)

%% Plot
    figure  

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
        XLIM = [mx-0.1*Dx Mx+0.1*Dx];
        YLIM = [my-0.1*Dy My+0.1*Dy];
    xlim(XLIM);
    ylim(YLIM);
%     axis([mx-0.1*Dx Mx+0.1*Dx my-0.1*Dy My+0.1*Dy]) % old

    ax = gca;
    ax.FontSize = 16;
    set(gcf,'color','w')
    title([Name,' - ',num2str(round(qua,2))])
    set(gca,'DataAspectRatio',[1 1 1]);
    set(gcf, 'Position', 10+[0 0 1000 Dy*1000/Dx])
    
    % hatching
%     [X,Y] = hatch_coordinates( XLIM , YLIM ,0.05) ; %// this return coordinates to plot a hatch pattern
%     hold on
%     plot(X,Y,'k')                              %// and this simply plot the pattern, with the attributes you want (color, linespec, etc ...)
%     hold off

     % Contour and fill
    hold on
    [~,h]=tricontf(xu,yu,tri,zu);
    hold off
    set(h,'edgecolor','none');

    % Individuals
    if Step <0
    hold on
        indiv = 1:number_good;
        SCAT = scatter(x(indiv),y(indiv),35,'o','filled','MarkerFaceColor',[1,0,0]);
        SCAT.ZData = labels;
    hold off
    end
    % colormap(cmp)
    colormap(gray)
    
%% Addition
LWl = 1;
    if Step >= 0
        cycle_ind = Step+1;
        % Last operation
        last_ope = gMLC.history.facts(cycle_ind,1);
        indivs = gMLC.history.facts(cycle_ind,2:end);

        % Compute centroid if possible
        if Step>0
            % past individuals
            past_indivs = gMLC.history.facts(Step,2:end);
            %           best_indiv = gMLC.best(past_indivs);
            xpi = x(nonNaN(map_labels,past_indivs));
            ypi = y(nonNaN(map_labels,past_indivs));
            % centroid
            xc = mean(xpi);
            yc = mean(ypi);
            %           % best
            %           xbest = x(nonNaN(map_labels,best_indiv));
            %           ybest = y(nonNaN(map_labels,best_indiv));
            % individuals
            is_old = ismember(indivs,past_indivs);
            indivs_old = indivs(is_old);
            indivs_new = indivs(not(is_old));
        end

        % Which operation
        switch last_ope
            case -1
                indivs_new =  gMLC.history.facts(cycle_ind,2:end);
                indivs_old = 1:gMLC.parameters.basket_init_size;
                col_indivs = [0,0,1];
                title([Name,' - Monte Carlo'])
            case -2
                indivs_new =  gMLC.history.facts(cycle_ind,2:end);
                indivs_old = 1:gMLC.parameters.basket_init_size;
                col_indivs = 0.9*[1,1,0]; % yellow
                title([Name,' - downhill simplex initialization'])
            case 10 % centroid
                col_indivs = [0.4940 0.1840 0.5560];
                title([Name,' - centroid'])
            case 11 % reflect
                col_indivs = [1,0,1]; %magenta
                subtype = gMLC.table.individuals(indivs_new).description.subtype;
                quality = gMLC.table.individuals(indivs_new).description.quality;
                % Quality
                hold on
                leg1(1) = plot(NaN,NaN,'Linestyle','none','Marker','o','MarkerFaceColor',col_indivs,'MarkerEdgeColor',col_indivs);
                leg2(1) = {[subtype,' (',num2str(quality),')']};
                hold off
                switch subtype
                    case 'reflected'
                        parent = gMLC.table.individuals(indivs_new).description.parents;
                        title([Name,' - reflection'])
                    case 'centroid'
                        parent = gMLC.table.individuals(indivs_new+1).description.parents;
                        quality2 = gMLC.table.individuals(indivs_new+1).description.quality;
                        % Plot reflected
                        hold on
                        ScatCentroid = scatter(x(nonNaN(map_labels,indivs_new+1)),y(nonNaN(map_labels,indivs_new+1)),55,'o','MarkerEdgeColor',col_indivs,'LineWidth',1.1);
                        ScatCentroid.ZData = indivs_new+1;
                        % Quality
                        leg1(2) = plot(NaN,NaN,'Linestyle','none','Marker','o','MarkerEdgeColor',col_indivs,'LineWidth',1.1);
                        leg2(2) = {['reflected (',num2str(quality2),')']};
                        hold off
                        title([Name,' - reflection (centroid)'])
                    otherwise
                        error('Wrong subtype in reflect')
                end
                xp = x(nonNaN(map_labels,parent));
                yp = y(nonNaN(map_labels,parent));
                xpr = 2*xc-xp;
                ypr = 2*yc-yp;
                hold on
                plot([xp,xpr],[yp,ypr],'b--','LineWidth',LWl)
                ScatPs = scatter(xpr,ypr,20,'o','filled','MarkerFaceColor',[0,0,1]);
%                 ScatPs.ZData = parent;
                hold off
            case 12 % single contraction
                col_indivs = 0.9*[1,1,0]; % yellow
                subtype = gMLC.table.individuals(indivs_new).description.subtype;
                quality = gMLC.table.individuals(indivs_new).description.quality;
                % Quality
                hold on
                leg1(1) = plot(NaN,NaN,'Linestyle','none','Marker','o','MarkerFaceColor',col_indivs,'MarkerEdgeColor',col_indivs);
                leg2(1) = {[subtype,' (',num2str(quality),')']};
                hold off
                switch subtype
                    case 'contracted'
                        parent = gMLC.table.individuals(indivs_new).description.parents;
                        title([Name,' - single contraction'])
                    case 'reflected'
                        parent = gMLC.table.individuals(indivs_new+1).description.parents;
                        quality2 = gMLC.table.individuals(indivs_new+1).description.quality;
                        % plot reflected
                        hold on
                        ScatReflect = scatter(x(nonNaN(map_labels,indivs_new+1)),y(nonNaN(map_labels,indivs_new+1)),55,'o','MarkerEdgeColor',col_indivs,'LineWidth',1.1);
                        ScatReflect.ZData = indivs_new+1;
                        % Quality
                        leg1(2) = plot(NaN,NaN,'Linestyle','none','Marker','o','MarkerEdgeColor',col_indivs,'LineWidth',1.1);
                        leg2(2) = {['reflected (',num2str(quality2),')']};
                        hold off
                        title([Name,' - single contraction (reflection)'])
                    case 'centroid'
                        parent = gMLC.table.individuals(indivs_new+2).description.parents;
                        quality2 = gMLC.table.individuals(indivs_new+1).description.quality;
                        quality3 = gMLC.table.individuals(indivs_new+2).description.quality;
                        % plot reflected
                        hold on
                        ScatCentroid = scatter(x(nonNaN(map_labels,indivs_new+(1:2))),y(nonNaN(map_labels,indivs_new+(1:2))),55,'o','MarkerEdgeColor',col_indivs,'LineWidth',1.1);
                        ScatCentroid.ZData = indivs_new+(1:2);
                        % Quality
                        leg1(2) = plot(NaN,NaN,'Linestyle','none','Marker','o','MarkerEdgeColor',col_indivs,'LineWidth',1.1);
                        leg2(2) = {['reflected (',num2str(quality2),')']};
                        leg1(3) = plot(NaN,NaN,'Linestyle','none','Marker','o','MarkerEdgeColor',col_indivs,'LineWidth',1.1);
                        leg2(3) = {['single contraction (',num2str(quality3),')']};
                        hold off
                        title([Name,' - single contraction (centroid)'])
                    otherwise
                        error('Wrong subtype in single contraction')
                end
                xp = x(nonNaN(map_labels,parent));
                yp = y(nonNaN(map_labels,parent));
                xps = (1/2)*(xc+xp);
                yps = (1/2)*(yc+yp);
                hold on
                plot([xp,xps],[yp,yps],'b--','LineWidth',LWl)
                ScatPs = scatter(xps,yps,20,'o','filled','MarkerFaceColor',[0,0,1]);
%                 ScatPs.ZData = parent;
                hold off
            case 13 % expand
                col_indivs = [1,0,0]; % red
                subtype = gMLC.table.individuals(indivs_new).description.subtype;
                quality = gMLC.table.individuals(indivs_new).description.quality;
                % Quality
                hold on
                leg1(1) = plot(NaN,NaN,'Linestyle','none','Marker','o','MarkerFaceColor',col_indivs,'MarkerEdgeColor',col_indivs);
                leg2(1) = {[subtype,' (',num2str(quality),')']};
                hold off
                switch subtype
                    case 'expanded'
                        parent = gMLC.table.individuals(indivs_new).description.parents;
                        title([Name,' - expand'])
                    case 'reflected'
                        parent = gMLC.table.individuals(indivs_new+1).description.parents;
                        quality2 = gMLC.table.individuals(indivs_new+1).description.quality;
                        % plot reflected
                        hold on
                        ScatReflect = scatter(x(nonNaN(map_labels,indivs_new+1)),y(nonNaN(map_labels,indivs_new+1)),55,'o','MarkerEdgeColor',col_indivs,'LineWidth',1.1);
                        ScatReflect.ZData = indivs_new+1;
                        % Quality
                        leg1(2) = plot(NaN,NaN,'Linestyle','none','Marker','o','MarkerEdgeColor',col_indivs,'LineWidth',1.1);
                        leg2(2) = {['expanded (',num2str(quality2),')']};
                        hold off
                        title([Name,' - expand (reflection)'])
                    case 'centroid'
                        parent = gMLC.table.individuals(indivs_new+2).description.parents;
                        quality2 = gMLC.table.individuals(indivs_new+1).description.quality;
                        quality3 = gMLC.table.individuals(indivs_new+2).description.quality;
                        % plot reflected
                        hold on
                        ScatCentroid = scatter(x(nonNaN(map_labels,indivs_new+(1:2))),y(nonNaN(map_labels,indivs_new+(1:2))),55,'o','MarkerEdgeColor',col_indivs,'LineWidth',1.1);
                        ScatCentroid.ZData = indivs_new+(1:2);
                        % Quality
                        leg1(2) = plot(NaN,NaN,'Linestyle','none','Marker','o','MarkerEdgeColor',col_indivs,'LineWidth',1.1);
                        leg2(2) = {['reflected (',num2str(quality2),')']};
                        leg1(3) = plot(NaN,NaN,'Linestyle','none','Marker','o','MarkerEdgeColor',col_indivs,'LineWidth',1.1);
                        leg2(3) = {['expanded (',num2str(quality3),')']};
                        hold off
                        title([Name,' - expand (centroid)'])
                    otherwise
                        error('Wrong subtype in expand')
                end
                xp = x(nonNaN(map_labels,parent));
                yp = y(nonNaN(map_labels,parent));
                xpe = 3*xc-2*xp;
                ype = 3*yc-2*yp;
                hold on
                plot([xp,xpe],[yp,ype],'b--','LineWidth',LWl)
                ScatPs = scatter(xpe,ype,20,'o','filled','MarkerFaceColor',[0,0,1]);
%                 ScatPs.ZData = parent;
                hold off
            case 14 % shrink
                col_indivs = [0,1,0]; % green
                for p=1:length(indivs_new)
                    parent = gMLC.table.individuals(indivs_new(p)).description.parents;
                    quality = gMLC.table.individuals(indivs_new(p)).description.quality;
                    xp = x(nonNaN(map_labels,parent));
                    yp = y(nonNaN(map_labels,parent));
                    xpsk = mean(xp);
                    ypsk = mean(yp);
                    hold on
                    plot([xp(1),xpsk],[yp(1),ypsk],'b--','LineWidth',LWl)
                    scatter(xpsk,ypsk,20,'o','filled','MarkerFaceColor',[0,0,1]);
                    % Quality
                    leg1(p) = plot(NaN,NaN,'Linestyle','none','Marker','o','MarkerFaceColor',col_indivs,'MarkerEdgeColor',col_indivs);
                    leg2(p) = {['shrinked (',num2str(quality),')']};
                    hold off
                end
                title([Name,' - shrink'])
            case 21
                col_indivs = [0,1,1]; % cyan
                title([Name,' - random exploration'])
            case 22
                col_indivs = [0,1,1]; % cyan
                title([Name,' - LHS exploration'])
            case 6
                col_mutation = [0,0,0]; % mutation
                col_crossover = [0,0,1]; % crossover
                indivs_mut = NaN(BS,1);
                indivs_cros = NaN(BS,1);
                for p=1:length(indivs_new)
                    subtype = gMLC.table.individuals(indivs_new(p)).description.subtype;    
                    switch subtype
                        case 'mutation'
                            indivs_mut(p) = indivs_new(p);
                        case 'crossover'
                            indivs_cros(p) = indivs_new(p);
                    end
                end
                indivs_mut(isnan(indivs_mut))=[];
                indivs_cros(isnan(indivs_cros))=[];
                title([Name,' - evolution'])
            case {Inf,-Inf}
                return
            otherwise
                error('Wrong fact (proximity_map)');
        end

        % Plot

        % Past cycle
        if Step > 0
            hold on
            ScatPi = scatter(xpi,ypi,55,'o','MarkerEdgeColor',[0,0,1],'LineWidth',1.1);
            ScatPi.ZData = past_indivs;
            hold off
        end

        % Current cycle - old invididuals
        hold on
        labels_old = nonNaN(map_labels,indivs_old);
        labels_old(isnan(labels_old))=[];
        ScatOld = scatter(x(labels_old),y(labels_old),30,'*','blue');
        ScatOld.ZData = indivs_old;
        hold off

        % Current cycle - new invididuals
        hold on
        if last_ope==6
            labels_mut = nonNaN(map_labels,indivs_mut);
            labels_cros = nonNaN(map_labels,indivs_cros);
            ScatMut = scatter(x(labels_mut),y(labels_mut),35,'o','filled','MarkerFaceColor',col_mutation,'MarkerEdgeColor',[1,1,1]);
            ScatMut.ZData = indivs_mut;
            ScatCros = scatter(x(labels_cros),y(labels_cros),35,'o','filled','MarkerFaceColor',col_crossover);
            ScatCros.ZData = indivs_cros;
        else
            labels_new = nonNaN(map_labels,indivs_new);
            ScatNew = scatter(x(labels_new),y(labels_new),35,'o','filled','MarkerFaceColor',col_indivs);
            ScatNew.ZData = indivs_new;
        end
        hold off

        % Plot centroid
        if sum(last_ope==[10,11,12,13])
            hold on
            scatter(xc,yc,35,'^','Filled','MarkerFaceColor',[1,0,0]);
            hold off
        end

% axis
        if Step>0 && zoom
        XX = x([labels_old;labels_new]);
        YY = y([labels_old;labels_new]);
        XMIN = min(XX);
        YMIN = min(YY);
        XMAX = max(XX);
        YMAX = max(YY);
        DX = XMAX-XMIN;
        DY = YMAX-YMIN;
        DD = max(DX,DY);
        XM = xc;
        YM = yc;
        XLIM = XM+[-1.5,1.5]*DD;
        YLIM = YM+[-1.5,1.5]*DD;
        xlim(XLIM)
        ylim(YLIM)
        set(gcf, 'Position', 10+[0 0 1000 1000])
        end


%         % Legend
%         hold on
%         legend(leg1,leg2)
%         hold off
    end
end %method

function NNLabels=nonNaN(MapLabels,IDX)
NNLabels = MapLabels(IDX);
NNLabels(isnan(NNLabels))=[];
end

