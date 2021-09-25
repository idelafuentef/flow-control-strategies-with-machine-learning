function show_problem(gMLC)
% gMLC class show_problem method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Initialization
param = gMLC.parameters;

%% Borders
fprintf('===========================')
fprintf('===========================\n')
% Plot
fprintf(['Name : ',param.Name,'\n'])
fprintf('\n')
fprintf(['Problem to solve : ',param.problem,'\n'])
fprintf(['   Number of actuators : ',num2str(param.ProblemParameters.OutputNumber),'\n'])
fprintf(['   Number of sensors : ',num2str(param.ProblemParameters.InputNumber),'\n'])
fprintf('\n')
fprintf('Parameters : \n')
fprintf([' Basket size : ',num2str(param.basket_size),'\n'])
fprintf([' Initial basket size : ',num2str(param.basket_init_size),'\n'])
fprintf([' Stock size : ',num2str(param.stock_size),'\n'])
fprintf([' Stopping criterion : ',param.criterion])
if strcmp(param.criterion,'number of evaluations')
    fprintf([' (',num2str(param.number_of_evaluations),')'])
end
fprintf('\n')
fprintf('\n')
fprintf('Strategy : \n')
fprintf([' Initialialization : ',param.initialization,'\n'])
fprintf([' Exploitation : ',param.exploitation,'\n'])
fprintf([' Exploration : ',param.exploration,'\n'])
fprintf([' Evolution : ',num2str(param.evolution),'\n'])
% Plot
fprintf('\n')
gMLC.show(0);

%% Borders
fprintf('===========================')
fprintf('===========================\n')
end %method
