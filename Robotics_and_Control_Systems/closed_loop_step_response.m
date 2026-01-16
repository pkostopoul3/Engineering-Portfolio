clear all
clc

syms s

Gp=(150*(s+1))/((s+3)*(s+4)*(s+5));
Gm=1/(s+1);
Kc=1.8;
Gc=Kc;
Gv=2/(s+2);
Gd1=100/(s+4);
Gd2=10/(s+10);

Ysp=1/s;

Y=(Gp*Gc*Gv/(1+Gp*Gc*Gm*Gv))*Ysp;
y=ilaplace(Y);

Total_Time=5;
t=0:0.1:Total_Time;

y=subs(y,t);
y=double(y);
ysp1=ilaplace(Ysp);
ysp1=subs(ysp1,t);
ysp1=double(ysp1);

ysp=ysp1;
figure(1);plot(t,y,t,ysp,'--');xlabel('time, sec');ylabel('y(t)')
