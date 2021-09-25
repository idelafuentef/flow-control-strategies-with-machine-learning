function mlc=evaluate_population(mlc,n)
% EVALUATE_POPULATION evolves the population. (MLC2 Toolbox)
%
% OBJ.EVALUATE_POPULATION launches the evaluation method, and updates the 
%    MLC2 object.
%
%   The evaluation algorithm is implemented in the <a href="matlab:help MLCpop">MLCpop</a> class.
%
%   See also MLCPARAMETERS, MLCPOP 
if nargin<2
   n=length(mlc.population); % starting from a different generation is 
                             % a dev option, thus undocumented.
                             % it can possibly break the object
                             % interpretation or functioning.
end

%% first evaluation
idx=1:length(mlc.population(n).individuals);
[mlc.population(n),mlc.table]=mlc.population(n).evaluate(mlc.table,mlc.parameters,idx);

%% remove bad individuals
elim=0;
switch mlc.parameters.badvalues_elim
    case 'first'
        if n==1
            elim=1;
        end
    case 'all'
        elim=1;
end

if elim==1
    [mlc.population(n),idx]=mlc.population(n).remove_bad_indivs(mlc.parameters);
    while ~isempty(idx)
        [mlc.population(n),mlc.table]=mlc.population(n).create(mlc.parameters,mlc.table);
        [mlc.population(n),mlc.table]=mlc.population(n).evaluate(mlc.table,mlc.parameters,idx);
        [mlc.population(n),idx]=mlc.population(n).remove_bad_indivs(mlc.parameters);
    end
end

%% Sort population
mlc.population(n).sort(mlc.parameters);

%% Enforced Re-evaluation
if mlc.parameters.ev_again_best
    disp('Reevaluating best individuals')
    for i=1:mlc.parameters.ev_again_times
        idx=1:mlc.parameters.ev_again_nb;
        mlc.parameters.problem_variables.eval_steps=4000+i*2000;
        mlc.parameters.problem_variables.subeval_steps=666+i*2000;
        [mlc.population(n),mlc.table]=mlc.population(n).evaluate(mlc.table,mlc.parameters,idx);
        mlc.population(n).sort(mlc.parameters);
    end
    mlc.parameters.problem_variables.eval_steps=4000;
    mlc.parameters.problem_variables.subeval_steps=666;
end
mlc.population(n).state='evaluated';
end