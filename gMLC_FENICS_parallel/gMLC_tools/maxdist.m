function [furthest,Dist_mat]=maxdist(set1,set2)
%  maxdist function
%
% set1 and set2 are two n1xN, n2XN matrices containing informations of n1,n2 points.
% maxdist compares the distance to these points and gives back the element in set1 that
% is the most far from set2.
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
  n1 = size(set1,1);
  n2 = size(set2,1);

%% Initialization
  Dist_mat = inf(n1,n2); %size ?

%% Compute distances
  for p=1:n1
    for q=1:n2
      D = CP_distance(set1(p,:),set2(q,:));
      Dist_mat(p,q) = D;
    end
  end

Dist_to_set2 = min(Dist_mat,[],2);
[~,furthest] = max(Dist_to_set2);

end
