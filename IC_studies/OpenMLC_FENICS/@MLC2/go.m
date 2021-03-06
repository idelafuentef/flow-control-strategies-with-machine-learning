function mlc=go(mlc,ngen,figs)
% GO start MLC2 problem solving (MLC2 Toolbox)
%   OBJ.GO(N) creates (if necessary) the population, evaluate and evolve it
%       until N evaluated generations are obtained.
%   OBJ.GO(N,1) additionaly displays the best individual if implemented in
%       the evaluation function at the end of each generation evaluation
%   OBJ.GO(N,2) additionaly displays the convergence graph at the end of
%       each generation evaluation
%% Reinitialize go.
try
    rng('shuffle'); % Official recommended seed shuffling
catch %% take into account versions problems
    rand('seed',sum(100*clock)); % Old school deprecated seed shuffling
end
%% Solve the problem
    if nargin<3 %if number of input arguments is 1 or 2
        figs=0;
    end
    
    if nargin<2
        fprintf('Please provide an integer number of generations you want to compute\n')
        fprintf('ex: mlc=MLC2; mlc.go(15)\n')
        return
    end
    if ngen~=round(ngen)
        fprintf('Once you tell me how I can compute %f generations, I''ll consider doing it\n',ngen)
        fprintf('Please provide an integer, stupid!\n');
        return
    end
    curgen=length(mlc.population);
    if curgen==0 %% population is empty, we have to create it
        mlc.generate_population;
        curgen=1; %current generation
    end
    while curgen<=ngen %% if current generation is lower
        switch mlc.population(curgen).state
            case 'init'
                if curgen==1
                    mlc.generate_population;
                else     %% unlikely CHECK THIS.
                    mlc.evolve_population;
                end
            case 'created'
                if mlc.parameters.save==1
                    save(fullfile(mlc.parameters.savedir,'mlc_be.mat'),'mlc')
                end
                    mlc.evaluate_population;
                if mlc.parameters.save==1
                    save(fullfile(mlc.parameters.savedir,'mlc_ae.mat'),'mlc')
                end
            case 'evaluated'
                mlc.stats;
                curgen=curgen+1; 
                if figs>0
                    mlc.show_best;
                    drawnow;
                end
                if figs>1
                    mlc.show_convergence;
                    drawnow;
                end
                if curgen<=ngen
                    mlc.evolve_population;
                end     
        end

    end
end










