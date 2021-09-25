% Test clustering
%
% Guy Y. Cornejo Maceda, 08/27/209


% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

 %% Initilization
 A=rand(2,2);
%  Col = [1,0,0;...
%      0,1,0;...
%      0,0,1;...
%      1,1,0;...
%      0,1,1;...
%      1,0,1];
Col=jet(6);
 k=3;
 
 
 %% Clustering
%  [belongs,c,iter] = kmeans (A, k, "emptyaction", "singleton");
 [belongs,c,iter,rep] = kmeans (A, k, 'Replicates',100,'MaxIter',100);

 %% Visualization
figure,
 hold on
 for p=1:k
 plot(c(p,1),c(p,2),'^','MarkerFaceColor',Col(p,:),'MarkerEdgeColor',[0,0,0])
 bel=(belongs==p);
 % Convex Hull
    Ab = A(bel,:);
%     CH = convhull(Ab);
%     patch(Ab(CH,1),Ab(CH,2),Col(p,:),'FaceAlpha',.05,'EdgeColor',Col(p,:),'LineWidth',2);

 end
 
 % Data
  plot(A(:,1),A(:,2),'k*')
hold off

box on

%% Comparison centroid
fprintf('Number of iteration is %i\n',iter)
fprintf('Best replication is %i\n',rep)
figure,plot(belongs)
