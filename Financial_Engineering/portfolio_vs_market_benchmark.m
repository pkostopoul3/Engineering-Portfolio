clc
clear all

S=xlsread('XorisDeiktes2024.xlsx');
D=xlsread('MonoDeiktes2024.xlsx');

m=size(S,2); % plithos metoxon sta dedomena (arithmos stilon)

Rh=100*tick2ret(S); 
Dh=100*tick2ret(D);

[r,V]=ewstats(Rh);

c=corr(Rh);

w_minrisk=(inv(V)*ones(m,1))/(ones(1,m)*inv(V)*ones(m,1));

[Sp,Rp]=portstats(r,V,w_minrisk');

p=Portfolio('mean',r,'covar',V,'lb',0,'budget',1) %Χωρίς Ανοιχτές Πωλήσεις
w=estimateFrontier(p,10); 
[Sp,Rp]=portstats(r,V,w'); % Apodosi kai kindynos (typikis apoklisis) xartofylakion

plot(ret2tick((Rh/100)*w_minrisk,100000))
hold on
plot(ret2tick((Rh/100)*w(:,3),100000))
plot(ret2tick((Dh(:,1)/100),100000))
plot(ret2tick((Dh(:,2)/100),100000))

