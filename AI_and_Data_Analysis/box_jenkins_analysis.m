% student's project 2025 on Provlepsis lesson
% PREDICTION USING AN ---BoxJenkins--- MODEL  :PROJECT 5

close all  %clean the workspace
clear
clc

mydata=xlsread ('ErgasiaTP.xlsx', 'e1:e252') % retrieves the E column data of range 1 to 252 from the data file 'ErgasiaTP.xls.xlsx'



figure(1) % a view of data
plot (mydata)
xlabel('time'); ylabel('values')
title('Actual values')



%  Estimation of an BJ model
y=mydata

y1=mydata(1:200) % TRAINING DATA
y2=mydata(201:end)% TESTING DATA

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Here we create data u by a random numbers
u=sin([1:length(y1)]')+0.2*randn(length(y1),1)
m_bj=bj([y1 u],[2 2 2 2 1]) % estimation of the model

fpe_bj=fpe(m_bj) % estimation of Akaike's Final prediction Error (FPE)
aic_bj=aic(m_bj) % estimation of Akaike's Information criterion (AIC)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% in sample evaluation
yhat_bj_insampleIP=predict(m_bj, [y1 u],1) %predicts the in sample data

%AA=yhat_bj_insampleIP(1,:);
%yhat_bj_insample=AA
yhat_bj_insample=yhat_bj_insampleIP

t1=1:(length(yhat_bj_insample))
figure(2)
plot(t1,y1,':', t1,yhat_bj_insample,'-');
legend('actual value',' BJ prediction')
xlabel('time')
ylabel('value')
title('Actual and BJ prediction - in sample')


%figure (3) % in sample prediction and plotting
%compare(y1, m_bj, 1)% it is another way to predict and plot directly




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%prediction by BJ model out of sample

u2=sin([1:length(y2)]')+0.2*randn(length(y2),1)

yhat_bjIP=predict(m_bj, [y2 u2],1) %predicts the unseen data

%BB=yhat_bjIP(1,:);
%yhat_bj=BB
yhat_bj=yhat_bjIP

t=1:(length(yhat_bj))
figure(4)
plot(t,y2,'b-s', t,yhat_bj,'r-x');
legend('actual value',' BJ prediction')
xlabel('time')
ylabel('value')
title('Actual and BJ prediction -out of sample')

%figure (5)
%compare(y2, m_bj, 1)% it is another way to predict and plot directly

{y2 yhat_bj}% prints the  actual and predicted value

get(m_bj) % gives model information

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% error measures calculation


% Mean Square Error (MSE)
MSE_bj=(1/length(yhat_bj))*norm(y2-yhat_bj)^2

% Root Mean Square Error (RMSE)
RMSE_bj=sqrt(norm(y2-yhat_bj)^2/length(y2-yhat_bj))

% Mean Absolute Error (MAE)
MAE_bj=(1/length(y2-yhat_bj))*sum(abs(y2-yhat_bj))

% Mean Absolute Percentage Error (MAPE)
MAPE_bj=(100/length(y2-yhat_bj))*sum(abs(y2-yhat_bj)./abs(y2))

%end

