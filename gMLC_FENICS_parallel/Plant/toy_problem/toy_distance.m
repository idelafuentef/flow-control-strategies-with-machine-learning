function [Dist1,Dist2] = toy_distance(id1,id2)
global Costs
global Actu


%% Control_laws
    % load bi
bi = Actu(:,1,id1);
%     % load bj
bj = Actu(:,1,id2);


%% Actuation distance
Dist1 = norm(bi-bj,2);

%% Cost distance |Ji-Jj|
costi = Costs(id1);
costj = Costs(id2);

Dist2 = sqrt(abs(costi-costj));
