function gMLC_basket=substitute_LGP(gMLC_basket,gMLC_table,gMLC_parameters)
% gMLC class substitute_LGP method
% Goes through the basket. If there are 'coef DS' type individuals then LGP substitute
% are computed.
%
% Guy Y. Cornejo Maceda, 08/27/209
%
% See also SIN, COS, TheOtherFunction.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    evolution = gMLC_parameters.evolution;
    
%% Find the individuals to be replaced
    labels = gMLC_basket.labels;
    TO_SUBSTITUTE = [];
    TO_SUBSTITUTE_BOOL= false(length(labels),1);
    TO_EVALUATE = [];
    for p=1:length(labels)
        gMLC_ind = gMLC_table.individuals(labels(p));
        SubsTest = strcmp(gMLC_ind.description.type,'coef DS') && ...
            isempty(gMLC_ind.description.miscellaneous);
      if SubsTest
        TO_SUBSTITUTE = [TO_SUBSTITUTE,labels(p)];
        TO_SUBSTITUTE_BOOL(p) = true;
      end
    end
%% Do we do numerical interpolation?
    if not(evolution)||isempty(TO_SUBSTITUTE),return,end
      if VERBOSE > 0, fprintf('Compute substitute for coefficient interpolated individuals\n'),end


%% Ersatz it
        TO_EVALUATE = computesubstitute(TO_SUBSTITUTE,gMLC_table,gMLC_parameters);

%% Evaluate
  % We do not evaluate the interpolated individuals. We hope the individuals are
  % good enough and report the cost of the original individual.
  % Those individuals have a 0 value in the gMLCtable.evaluated table.
    gMLC_table.evaluated(TO_EVALUATE)=0;

%% Update properties
    gMLC_basket.labels(TO_SUBSTITUTE_BOOL) = TO_EVALUATE;
    gMLC_basket.status.evaluated = 'substituted';
    gMLC_basket.status.individuals_to_evaluate = [];

    if VERBOSE > 0, fprintf('Done.\n'),end

end %method
