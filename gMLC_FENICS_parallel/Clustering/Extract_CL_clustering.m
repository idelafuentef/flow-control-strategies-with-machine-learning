% Extract control laws for clustering
lgpc.load('Gen50');
gen = lgpc.generation;
%% Parameters
    pop_size = lgpc.parameters.PopulationSize;
    NbCP = lgpc.parameters.number_evaluation_points;
    NbC = lgpc.parameters.ProblemParameters.OutputNumber;

%% Allocation
    Data = zeros(gen*pop_size,NbCP*NbC);
    Indivs = zeros(gen*pop_size,1);
    
%% Loop
    counter = 1;
    for p=1:gen
        for q=1:pop_size
            Indivs(counter) = lgpc.population(p).individuals(q);
            Data(counter,:) = lgpc.table.individuals(Indivs(counter)).ControlPoints;
            counter = counter +1;
        end
    end
    
%% Save
save('Clustering/Data.dat','Data','-ascii')
save('Clustering/Indivs.dat','Indivs','-ascii')