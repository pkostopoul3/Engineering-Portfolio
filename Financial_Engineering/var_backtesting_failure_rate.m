clc
clear all

S=xlsread('FullXorisDeiktes.xlsx'); % Diavasma dedomenon

alpha=0.05; % Epipedo simantikotitas (1-epipedo empistosynis)
Rh=100*tick2ret(S); % Ypologismos apodoseon (ws %)
T=size(Rh,1); % Plithos imeron sta dedomena

w=[0
0
0
0.0644835750509939
0.209841622971225
0.157462703621528
0.189967441827739
0
0.104582670582045
0.273661985946476]'; % Synthesi xartofylakiou

Rh=[Rh Rh*w']; % Ensomatosi ton imerision apodoseon tou xartofylakiou ston pinaka ton istorikon apodoseon (4h stili)

for t=181:T % Gia kathe imera meta tin imera 250
    [r,V]=ewstats(Rh(t-180:t-1,1:10)); % Ypologismos statistikon apo tis proigoumenes 250 imeres 
    [Sp,Rp]=portstats(r,V,w); % Apodosi kai kindynos xartofylakiou
    ValueAtRisk(t-180,:) = portvrisk([r Rp],[sqrt(diag(V))' Sp],alpha); % Ypologismos apolytis VaR se epipedo (1-a)% me tin analytiki proseggisi
    ValueAtRisk_HS(t-180,:) = -prctile(Rh(t-180:t-1,:),alpha*100); % Ypologismos apolytis VaR se epipedo (1-a)% me istoriki prosomoiosi
end

A = sum((Rh(181:end,3)) < -ValueAtRisk(:,11))
B = sum((Rh(181:end,3)) < -ValueAtRisk_HS(:,11))

Astoxia_ValueAtRisk = A/393
Astoxia_ValueAtRisk_HS = B/393