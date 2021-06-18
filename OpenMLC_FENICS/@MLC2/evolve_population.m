function mlc=evolve_population(mlc,n)
% EVOLVE_POPULATION evolves the population. (MLC2 Toolbox)
%
% OBJ.EVOLVE_POPULATION updates the OBJ MLC2 object with a new MLCpop object
%     in the OBJ.POPULATION array containing the evolved population                   
%
%   The evolution algorithm is implemented in the <a href="matlab:help MLCpop">MLCpop</a> class.
%
%   See also MLCPARAMETERS, MLCPOP
if nargin<2
        n=length(mlc.population);

end
    [mlc.population(n+1),mlc.table]=mlc.population(n).evolve(mlc.parameters,mlc.table);
    
%% Remove duplicates
if mlc.parameters.lookforduplicates
    mlc.population(n+1).remove_duplicates;
    idx=find(mlc.population(n+1).individuals==-1);
    while ~isempty(idx)
            [mlc.population(n+1),mlc.table]=mlc.population(n).evolve(mlc.parameters,mlc.table,mlc.population(n+1));
            mlc.population(n+1).remove_duplicates;
            idx=find(mlc.population(n+1).individuals==-1);
    end
end
mlc.population(n+1).state='created';
end
    
    
    










