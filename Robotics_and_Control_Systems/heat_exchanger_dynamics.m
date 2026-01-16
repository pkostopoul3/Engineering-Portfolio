function [dx] = heat_exchanger_dynamics(Time, x)
%Based on Lesson 2 (Tank Height and Tank Temperature DynamicModeling/Differential Equations)

%Parameters
Vhot=40;        %lt
Vcold=10;       %lt
A=100;          %dm2
U=8;            %W/(dm2*K)
Tin_hot=343;    %K
Tin_cold=298;   %K
rhot=0.001;     %kg/lt
rcold=1;        %kg/lt
cphot=1000;     %J/K*kg
cpcold=5000;    %J/K*kg

Fin_cold = 0.6 %lt/min
Fin_hot = 400 %lt/min

%State Variables
Thot = x(1,1);
Tcold = x(2,1);

%Dynamic Model of the Tank Operation
dx = zeros(2,1);

%Temperature Thot(t) with time (t)
dx(1) = (Fin_hot/Vhot)*(Tin_hot-Thot)-((U*A)/(rhot*cphot*Vhot))*(Thot-Tcold);

%Temperature Tcold(t) with time (t)
dx(2) = (Fin_cold/Vcold)*(Tin_cold-Tcold)+((U*A)/(rcold*cpcold*Vcold))*(Thot-Tcold);
return