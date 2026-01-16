clear all
clc

syms s

Gp=(150*(s+1))/((s+3)*(s+4)*(s+5));
Gm=1/(s+1);
Gv=2/(s+2);
Kc=1;
Gc=Kc;

G_open_loop=Gp*Gm*Gv*Gc;
G_open_loop=simplifyFraction(G_open_loop)
[num,den]=numden(G_open_loop)
num=sym2poly(num);
den=sym2poly(den);

G_root_locus=tf(num,den)
Kcr=margin(G_root_locus)
figure(1);rlocus(G_root_locus)