clear all
clc

syms s t

%Change 1
U1 = 100*heaviside(t);
U1=laplace(U1);
D1=10*heaviside(t);
D1=laplace(D1);

%Change 2
U2=(100/s)-(25/s)*exp(-400*s)+(15/s)*exp(-600*s)+(12/s)*exp(-1000*s);
D2=10*heaviside(t);
D2=laplace(D2);

%Change 3
U3 = 100*heaviside(t);
U3=laplace(U3);
D3 = (10/s)+(5/s)*exp(-200*s)-(10/s)*exp(-1200*s);

%Change 4
U4=(100/s)-(25/s)*exp(-400*s)+(15/s)*exp(-600*s)+(12/s)*exp(-1000*s);
D4 = (10/s)+(5/s)*exp(-200*s)-(10/s)*exp(-1200*s);


U=U3;
D=D3;

Kp=1;tp=10;
Kd=2;td=30;

Y=(Kp/(tp*s+1))*U+(Kd/(td*s+1))*D;
y=ilaplace(Y);

t=0:1*60:1500*60;

y=subs(y,t);
y=double(y);
figure(1);plot(t,y,'o');xlabel('Time(s)');ylabel('Output Response Y(t)')

u=ilaplace(U);
u=subs(u,t);
u=double(u);
figure(2);plot(t,u,'o');xlabel('Time(s)');ylabel('Input Change U(t)')

d=ilaplace(D);
d=subs(d,t);
d=double(d);
figure(3);plot(t,d,'o');xlabel('Time(s)');ylabel('Disturbance Change D(t)')