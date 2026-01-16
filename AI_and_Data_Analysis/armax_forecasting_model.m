% student's project 2025 on Provlepsis lesson
% PREDICTION USING AN ---ARMAX or ARMA--- MODEL :p PROJECT 3

%The ARMA model is calculated for a scalar time series m0 =[na nc] .



close all  %clean the workspace
clear
clc

mydata=xlsread ('ErgasiaTP.xlsx', 'e1:e252') % retrieves the E column data of range 1 to 252 from the data file 'atermondata'


mydata=[0.9900
    1.0200
    1.0500
    1.0500
    1.0500
    1.0200
    1.0200
    1.0200
    1.0200
    1.0200
    0.9900
    0.9600
    0.8700
    0.9300
    0.9000
    0.8700
    0.9000
    0.9000
    0.9300
    0.9000
    0.9000
    0.9000
    0.9600
    0.9900
    0.9600
    0.9300
    0.9300
    0.9300
    0.9600
    1.0200
    1.0200
    1.0500
    1.0200
    1.0200
    0.9900
    0.9900
    0.9900
    0.9900
    0.9900
    0.9600
    0.9600
    0.9600
    0.9900
    0.9900
    0.9900
    0.9900
    0.9900
    0.9900
    0.9900
    0.9900
    0.9900
    0.9900
    0.9900
    0.9600
    0.9600
    0.9600
    0.9600
    0.9300
    0.9600
    0.9300
    0.9600
    0.9600
    0.9600
    0.9600
    0.9600
    1.1100
    1.3200
    1.4700
    1.2900
    1.4100
    1.3500
    1.4100
    1.3500
    1.3500
    1.2600
    1.2600
    1.2600
    1.2600
    1.3200
    1.3500
    1.2900
    1.2600
    1.2900
    1.2900
    1.2600
    1.2900
    1.2600
    1.2300
    1.2600
    1.2600
    1.2300
    1.2600
    1.2600
    1.2600
    1.4100
    1.4100
    1.4700
    1.6800
    1.5900
    1.4700
    1.3800
    1.3800
    1.3800
    1.3800
    1.3800
    1.3800
    1.6500
    1.5700
    1.4600
    1.3300
    1.3600
    1.2600
    1.2100
    1.1800
    1.0700
    1.1100
    1.1400
    1.1300
    1.1400
    1.1000
    1.1200
    1.1600
    1.1500
    1.1800
    1.1900
    1.1500
    1.1500
    1.1500
    1.1400
    1.1000
    1.0900
    1.1100
    1.1100
    1.1100
    1.0800
    1.0800
    1.0800
    1.1100
    1.1000
    1.0700
    1.0600
    1.0500
    1.0400
    1.0300
    1.0100
    1.0000
    0.9800
    0.9800
    1.0600
    1.0900
    1.0700
    1.0900
    1.0700
    1.1400
    1.1200
    1.1100
    1.0900
    1.1300
    1.1200
    1.1600
    1.1300
    1.1000
    1.1400
    1.0400
    1.0700
    1.0000
    1.0300
    1.0600
    1.0600
    1.0000
    1.0100
    0.9800
    1.0000
    1.0100
    0.9600
    0.9400
    0.9200
    0.9100
    0.8500
    0.8400
    0.9000
    0.8600
    0.8700
    0.8600
    0.8800
    0.8600
    0.8400
    0.8700
    0.8600
    0.8900
    0.8900
    0.9500
    0.9100
    0.9100
    0.9000
    0.8900
    0.8900
    0.9000
    0.8900
    0.9000
    0.8700
    0.8400
    0.8400
    0.8700
    0.8700
    0.8800
    0.8800
    0.8700
    0.8700
    0.8600
    0.8600
    0.8700
    0.9000
    0.9900
    0.9600
    0.9300
    0.9300
    0.9300
    0.9300
    1.1100
    1.3300
    1.3000
    1.2400
    1.3000
    1.2000
    1.1600
    1.1400
    1.1100
    1.1400
    1.1600
    1.1100
    1.2400
    1.2100
    1.1900
    1.1900
    1.1600
    1.1700
    1.1700
    1.1500
    1.2600
    1.2300
    1.1900
    1.2200
    1.1800
    1.1500
    1.1900
    1.1700
    1.1600
    1.1900
    1.2000
    1.1900]


figure(1) % a view of data
plot (mydata)
xlabel('time'); ylabel('values')
title('Actual values')



%  Estimation of an ARMA model
y=mydata

y1=mydata(1:230) % TRAINING DATA
y2=mydata(231:end)% TESTING DATA






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m_arma=armax(y1,[1,1]) % estimation of the model

fpe_arma=fpe(m_arma) % estimation of Akaike's Final prediction Error (FPE)
aic_arma=aic(m_arma) % estimation of Akaike's Information criterion (AIC)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% in sample evaluation
yhat_arma_insampleIP=predict(m_arma, y1,1) %predicts the in sample data

%AA=yhat_arma_insampleIP{1,:}
%yhat_arma_insample=AA
yhat_arma_insample=yhat_arma_insampleIP


t1=1:(length(yhat_arma_insample))
figure(2)
plot(t1,y1,':', t1,yhat_arma_insample,'-');
legend('actual value',' arma prediction')
xlabel('time')
ylabel('value')
title('Actual and ARMA prediction - in sample')

figure (3) % in sample prediction and plotting
compare(y1, m_arma, 1)% it is another way to predict and plot directly




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%prediction by ARMA model out of sample

yhat_armaIP=predict(m_arma, y2,1,1) %predicts the unseen data

%BB=yhat_armaIP{1,:};
%yhat_arma=BB
yhat_arma=yhat_armaIP


t=1:(length(yhat_arma))
figure(4)
plot(t,y2,'b-s', t,yhat_arma,'r-x');
legend('actual value',' arma prediction')
xlabel('time')
ylabel('value')
title('Actual and ARMA prediction -out of sample')

figure (5)
compare(y2, m_arma, 1)% it is another way to predict and plot directly



[y2 yhat_arma]% prints the  actual and predicted value

get(m_arma) % gives model information

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% error measures calculation


% Mean Square Error (MSE)
MSE_arma=(1/length(yhat_arma))*norm(y2-yhat_arma)^2

% Root Mean Square Error (RMSE)
RMSE_arma=sqrt(norm(y2-yhat_arma)^2/length(y2-yhat_arma))

% Mean Absolute Error (MAE)
MAE_arma=(1/length(y2-yhat_arma))*sum(abs(y2-yhat_arma))

% Mean Absolute Percentage Error (MAPE)
MAPE_arma=(100/length(y2-yhat_arma))*sum(abs(y2-yhat_arma)./abs(y2))

%end