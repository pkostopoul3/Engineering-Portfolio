clc
clear all

S=xlsread('XorisDeiktes2023.xlsx');

m=size(S,2); % plithos metoxon sta dedomena (arithmos stilon)
Rh=100*tick2ret(S); 

[r,V]=ewstats(Rh);

c=corr(Rh);

w_minrisk=(inv(V)*ones(m,1))/(ones(1,m)*inv(V)*ones(m,1));

[Sp,Rp]=portstats(r,V,w_minrisk');

p=Portfolio('mean',r,'covar',V,'lb',0,'budget',1) %Χωρίς Ανοιχτές Πωλήσεις
w=estimateFrontier(p,10); 
[Sp,Rp]=portstats(r,V,w'); % Apodosi kai kindynos (typikis apoklisis) xartofylakion

p1=Portfolio('mean',r,'covar',V,'lb',-1,'ub',1,'budget',1) %Ανοιχτές Πωλήσεις
w1=estimateFrontier(p1,10);
[Sp1,Rp1]=portstats(r,V,w1'); % Apodosi kai kindynos (typikis apoklisis) xartofylakion
plot(Sp,Rp,'-o',Sp1,Rp1,'-O') 
hold on
plot(sqrt(V(1,1)),r(1),'*r') % Kindynos-apodosi metoxis 1 
text(sqrt(V(1,1))+0.01,r(1)+0.01,'A1') % Data label metoxis 1 
plot(sqrt(V(2,2)),r(2),'*g') % Kindynos-apodosi metoxis 2
text(sqrt(V(2,2))+0.01,r(2)+0.01,'A2') % Data label metoxis 2
plot(sqrt(V(3,3)),r(3),'*k') % Kindynos-apodosi metoxis 3
text(sqrt(V(3,3))+0.01,r(3)+0.01,'A3') % Data label metoxis 3
plot(sqrt(V(4,4)),r(4),'*b') % Kindynos-apodosi metoxis 4 
text(sqrt(V(4,4))+0.01,r(4)+0.01,'A4') % Data label metoxis 4 
plot(sqrt(V(5,5)),r(5),'*y') % Kindynos-apodosi metoxis 5
text(sqrt(V(5,5))+0.01,r(5)+0.01,'A5') % Data label metoxis 5
plot(sqrt(V(6,6)),r(6),'*m') % Kindynos-apodosi metoxis 6
text(sqrt(V(6,6))+0.01,r(6)+0.01,'A6') % Data label metoxis 6
plot(sqrt(V(7,7)),r(7),'*c') % Kindynos-apodosi metoxis 7 
text(sqrt(V(7,7))+0.01,r(7)+0.01,'A7') % Data label metoxis 7 
plot(sqrt(V(8,8)),r(8),'*b') % Kindynos-apodosi metoxis 8
text(sqrt(V(8,8))+0.01,r(8)+0.01,'A8') % Data label metoxis 8
plot(sqrt(V(9,9)),r(9),'*r') % Kindynos-apodosi metoxis 9
text(sqrt(V(9,9))+0.01,r(9)+0.01,'A9') % Data label metoxis 9
plot(sqrt(V(10,10)),r(10),'*b') % Kindynos-apodosi metoxis 10
text(sqrt(V(10,10))+0.01,r(10)+0.01,'A10') % Data label metoxis 10
