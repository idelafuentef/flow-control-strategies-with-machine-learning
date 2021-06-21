function pop = evaluate_pop(pop,idx_to_evaluate,MLC_parameters,MLC_table)
    % EVALUATE_POP evaluates given individuals in a population
    % The individuals to evaluate in a population are given by idx_to_evaluate.
    % The data base (table) is updated consequently.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also create_pop, evolve_pop, MLCpop.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA


indiv_to_evaluate = pop.individuals(idx_to_evaluate);

fprintf('Evaluation of generation %i :\n',pop.generation);

%% Evaluation loop
if MLC_parameters.parallel==1
    delete saved_models/test_strategy*
    delete(gcp('nocreate'));    
    parpool(MLC_parameters.numworkers);
    parfor p=1:numel(idx_to_evaluate)
        fprintf('    Evaluation of individual %i/%i',idx_to_evaluate(p),MLC_parameters.PopulationSize)
        auxind(p) = evaluate_indiv(MLC_table.individuals(indiv_to_evaluate(p)),MLC_parameters,p);
    end    
else
    delete saved_models/test_strategy*
    for p=1:numel(idx_to_evaluate)
        fprintf('    Evaluation of individual %i/%i',idx_to_evaluate(p),MLC_parameters.PopulationSize)
        auxind(p) = evaluate_indiv(MLC_table.individuals(indiv_to_evaluate(p)),MLC_parameters,p);
    end
end

%% Complete population
for p=1:numel(idx_to_evaluate)
    MLC_table.individuals(indiv_to_evaluate(p))=auxind(p);
    % population.cost update
    all_J = cell2mat(MLC_table.individuals(indiv_to_evaluate(p)).cost(:,1));
    
    % Local performance of the individual 
    switch MLC_parameters.ProblemParameters.EstimatePerformance
        case 'mean'
            J = mean(all_J);
        case 'last'
            J = all_J(end);
        case 'worst'
            J = max(all_J);
        case 'best'
            J = min(all_J);
    end
    
    pop.costs(idx_to_evaluate(p)) = J;
    MLC_table.costlist(indiv_to_evaluate(p))=J;
end

end
