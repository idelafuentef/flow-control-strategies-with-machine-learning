function after_REC_EXE(gMLC)
% gMLC class continue_reflection method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    cycle = gMLC.history.cycle;
    Name = gMLC.parameters.Name;
    basketcycle = gMLC.basket.status.cycle;

%% Continue ?
    % waiting costs
    waiting_costs = gMLC.basket.waiting_room.costs;
    costs = gMLC.basket.costs;
    % Jr Jc ...
    Jr = waiting_costs(1);
    Jc = waiting_costs(3);
    Jend_minus_one = costs(end-1);
    Jend = costs(end);
    
    % continue
    if (Jr >= Jend_minus_one) && (Jc >= Jend)
            % shrink
            fprintf('Continue with shrink\n')
	    fclose(fopen(['save_runs/',Name,'/ContinueShrink',num2str(basketcycle+1)], 'w'));
    else
            fprintf('Continue with REC\n')
            gMLC.basket.waiting_room.labels(4:end)=[];
            gMLC.basket.waiting_room.costs(4:end)=[];
   end
            
%% Update
    gMLC.basket.status.last_operation = 'REC';

end %method
