clc
clear

DH=[0.1 0.8 0 pi/2;
    -0.2 0 0.4 pi;
    0.3 0 0.2 0;
    (-pi/2)+0.2 0 0 -pi/2;
    -0.1 0.6 0 0];

theta1=DH(1,1);
r1=DH(1,2);
d1=DH(1,3);
alpha1=DH(1,4);

theta2=DH(2,1);
r2=DH(2,2);
d2=DH(2,3);
alpha2=DH(2,4);

theta3=DH(3,1);
r3=DH(3,2);
d3=DH(3,3);
alpha3=DH(3,4);

theta4=DH(4,1);
r4=DH(4,2);
d4=DH(4,3);
alpha4=DH(4,4);

theta5=DH(5,1);
r5=DH(5,2);
d5=DH(5,3);
alpha5=DH(5,4);

T0_1=function_5_1_4_paradeigma_DH_pinakas_T(theta1,r1,d1,alpha1);
T1_2=function_5_1_4_paradeigma_DH_pinakas_T(theta2,r2,d2,alpha2);
T2_3=function_5_1_4_paradeigma_DH_pinakas_T(theta3,r3,d3,alpha3);
T3_4=function_5_1_4_paradeigma_DH_pinakas_T(theta4,r4,d4,alpha4);
T4_5=function_5_1_4_paradeigma_DH_pinakas_T(theta5,r5,d5,alpha5);

A1=[0 0 0 1]';
A0_1=T0_1*A1;
A2=[0 0 0 1]';
A1_2=T1_2*A2;
A0_2=T0_1*A1_2;
T0_2=T0_1*T1_2;
A3=[0 0 0 1]';
A2_3=T2_3*A3;
A1_3=T1_2*A2_3;
A0_3=T0_1*A1_3;
A0_3=T0_1*T1_2*T2_3*A3;
T0_3=T0_1*T1_2*T2_3;
A4=[0 0 0 1]';
A0_4=T0_1*T1_2*T2_3*T3_4*A4;
T0_4=T0_1*T1_2*T2_3*T3_4;
A5=[0 0 0 1]';
A0_5=T0_1*T1_2*T2_3*T3_4*T4_5*A5;
A2_5=T2_3*T3_4*T4_5*A5;


Y1=0.3;

Ry1=[cos(Y1) 0 sin(Y1) 0; 0 1 0 0; -sin(Y1) 0 cos(Y1) 0;0 0 0 1];
Trans1=[1 0 0 1;
        0 1 0 2;
        0 0 1 3;
        0 0 0 1];

T4_A2=Ry1;
TA2_5=T4_A2^(-1)*T4_5;
AA2_5=TA2_5*A5;
TA2_B=Trans1;
B1=[0 0 0 1]';
A0_B=T0_1*T1_2*T2_3*T3_4*T4_A2*TA2_B*B1
A2_B=T2_3*T3_4*T4_A2*TA2_B*B1;

function Trans = function_5_1_1_paradeigma_DH_trans(x, y, z)
    Trans = [1 0 0 x; 0 1 0 y; 0 0 1 z; 0 0 0 1];
end
function rZ = function_5_1_2_paradeigma_DH_rotZ(theta)
    c_theta = cos(theta);
    s_theta = sin(theta);
    rZ = [ c_theta -s_theta 0 0; s_theta c_theta 0 0; 0 0 1 0; 0 0 0 1];
end
function rX = function_5_1_3_paradeigma_DH_rotX(alpha)
  c_alpha = cos(alpha);
  s_alpha = sin(alpha);
  rX = [1 0 0 0; 0 c_alpha -s_alpha 0; 0 s_alpha c_alpha 0; 0 0 0 1];
end
function T = function_5_1_4_paradeigma_DH_pinakas_T(theta,r,d,alpha)
T=function_5_1_1_paradeigma_DH_trans(0, 0,r)*function_5_1_2_paradeigma_DH_rotZ(theta)*function_5_1_1_paradeigma_DH_trans(d,0,0)*function_5_1_3_paradeigma_DH_rotX(alpha);
end

