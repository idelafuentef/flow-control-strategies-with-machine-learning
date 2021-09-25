classdef gMLCstock < handle
% gMLCstock class definition file
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Properties
properties
    labels
    evaluated % -1: not generated, 0: not evaluated, 1: evaluated
end

%% External methods
methods
    obj = generate_LHS(obj,table,parameters);
    [obj,label] = select_new_LHS_individual(obj,table,parameters);
end
%% Internal methods
methods
    % Constructor
    function obj = gMLCstock(stock_size)
        obj.labels = zeros(stock_size,1);
        obj.evaluated = -1*ones(stock_size,1);
    end
end

end %classdef
