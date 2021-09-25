function export_proxi_map_prior(gMLC)
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    Name = gMLC.parameters.Name;
    Ncycle = gMLC.history.cycle;
    % no figure
    set(0,'DefaultFigureVisible','off');

%% Print all individuals
        fig_Name = ['save_runs/',Name,'/Figures/Proximity_map/prior/All_prior.png'];
        if not(exist(fig_Name,'file'))
            fprintf('Print all\n')
            gMLC.proximity_map_prior;
            print(fig_Name,'-dpng')
        end

%% Print the cycles
    for p=0:Ncycle
        fig_Name = ['save_runs/',Name,'/Figures/Proximity_map/prior/C',num2str(p),'_prior.png'];
        if not(exist(fig_Name,'file'))
            fprintf('Print cycle %i\n',p)
            gMLC.proximity_map_prior(p);
            print(fig_Name,'-dpng')
        end
        close
    end
    
%% Print projection
        fig_Name = ['save_runs/',Name,'/Figures/Proximity_map/prior/VIP_projection.png'];
        if not(exist(fig_Name,'file'))
            fprintf('Print projection\n')
            gMLC.project_VIP;
            print(fig_Name,'-dpng')
        end
        
    % yes figure
    set(0,'DefaultFigureVisible','on');
end %method
