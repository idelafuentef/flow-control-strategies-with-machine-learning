function export_proxi_map(gMLC)
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    Name = gMLC.parameters.Name;
    NSteps = size(gMLC.history.facts,1);
    zoom = gMLC.parameters.zoom;
    % no figure
    set(0,'DefaultFigureVisible','off');

%% Print all individuals
        fig_Name = ['save_runs/',Name,'/Figures/Proximity_map/All.png'];
        if not(exist(fig_Name,'file'))
            fprintf('Print all\n')
            gMLC.proximity_map;
            print(fig_Name,'-dpng')
        end

%% Print the cycles
    for p=0:(NSteps-1)
        if zoom
            fig_Name = ['save_runs/',Name,'/Figures/Proximity_map/C',num2str(p),'_z.png'];
        else
            fig_Name = ['save_runs/',Name,'/Figures/Proximity_map/C',num2str(p),'.png'];
        end
        if not(exist(fig_Name,'file'))
            fprintf('Print cycle %i\n',p)
            gMLC.proximity_map(p);
            print(fig_Name,'-dpng')
        end
        close
    end
    
% %% Print projection
%         fig_Name = ['save_runs/',Name,'/Figures/Proximity_map/VIP_projection.png'];
%         if not(exist(fig_Name,'file'))
%             fprintf('Print projection\n')
%             gMLC.project_VIP;
%             print(fig_Name,'-dpng')
%         end
        
    % yes figure
    set(0,'DefaultFigureVisible','on');
end %method
