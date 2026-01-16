% FORECASTING 20/11/2025
%ONE-STEP AHEAD PREDICTION  % By Neural Network

clear all
close all
clc

mydata=xlsread ('ErgasiaTP.xlsx', 'e2:e252') % retrieves the E column data of range 1 to 252 from the data file 'atermondata'

time=mydata

%output (k)
data_for_output= xlsread ('ErgasiaTP.xlsx','e3:e251')
%input one step delay (k-1)
dataDealyed_for_input=xlsread ('ErgasiaTP.xlsx', 'e2:e250')

data=[dataDealyed_for_input data_for_output]


% prepare training data
% input (k-1)
N2=length(data_for_output)
N1=floor(N2*0.8) % 80%

%training data
train_data_input=dataDealyed_for_input(1:N1); %training data-input
train_data_output=data_for_output(1:N1); %training data-input

%testing data
test_data_input=dataDealyed_for_input(N1+1:N2); %testing data
test_data_output=data_for_output(N1+1:N2); %testing data

x=train_data_input
y=train_data_output

[x y]

trainX =x
trainY = y;

% Create test set 
testX = test_data_input;
testY = test_data_output;

t=1:(length(x))

% figure of data
figure('name', ['Training data']);
subplot(211); plot(t, x,'-', t, x, 'go');
xlabel('Time'); ylabel('x'); axis([-inf inf -inf inf]);
title('Training data x')

subplot(212); plot(t, y, '-', t, y, 'go');
xlabel('Time'); ylabel('y'); axis([-inf inf -inf inf]);
title('Training data y')


%%%%%%PLOTING TRAINING DATA AS A SCATTER PLOT%%%%%%%%
figure('name', ['TRAINING DATA AS A SCATTER PLOT 2D']);
plot (x, y, 'o')
xlabel ('x')
ylabel('y')
title('Training data')
axis equal; axis square


figure('name', ['TRAINING DATA AS A SCATTER PLOT 3D'])
plot(x, y, 'o');
axis([-inf inf -inf inf -inf inf]);
set(gca, 'box', 'on');
xlabel('x'); ylabel('y');% zlabel('y(k+1)'); title('Training Data');

net = feedforwardnet(5);              % 20 hidden neurons
net = configure(net, trainX', trainY'); % Configure the network with training data
net = train(net, trainX', trainY');     % Train the network; %create a feed-forward backprobagation network
%net = newfit(trainX', trainY', 20); %create a fiting network 

net.performFcn = 'mae'; % calculates the MAE (mean absolute eror)
net = train(net, trainX', trainY');




%% Forecast using Neural Network Model
% Once the model is built, perform a forecast on the independent test set. 

forecastLoad = sim(net, testX')';

%% Compare Forecast Load and Actual Load
% Create a plot to compare the actual load and the predicted load as well
% as compute the forecast error. In addition to the visualization, quantify
% the performance of the forecaster using metrics such as mean absolute
% error (MAE), mean absolute percent error (MAPE) and daily peak forecast
% error.

err = testY-forecastLoad;
%fitPlot(testDates, [testY forecastLoad], err);

errpct = abs(err)./testY*100;

%fL = reshape(forecastLoad, 24, length(forecastLoad)/24)'; %μετατρέπει τις γραμμες σε στήλες
%tY = reshape(testY, 24, length(testY)/24)';
%peakerrpct = abs(max(tY,[],2) - max(fL,[],2))./max(tY,[],2) * 100;

MAE = mean(abs(err));
MAPE = mean(errpct(~isinf(errpct)));

%fprintf('Mean Absolute Percent Error (MAPE): %0.2f%% \nMean Absolute Error (MAE): %0.2f MWh\nDaily Peak MAPE: %0.2f%%\n',...
   % MAPE, MAE, mean(peakerrpct))

MSE_NN=(1/length(forecastLoad))*norm(err)^2

%Root Mean Square Error (RMSE)
RMSE_NN=sqrt(norm(err)^2/length(err))

%Mean Absolute Error (MAE)
MAE_NN=(1/length(err))*sum(abs(err))

%Mean Absolute percentage Error (MAPE)
MAPE_NN=(100/length(err))*sum(abs(err)./abs(testY))


%% Examine Distribution of Errors
% In addition to reporting scalar error metrics such as MAE and MAPE, the
% plot of the distribution of the error and absolute error can help build
% intuition around the performance of the forecaster

figure (3);
subplot(3,1,1); hist(err,100); title('Error distribution');
subplot(3,1,2); hist(abs(err),100); title('Absolute error distribution');
line([MAE MAE], ylim); legend('Errors', 'MAE');
subplot(3,1,3); hist(errpct,100); title('Absolute percent error distribution');
line([MAPE MAPE], ylim); legend('Errors', 'MAPE');




figure (200)
plot(mydata(end-40,end), '-o'), hold on, plot(testY(max(1, end-40):end), '-x');
legend('actual values','NN forecasted values')
xlabel('time')
ylabel('values')
title('Actual values and NN forecasts')

% four erros
MAPE_NN
MAE_NN
MSE_NN
RMSE_NN

fprintf('RMSE = %d\n', RMSE_NN)
fprintf('MAE = %d\n', MAE_NN)
fprintf('MAPE = %d\n', MAPE_NN)
fprintf('MSE = %d\n', MSE_NN)


%end