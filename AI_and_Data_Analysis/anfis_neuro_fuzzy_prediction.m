% student's project 2025 on Provlepsis lesson
% PREDICTION USING AN ---ANFIS--- MODEL  :PROJECT 6

close all  %clean the workspace
clear all
clc

mydata=xlsread ('ErgasiaTP.xlsx', 'e1:e252') % retrieves the E column data of range 1 to 252 from the data file 'atermondata'

%load agrasf
%mydata

mydata=[3.2800
    3.2200
    3.2600
    3.2200
    3.2000
    3.2000
    3.2600
    3.2800
    3.2800
    3.2800
    3.2200
    3.2400
    3.3000
    3.5600
    3.5000
    3.4000
    3.2400
    3.3000
    3.2400
    3.2000
    3.2200
    3.2000
    3.2600
    3.2200
    3.2000
    3.1600
    3.2000
    3.2800
    3.3400
    3.3400
    3.3400
    3.3400
    3.5800
    3.4600
    3.4000
    3.3200
    3.4800
    3.4200
    3.3600
    3.5400
    3.6000
    3.5800
    3.6000
    3.7800
    3.7800
    3.7000
    3.9000
    4.0200
    3.9800
    4.0200
    4.0200
    4.3600
    4.3400
    4.1800
    4.2000
    4.1600
    4.1600
    4.0000
    4.1200
    4.6200
    5.1400
    5.1800
    5.0000
    5.3400
    5.3600
    5.4400
    5.4800
    5.8000
    5.6400
    5.5200
    5.4600
    5.7800
    5.9200
    6.2800
    6.4000
    6.3400
    6.1600
    6.0000
    5.9200
    5.6200
    5.1800
    4.9800
    4.8400
    4.4000
    4.7600
    4.8800
    4.9000
    4.9400
    4.8600
    4.7000
    4.9000
    4.9000
    5.8200
    5.5400
    5.2200
    5.2400
    5.2600
    5.1000
    4.9200
    5.4000
    5.3000
    5.2000
    5.2800
    5.0800
    5.2000
    5.3600
    5.3800
    5.4000
    5.5200
    5.6000
    5.2200
    5.0400
    4.9400
    4.9400
    4.6600
    4.6800
    4.7000
    4.7000
    4.6800
    4.6400
    4.8200
    4.9600
    4.9000
    4.9200
    4.8000
    4.7600
    4.7800
    4.6200
    4.8400
    4.4400
    4.3000
    4.4400
    3.6800
    3.9600
    3.7400
    3.8600
    4.0800
    4.3200
    4.1200
    4.0200
    3.9000
    3.9000
    3.7600
    3.4600
    3.5200
    3.4200
    3.5600
    3.3200
    3.2600
    3.5000
    3.4000
    3.4800
    3.6000
    3.5800
    3.6400
    3.5800
    3.6400
    3.5000
    3.5200
    3.6400
    3.8400
    3.8000
    3.7800
    3.6400
    3.7000
    3.8000
    3.7400
    3.7400
    3.8200
    3.6000
    3.5600
    3.4000
    3.4400
    3.5600
    3.6000
    3.6400
    3.6000
    3.5800
    3.6000
    3.6600
    3.6000
    3.6200
    3.6600
    3.7000
    3.7600
    3.8200
    3.7200
    3.7400
    3.8000
    3.6800
    3.7600
    3.8200
    4.0000
    3.9800
    3.8800
    3.9400
    3.9600
    3.9000
    3.9400
    3.9200
    3.8000
    3.8200
    3.8000
    3.8000
    3.8400
    3.8000
    3.8600
    3.7800
    3.7000
    3.7000
    3.7200
    3.7200
    3.5600
    3.6000
    3.6200
    3.5000
    3.5200
    3.5600
    3.5400
    3.5600
    3.5200
    3.4800
    3.5600
    3.5000
    3.4800
    3.3800
    3.4200
    3.4000
    3.5200
    3.4400
    3.4200
    3.4400
    3.6200
    3.6600
    3.7200
    3.7200
    3.6800
    3.6800
    3.6400
    3.7600
    3.8000
    3.8400
    4.0400
    4.1600
    4.0200
    4.0000
    4.0000
    4.1600
    4.1800
    4.1600
    4.2200]

tic
figure(1) % a view of data
plot (mydata)
xlabel('time'); ylabel('values')
title('Actual values')


%  Estimation of an ANFIS model
% prepare training data
%input data
tr=mydata(1:210) % TRAINING DATA
% input (k-2)
train=tr
train(length(train))=[]% removes the last row
train(length(train))=[]; %removes the second last row
length(train)


%input k-1

train1=tr % first input
train1(length(train1))=[]% removes the last row
train1(1)=[] % removes the first row
length(train1)

% output k
train2=tr %second input
train2(1)=[]  % removes the first row
train2(1)=[]  %removes the second row
length(train2)



trn_data=[train train1 train2 ] %(k-2) (k-1) (k) training data



%%%%%% Ploting TRAINING data as a scater plot%%%%%%%
figure(10)
subplot(1,2,1)
plot (train, train2, 'o')
xlabel ('input (k-2) ')
ylabel('ouput (k)')
title('Training data')
axis equal; axis square

subplot(1,2,2)
plot (train1, train2, 'o')
xlabel ('input (k-1) ')
ylabel('ouput (k)')
title('Training data')
axis equal; axis square




%preparing the evaluation(test) data
ev=mydata(211:end)% TESTING DATA

% input (k-2)
eval=ev
eval(length(eval))=[]; eval(length(eval))=[];
length(eval)

% input (k-1)
eval1=ev
eval1(length(eval))=[];
eval1(1)=[];
length(eval)

% input (k)
eval2=ev
eval2(1)=[]
eval2(1)=[];
length(eval2)


evaldata=[eval eval1]   %input (k-2) and  (k-1)

y2=eval2 %(k) output data for testing





% generate FIS matrix
epoch_n=400
mf_n=[4 4];

%mf_type='gbellmf';   %type of membership function
%mf_type='trimf';   %the parameter b>c    
%mf_type='gauss2mf'
%mf_type='gaussmf' %
%mf_type='smf' % unsupported
mf_type='trapmf' % the parameter b>c
%mf_type='zmf'  %unsupported
%mf_type='pimf' % run problem

in_fismat=genfis1(trn_data, mf_n, mf_type);


% start training
ss=0.1;

[m_anfis trn_error step_size ] = ...
    anfis(trn_data, in_fismat, [epoch_n nan ss nan nan], [1,1,1,1]);



figure('name', ['ANFIS: time series prediction'])

subplot(211);
tmp=[trn_error ];
plot(tmp);
title('Error Curves');
axis([0 epoch_n min(tmp(:)) max(tmp(:))]);
xlabel('epochs')
ylabel('RMSE')
legend('Training Error');


subplot(212);
plot(step_size);
xlabel('epochs')
title('Step Size');



% plot the initial membership functons
figure (20)
subplot(2,1,1)
[mfx, mfy]=plotmf(in_fismat, 'input', 1);
plot(mfx, mfy);
title('(a) Initial MFs on input')
axis([-inf inf -inf inf]);
subplot(2,1,2)
[mfx, mfy]=plotmf(in_fismat, 'input', 2);
plot(mfx, mfy);
title('(b) Initial MFs on input')
axis([-inf inf -inf inf]);


% plot final MF's on x,y,z,u

figure (30)
subplot(2,1,1)
[mfx, mfy]=plotmf(m_anfis, 'input', 1);
plot(mfx, mfy);
title('(a) Final MFs on input')
axis([-inf inf -inf inf]);
subplot(2,1,2)
[mfx, mfy]=plotmf(m_anfis, 'input', 2);
plot(mfx, mfy);
title('(b) Final MFs on input')
axis([-inf inf -inf inf]);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%************


figure(40)
plotfis(in_fismat)

figure(50)
plotfis(m_anfis)

showrule(m_anfis)


anfisedit (m_anfis)
surfview(m_anfis)


%%%%%%%%%%%%%%%%%%%%%%%%%% IN SAMPLE EVALAUTION %%%%%%%%%%%%
insample_data=trn_data(:,1:2)
insaple_output=trn_data(:,3)
yhat_anfis_insample=evalfis(insample_data, m_anfis);

figure (60)
plot(insaple_output(end-30:end), 'b-s'), hold, plot(yhat_anfis_insample(end-30:end), 'r-x');
legend('actual values','ANFIS prediction values')
xlabel('time')
ylabel('values')
title('Actual values and ANFIS prediction in sample')


figure (70)
plot(insaple_output-yhat_anfis_insample)
xlabel('time')
ylabel('error')
title('Prediction in sample errors')



%Root Mean Square Error (RMSE)
RMSE_anfis_insample=sqrt(norm(insaple_output-yhat_anfis_insample)^2/length(insaple_output-yhat_anfis_insample))





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%prediction by ANFIS model out of sample

%%%%%%%%%%%%%%%%%%%%%%%%%%% ANFIS EVALUATION %%%%%%%%%%%%%%%%%
input=evaldata


%%%%%% Ploting EVALUATION data as a scater plot%%%%%%%
figure(90)
subplot(1,2,1)
plot (eval, eval2, 'o')
xlabel ('input (k-2)')
ylabel('ouput (k)')
title('Evaluating data')
axis equal; axis square

subplot(1,2,2)
plot (eval1, eval2, 'o')
xlabel ('input (k-1)')
ylabel('ouput (k)')
title('Evaluating data')
axis equal; axis square



%%%%%%%%% Evaluation of Anfis out of sample
yhat_anfis=evalfis(input, m_anfis);


adapt_input=y2; 
length(adapt_input);
length(yhat_anfis);
result=[adapt_input yhat_anfis (adapt_input-yhat_anfis)];
er_anfis=adapt_input-yhat_anfis; %error


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure (100)
plot(adapt_input(end-30:end), 'b-s'), hold, plot(yhat_anfis(end-30:end), 'r-x');
legend('actual values','ANFIS prediction values')
xlabel('time')
ylabel('values')
title('Actual values and ANFIS out of sample prediction')


figure (120)
plot(adapt_input-yhat_anfis)
xlabel('time')
ylabel('error')
title('Prediction errors')




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% error measures calculation


MSE_anfis=(1/length(yhat_anfis))*norm(er_anfis)^2

%Root Mean Square Error (RMSE)
RMSE_anfis=sqrt(norm(er_anfis)^2/length(er_anfis))

%Mean Absolute Error (MAE)
MAE_anfis=(1/length(er_anfis))*sum(abs(er_anfis))

%Mean Absolute percentage Error (MAPE)
MAPE_anfis=(100/length(er_anfis))*sum(abs(er_anfis)./abs(adapt_input))

toc  % the calculation time in seconds
runing_minute_time=toc/60
%end
