clear
clc

tspan = [0:0.5:500];

%Initial Values for State Variables
x0(1)=343; %K
x0(2)=298; %K

[tsol,xsol]=ode45(@heat_exchanger_dynamics,tspan,x0);

figure(1);plot(tsol,xsol(:,1));xlabel('Time, s');ylabel('Temperature Thot, K')
figure(2);plot(tsol,xsol(:,2));xlabel('Time, s');ylabel('Temperature Tcold, K')