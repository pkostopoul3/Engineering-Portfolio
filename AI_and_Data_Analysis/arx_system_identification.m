% student's project 2025 on Provlepsis lesson
% PREDICTION USING AN ---ARX--- MODEL  :PROJECT 2

close all  %clean the workspace
clear
clc

mydata=xlsread ('ErgasiaTP.xlsx', 'e1:e252') % retrieves the E column data of range 1 to 252 from the data file 'ErgasiaTP.xls.xlsx'



figure(1) % a view of data
plot (mydata)
xlabel('time'); ylabel('values')
title('Actual values')


%  Estimation of an ARX model
y=mydata

y1=mydata(1:200) % TRAINING DATA
y2=mydata(201:end)% TESTING DATA


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m_arx=arx(y1,1) % estimation of the model

fpe_arx=fpe(m_arx) % estimation of Akaike's Final prediction Error (FPE)
aic_arx=aic(m_arx) % estimation of Akaike's Information criterion (AIC)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% in sample evaluation
yhat_arx_insampleIP=predict(m_arx, y1,1) %predicts the in sample data

AA=yhat_arx_insampleIP(1,:);

yhat_arx_insample=AA

t1=1:(length(yhat_arx_insample))
figure(2)
plot(t1,y1,':', t1,yhat_arx_insample,'-');
legend('actual value',' arx prediction')
xlabel('time')
ylabel('value')
title('Actual and ARX prediction - in sample')


figure (3) % in sample prediction and plotting
compare(y1, m_arx, 1)% it is another way to predict and plot directly




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%prediction by ARX model out of sample

yhat_arxIP=predict(m_arx, y2,1) %predicts the unseen data

BBB=yhat_arxIP(1,:);

yhat_arx=BBB

t=1:(length(yhat_arx))
figure(4)
plot(t,y2,'b-s', t,yhat_arx,'r-x');
legend('actual value',' arx prediction')
xlabel('time')
ylabel('value')
title('Actual and ARX prediction -out of sample')


figure (5)
compare(y2, m_arx, 1)% it is another way to predict and plot directly

{y2 yhat_arx}% prints the  actual and predicted value

get(m_arx) % gives model information

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% error measures calculation


% Mean Square Error (MSE)
MSE_arx=(1/length(yhat_arx))*norm(y2-yhat_arx)^2

% Root Mean Square Error (RMSE)
RMSE_arx=sqrt(norm(y2-yhat_arx)^2/length(y2-yhat_arx))

% Mean Absolute Error (MAE)
MAE_arx=(1/length(y2-yhat_arx))*sum(abs(y2-yhat_arx))

% Mean Absolute Percentage Error (MAPE)
MAPE_arx=(100/length(y2-yhat_arx))*sum(abs(y2-yhat_arx)./abs(y2))

%end
