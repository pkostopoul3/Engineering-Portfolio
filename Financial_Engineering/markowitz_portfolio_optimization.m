clc
clear all

S=xlsread('MeDeiktes2023.xlsx');

m=size(S,2); % plithos metoxon sta dedomena (arithmos stilon)
Rh=100*tick2ret(S); 

[r,V]=ewstats(Rh)

c=corr(Rh)

w_minrisk=(inv(V)*ones(m,1))/(ones(1,m)*inv(V)*ones(m,1));

[Sp,Rp]=portstats(r,V,w_minrisk');

p=Portfolio('mean',r,'covar',V,'lb',0,'budget',1); 
w=estimateFrontier(p,10); 
[Sp,Rp]=portstats(r,V,w'); % Apodosi kai kindynos (typikis apoklisis) xartofylakion

