function gMLC_basket_copy=copy(gMLC_basket,gMLC_parameters)
% gMLC class copy method
% Makes a copy of the basket
%
% Guy Y. Cornejo Maceda, 11/14/2019
%
% See also SIN, COS, TheOtherFunction.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
%     VERBOSE = gMLC.parameters.verbose;

%% Initialization
    gMLC_basket_copy = gMLCbasket(gMLC_parameters);

%% Transfer properties
    prop = properties(gMLC_basket);
    for p=1:length(prop)
        new_prop = get(gMLC_basket,prop{p});
        set(gMLC_basket_copy,prop{p},new_prop);
    end

end %method
