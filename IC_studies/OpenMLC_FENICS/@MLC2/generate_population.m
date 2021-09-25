function mlc=generate_population(mlc)
% GENERATE_POPULATION initializes the population. (MLC2 Toolbox)
%
% OBJ.GENERATE_POPULATION updates the OBJ MLC2 object with an initial population 
%
% The function creates an object defining the population and launch its 
% creation method according to the OBJ.PARAMETERS content.
% The creation algorithm is implemented in the class.
%
%   See also MLCPARAMETERS, MLCPOP
if isempty(mlc.population)
    mlc.population=MLCpop(mlc.parameters);
end
if isempty(mlc.table)
    [mlc.population(1),mlc.table]=mlc.population.create(mlc.parameters);
else
    [mlc.population(1),mlc.table]=mlc.population.create(mlc.parameters,mlc.table);
end
mlc.population(1).state='created';
end









