classdef MLC2 < handle
% MLC2 constructor of the Machine Learning Control 2 class.
%   The MLC2 class is a handle class that implements  
%   a machine learning control problem
%
%   OBJ_MLC=MLC2 implements a new MLC problem using default options
%   OBJ_MLC=MLC2('FILENAME') implements a MLC problem using options
%   defined in M-file FILENAME.
%
%   Ex:
%   mlc=MLC2;mlc.go(3); % computes 3 generations for the default problem.
%   mlc=MLC2;mlc.go(13,1); % computes 13 generations for the default problem
%   with graphical output.
%   TOY2=MLC('toy2_cfg');TOY2.go(2) % computes 2 generations of the problem
%   defined in toy2_cfg.m file.
%   mlc.show_ind(n) shows the n individual
%   mlc.show_best shows the best individual
%
%   MLC2 properties:
%      table        - %contains the individual database as an object.
%      population   - %contains one object per generation.
%      parameters   - %contains the parameters as an object.
%      version      - %current version of MLC2.
%
%   MLC2 methods:
%      generate_population  -  %generate the initial population. 
%      evaluate_population  -  %evaluate current unevaluated population.
%      evolve_population    -  %evolve current evaluated population.
%      go                   -  %automatize generation evaluation and evolution.
%      genealogy            -  %draws the genealogy of the individuals.
%      show_best            -  %returns and shows the best individual.
%      show_convergence     -  %show the repartition of the population costs.
%
%   See also MLCPARAMETERS, MLCTABLE, MLCPOP, MLCIND
 
    properties
        table           %contains the individual database as an object.
        population      %contains one object per generation.
        parameters      %contains the parameters as an object.
        version         %current version of MLC2.
    end
    
    methods
        obj=generate_population(obj);   %generate the initial population. 
        obj=evaluate_population(obj,n); %evaluate current unevaluated population.
        obj=evolve_population(obj,n);   %evolve current evaluated population.
        obj=go(obj,n,figs);             %automatize generation evaluation and evolution.
        genealogy(obj,ngen,idv);        %draws the genealogy of the individuals.
        m=show_best(obj,fig);           %returns and shows the best individual.
        [m,J]=show_ind(obj,n,gen);
        show_convergence(obj,nhisto,Jmin,Jmax,linlog,sat,gen_range,axis);%show the repartition of the population costs.
        obj=insert_individual(obj,idv);
        createScript(obj,scriptname);
        disp(obj);
        stats(obj,nb);
        function obj=MLC2(varargin)
            vers = '0.2.5';
            obj.table=[];
            obj.population=[];
            obj.parameters=MLCparameters(varargin{:});
            obj.parameters.opset=opset(obj.parameters.opsetrange);
            obj.version=vers;
        end
    end
end