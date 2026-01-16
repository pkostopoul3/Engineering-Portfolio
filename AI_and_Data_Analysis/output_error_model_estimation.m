% student's project 2025 on Provlepsis lesson
% PREDICTION USING AN ---OE--- MODEL :PROJECT 4


close all  %clean the workspace
clear
clc

mydata=xlsread ('ErgasiaTP.xls', 'e1:e252') % retrieves the E column data of range 1 to 252 from the data file 'ErgasiaTP.xls.xlsx'




figure(1) % a view of data
plot (mydata)
xlabel('time'); ylabel('values')
title('Actual values')




%  Estimation of an OE model

y=mydata

y1=mydata(1:230) % TRAINING DATA
y2=mydata(231:end)% TESTING DATA


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The Output Error Method does not make sense for a time series (no input).
%Here we create data u by a random numbers
u=sin([1:length(y1)]')+0.2*randn(length(y1),1)
m_oe=oe([y1 u],[1,3,0]) % estimation of the model

fpe_oe=fpe(m_oe) % estimation of Akaike's Final prediction Error (FPE)
aic_oe=aic(m_oe) % estimation of Akaike's Information criterion (AIC)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% in sample evaluation
yhat_oe_insampleIP=predict(m_oe, [y1 u],1) %predicts the in sample data

%AA=yhat_oe_insampleIP(1,:)
%yhat_oe_insample=AA
yhat_oe_insample=yhat_oe_insampleIP

t1=1:(length(yhat_oe_insample))

figure(2)
plot(t1,y1,':', t1,yhat_oe_insample,'-');
legend('actual value',' OE prediction')
xlabel('time')
ylabel('value')
title('Actual and OE prediction - in sample')

%figure (3) % in sample prediction and plotting
%compare (y1, m_oe, 1) %it is another way to predict and plot directly



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%prediction by OE model out of sample

u2=sin([1:length(y2)]')+0.2*randn(length(y2),1)

yhat_oeIP=predict(m_oe, [y2 u2],1) %predicts the unseen data

%BB=yhat_oeIP(1,:);
%yhat_oe=BB
yhat_oe=yhat_oeIP

t=1:(length(yhat_oe))
figure(4)
plot(t,y2,'b-s', t,yhat_oe,'r-x');
legend('actual value',' OE prediction')
xlabel('time')
ylabel('value')
title('Actual and OE prediction -out of sample')

%figure (5)
%compare (y2, m_oe, 1) % it is another way to predict and plot directly

{y2 yhat_oe}% prints the  actual and predicted value

get(m_oe) % gives model information

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% error measures calculation


% Mean Square Error (MSE)
MSE_oe=(1/length(yhat_oe))*norm(y2-yhat_oe)^2

% Root Mean Square Error (RMSE)
RMSE_oe=sqrt(norm(y2-yhat_oe)^2/length(y2-yhat_oe))

% Mean Absolute Error (MAE)
MAE_oe=(1/length(y2-yhat_oe))*sum(abs(y2-yhat_oe))

% Mean Absolute Percentage Error (MAPE)
MAPE_oe=(100/length(y2-yhat_oe))*sum(abs(y2-yhat_oe)./abs(y2))

%end

