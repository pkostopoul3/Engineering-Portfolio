% student's project 2025 on Provlepsis lesson
% PREDICTION USING AN ---AR--- MODEL  :PROJECT 1

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



%  Estimation of an AR model

y=mydata

y1=mydata(1:200) % TRAINING DATA
y2=mydata(201:end)% TESTING DATA


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m_ar=ar(y1,1, 'ls') % estimation of the model

fpe_ar=fpe(m_ar) % estimation of Akaike's Final prediction Error (FPE)
aic_ar=aic(m_ar) % estimation of Akaike's Information criterion (AIC)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% in sample evaluation
yhat_ar_insampleIP=predict(m_ar, y1,1) %predicts the in sample data

%AA=yhat_ar_insampleIP{1,:} % it reads the 'cell' type

%yhat_ar_insample=AA
yhat_ar_insample=yhat_ar_insampleIP

t1=1:(length(yhat_ar_insample))
figure(2)
plot(t1,y1,':', t1,yhat_ar_insample,'-');
legend('actual value',' ar prediction')
xlabel('time')
ylabel('value')
title('Actual and AR prediction - in sample')


figure (3) % in sample prediction and plotting
compare(y1, m_ar, 1)% it is another way to predict and plot directly




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%prediction by AR model out of sample

yhat_arIP=predict(m_ar, y2,1) %predicts the unseen data

%AAA=yhat_arIP{1,:}

%yhat_ar=AAA

yhat_ar=yhat_arIP
t=1:(length(yhat_ar))



figure(4)
plot(t,y2,'b-s', t,yhat_ar,'r-x');
legend('actual value',' ar prediction')
xlabel('time')
ylabel('value')
title('Actual and AR prediction -out of sample')

figure (5)
compare(y2, m_ar, 1)% it is another way to predict and plot directly

[y2 yhat_ar]% prints the  actual and predicted value

get(m_ar) % gives model information

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% error measures calculation


% Mean Square Error (MSE)
MSE_ar=(1/length(yhat_ar))*norm(y2-yhat_ar)^2

% Root Mean Square Error (RMSE)
RMSE_ar=sqrt(norm(y2-yhat_ar)^2/length(y2-yhat_ar))

% Mean Absolute Error (MAE)
MAE_ar=(1/length(y2-yhat_ar))*sum(abs(y2-yhat_ar))

% Mean Absolute Percentage Error (MAPE)
MAPE_ar=(100/length(y2-yhat_ar))*sum(abs(y2-yhat_ar)./abs(y2))

%end