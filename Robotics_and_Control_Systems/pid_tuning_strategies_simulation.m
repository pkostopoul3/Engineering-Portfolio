clear all
clc

syms s t

Gp=(150*(s+1))/((s+3)*(s+4)*(s+5));
Gm=1/(s+1);
Gv=2/(s+2);
Gd1=100/(s+4);
Gd2=10/(s+10);

Kcr=1.8;
Pcr=1.9;

% Ελεγκτές
Gc1 = 0.5*Kcr;                                 % P Ziegler Nichols
Gc2 = 0.45*Kcr*(1+(1/(1.2*Pcr*s)));            % PI Ziegler Nichols
Gc3 = 0.6*Kcr*(1+(1/(0.5*Pcr*s))+0.125*Pcr);   % PID Ziegler Nichols

Gc4 = (Kcr/3.2)*(1+(2.2*Pcr));                 %PI Tyreus Luyben
Gc5 = (Kcr/2.2)*(1+(2.2*Pcr)+(Pcr/6.3));       %PID Tyreus Luyben

% Σήματα Αναφοράς, Ysp | Διαταραχή d1/d2 
% Δ1
Ysp1 = 10*heaviside(t);
D1_1 = 2*heaviside(t);
D2_1 = 0.5*heaviside(t);

% Δ2
Ysp2 = 10*heaviside(t) + 5*heaviside(t-50) + 3*heaviside(t-100) - 2*heaviside(t-150) - 6*heaviside(t-200);
D1_2 = 2*heaviside(t) - 2*heaviside(t-75) + 0.8*heaviside(t-125);
D2_2 = 0.5*heaviside(t) + 1.5*heaviside(t-175);

%Αλλαγή Δεδομένων (Ελεγκτές, Σήματα Αναφοράς{Ysp})
Ysp=laplace(Ysp2);
Gc=Gc5;
D1=laplace(D1_2);
D2=laplace(D2_2);

step=1;
Total_Time=250;
t=0:step:Total_Time;

Y=(Gp*Gc*Gv/(1+Gp*Gc*Gm*Gv))*Ysp + (Gd1/(1+Gp*Gc*Gm*Gv))*D1 + (Gd2/(1+Gp*Gc*Gm*Gv))*D2;
E=Ysp-Y*Gm;
U=Gc*E;

y=ilaplace(Y);
u=ilaplace(U);
E=ilaplace(E);

y=vpa(y);
y=subs(y,t);
y=double(y);

u=vpa(u);
u=subs(u,t);
u=double(u);

E=vpa(E);
E=subs(E,t);
E=double(E);

ysp1=ilaplace(Ysp);
ysp1=subs(ysp1,t);
ysp1=double(ysp1);
ysp=ysp1;

d1 = ilaplace(D1);
d1 = subs(d1, t);
d1 = double(d1);

d2 = ilaplace(D2);
d2 = subs(d2, t);
d2 = double(d2);

figure(1);plot(t,y,t,ysp,'--');xlabel('time, sec');ylabel('y(t)')
figure(2); plot(t,u);xlabel('time, sec'); ylabel('u(t)');
figure(3); plot(t,d1,t,d2,'--');xlabel('time, sec'); ylabel('d1(t), d2(t)');
figure(4); plot(t,E);xlabel('time, sec'); ylabel('error(t)');

Total_Error=sum(abs(E))
Total_U=sum(abs(u(2:Total_Time/step)))