function gMLC_basket=downhill_simplex(gMLC_basket,gMLC_table,gMLC_parameters)
% gMLCbasket downhill_simplex method
%
% No need to clear the waiting room at each step, because if we are in external evaluation,
% we need the individuals in the waiting room and if we are in an internal evaluation then
% not performing individuals won't be added to the basket. So it's ok.
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    external_interpolation = gMLC_parameters.external_interpolation;

if not(strcmp(gMLC_parameters.exploration,'none'))
	fprintf(' No coded with exploration yet\n');
    fprintf(' Exploration set to none\n');
    fprintf(' The show continues...!');
    error('no')
end

if VERBOSE > 2, fprintf('Downhill simplex\n'),end

    %% The steps
    gMLC_basket.step_ordering(gMLC_table,gMLC_parameters);
    gMLC_basket.step_centroid(gMLC_table,gMLC_parameters);
%     gMLC_basket.step_shrink(gMLC_table,gMLC_parameters);
    % The next steps depends on the resuts of the reflection/centroid step

%% Update properties
    gMLC_basket.status.evaluated = 'not evaluated';
    if external_interpolation
      gMLC_basket.status.last_operation = 'DS interpolation';
    end

if VERBOSE > 2, fprintf('Downhill simplex - End\n'),end
if VERBOSE > 2, fprintf('\n'),end

end %downhill_simplex
