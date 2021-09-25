#! /bin/bash

cd save_runs/
#ls
for typerun in {Evo,ExiEvo}
do

for typeclust in {Corr,Dist}
do 

echo  "GMFM_MLC3_${typerun}_Clust${typeclust} :"

for p in {1..12}
do
	[ -e GMFM_MLC3_${typerun}_Clust${typeclust}_${p} ]  && echo -n " $p:" && \
	ls GMFM_MLC3_${typerun}_Clust${typeclust}_${p}/Actuations/*dat |wc -l | \
	xargs -n 1 bash -c 'echo -n $0'
done #p

echo 

done #typeclust

done #typerun
	
