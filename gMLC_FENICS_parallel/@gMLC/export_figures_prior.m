function export_figures_prior(gMLC)
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    Name = gMLC.parameters.Name;
    % no figure
    set(0,'DefaultFigureVisible','off');

%% Print proximity map prior
    gMLC.export_proxi_map_prior;

%% Print control law
    % find best control law
        % Best individual
        labels = gMLC.basket.labels;
        costs = gMLC.basket.costs;
        % Sort
        [~,idx] = min(costs);
        ID = labels(idx);
    fig_Name = ['save_runs/',Name,'/Figures/ID',num2str(ID),'.png'];
    fprintf('Print control law \n')
    gMLC.show;
    print(fig_Name,'-dpng')
    close
    
%% Print progress
    fig_Name = ['save_runs/',Name,'/Figures/progress.png'];
    fprintf('Print control law \n')
    gMLC.plot_progress;
    print(fig_Name,'-dpng')
    close
        
    % yes figure
    set(0,'DefaultFigureVisible','on');
end %method
