% Correlation Clustering test
%
% Guy Y. Cornejo Maceda, 08/27/209


% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
cmp = load('gMLC_tools/CMP_RWB.mat');


%% Signals
T = 2*pi;
Time = 0:0.001:10*T;
delays = 0:0.01:1;
Signals = NaN(length(delays),length(Time));
cmpt = 1;
for p=0:0.01:1
    Signals(cmpt,:) = cos(Time+p*T);
    cmpt = cmpt+1;
end
NS = size(Signals,1);
N = length(Time);

% plot
figure
plot(Time,Signals,'LineWidth',2);
axis tight

%% Correlation coefficients
R = corrcoef(transpose(Signals));
% plot
figure,
imagesc(R)
colorbar
colormap(cmp.cmp)
caxis([-1,1])

%% Clustering - signals
%     classes1 = kmeans(Signals,3,'Replicates',100,'MaxIter',100);
%     % Plot
%     figure,
%     hold on
%     for p=1:3
%         plot(p,delays(classes1==p),'*');
%     end
%     title('Clustering signals')

%% Clustering - Correlation matrix
    [classes2,centers] = kmeans(R,2,'Replicates',100,'MaxIter',100);
    % Plot
    figure,
    hold on
    for p=1:3
        plot(p,delays(classes2==p),'*');
    end
    title('Clustering correlation matrix')
    
%% Compute shifted signals
    % Number of steps
% [~,NT] = min(abs(Time-T));
    
%% Correlation and Covariance as a function of tau (delay)
% % tau = round(0.25*NT);
% tau = 0;
% 
% CorrMat = ones(NS,NS);
% 
%     % Shift
%     xS = Signals(:,(1+tau):(end-NT+tau));
%     yS = Signals(:,(1+NT):end);
%     N = size(yS,2);
%     % Covariance
%     for p=1:(NS*(NS-1)/2)
%         [s1,s2] = v(p);
%         xSS = xS(s1,:);
%         ySS = yS(s2,:);
%         CorrMat(s1,s2) = (1/(N-1)) * ...
%     sum( (xSS-mean(xSS)).*(ySS-mean(ySS)) ) / ...
%     ( std(xSS)*std(ySS) );
%         CorrMat(s2,s1) = CorrMat(s1,s2);
%     end
%     
% % plot
% figure,
% imagesc(CorrMat)
% colorbar
% cmp = load('gMLC_tools/CMP_RWB.mat');
% colormap(cmp.cmp)
% caxis([-1,1])



%% Covariance test
%     xSS = xS(1,:);
%     ySS = yS(2,:);
%     XX = [xSS',ySS'];
%     N = size(XX,1);
%     
%     % 1. cov function
%     C1 = cov(xSS,ySS);
%     C2 = cov(XX);
%     
%     % 2. my code
%     C3 = (1/(N-1)) * sum( (xSS-mean(xSS)).*(ySS-mean(ySS)) );
%     c4 = XX - sum(XX,1)/N;
%     C4 = (1/(N-1)) * (c4' * c4);
%     
 %% Correlation test
%     Cr1 = corrcoef(XX);
%     Cr2 = C4/std(xSS)/std(ySS);