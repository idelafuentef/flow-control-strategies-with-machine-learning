% Extract best cost and learning curve from several mlc runs
%
% Guy Y. Cornejo Maceda, 08/27/209


% Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
    NRuns = 10;
    Runs = 1:NRuns;
    NGen = 10;
    PopSize = 100;
    NEvaluations = 1000;

%% Cost without actuation
    J0 = 0.1000;
    
%% Allocation
    LearningCurve = zeros(NRuns,NEvaluations);
    % Initialization J0
    
%% Loop over the runs
    for run=1:NRuns
        mlc.load(['GMFM_MLC_',num2str(run)]);
        [x,y] = mlc.convergence(0);
        y(x>NEvaluations)=[];
        x(x>NEvaluations)=[];Nx=length(x);
        [x,idx]=unique(flip(x));x=flip(x);
        y=y(Nx-idx+1);
        LearningCurve(run,x)=1;
        LearningCurve(run,:)=cumsum(LearningCurve(run,:));
        for p=1:length(x)
            LearningCurve(run,(LearningCurve(run,:)==p))=y(p);
        end
    end
    
%% Save
save('Analysis/Figures/MedianMLCCurve','LearningCurve');

%% Compute mean, median, std
MEAN = mean(LearningCurve(:,end))
MEDIAN = median(LearningCurve(:,end))
STD = std(LearningCurve(:,end))
% 
% MEAN =
%     0.0016
% MEDIAN =
%     0.0017
% STD =
%    5.9924e-04


%% Compute PI
% PI = zeros(numel(Runs),1);
% PIruns = cell(numel(Runs),1);
%  for run=1%Runs
%     PIrun = zeros(NGen+1,2);
%     for p=1:NGen
%         PIrun(p,1) = p>1;
%         PIrun(p,2) = mean(mlc.population(p).costs);
%     end
%         PIrun(NGen+1,1) = inf;
%         PIrun(NGen+1,2) = mlc.population(end).costs(1);
%         
%     % PI
%     PI(run) = mean(PIrun(1:end-1,2)) + PIrun(end,2);
%     PIruns{run} = PIrun;
%  end
%      
%      % Print
%      fprintf('MEAN PI = %f\n',mean(PI));
%      fprintf('STD PI = %f\n',std(PI));
%      fprintf('MEDIAN PI = %f\n',median(PI));
%      
% % save
% save('Analysis/Figures/PIsMLC','PIruns');
 
%% Compute Metric
% Metric = zeros(numel(Runs),2);
%  for run=Runs
%         mlc.load(['GMFM_MLC_',num2str(run)]);
%     Metric(run,1) = mlc.population(end).costs(1)/J0;
%     Metric(run,2) = trapz(100*IdxLearningC,TrueLearningC(run,:))/J0;
%  end
% % save
% save('Analysis/Figures/MetricMLC','Metric');


%% median run
bestJ = LearningCurve(:,end);
[bestJ_sorted,idx] = sort(bestJ);
median_run = idx(5);
fprintf('median run: %i\n',median_run);
fprintf('median cost %f\n',bestJ_sorted(5));
% load
mlc.load(['GMFM_MLC_',num2str(median_run)]);
mlc.convergence;
% mlc.best_individidual;


%% Options
Cgrey = 0.75*[1,1,1];
LV = 1e-4;
HV = 3e-1;
% Steps color
    MC = [1,0,0];
    Evo = [0,0,1];
    ClustEvo = [0,0.5,1];
    Simplex = [1,1,0];
    SimplexEvo = [0,1,0];

% Plot
figure
set(gcf,'position',[0,0,600,1000])

% Data
TrueLearningC;
[~,rk] = sort(TrueLearningC(:,end));
TrueLearningC = TrueLearningC(rk,:);

for p=1:10
    subplot(10,1,p)
    hold on
    % Steps
    patch([0,100,100,0],[LV,LV,HV,HV],MC,'EdgeColor','none')
    patch([100,1000,1000,100],[LV,LV,HV,HV],Evo,'EdgeColor','none')
    alpha(0.2)
    % Plots
    
    plot(100*IdxLearningC,TrueLearningC,'-','Color',Cgrey,'LineWidth',2) % AllMLC3
    plot(100*IdxLearningC,TrueLearningC(p,:),'b-','LineWidth',2); % AllMLC3
    hold off
    set(gca,'YScale','log')
    axis([0,1000,2e-4,2e-1])
    xticks(0:100:1000)
    xticklabels([])
    ylabel('$J$','Interpreter','Latex')
    grid on
    box on
    
    text(50,7e-2,'MC','FontSize',7,'HorizontalAlignment','center')
    text(550,7e-2,'Evolution','FontSize',7,'HorizontalAlignment','center')
end

subplot(10,1,10)
xticks(0:100:1000)
xticklabels(0:100:1000)
xlabel('Evaluation','Interpreter','Latex')

% print(['Figures/',MLC3name{MLC3Type},'_learning'],'-dpng')
% close

