
function [net, train_record, test_perf, Conf_mat, Ratio_mat, Network_output] = trainmlp_validation(tr_data, tr_labels, ts_data, ts_labels);

% trainmlp_validation .m for PR projects
% Trains and tests an MLP type neural network using validation dataset
% A portion of the data will be set aside for validation and testing
% Sample training routine using MATLAB's built in functions
% data: M-by-L data matrix of L instances. The data should be in the columns - M=number of features.
% classes: C-by-L matrix correct class matrix, encoded in unary format [0 0 1 0 0]
% net: network structure. All network parameters of trained network. 
% train_record: structure. Includes epoch by epoch performance figures 
% test-perf: scalar. Empirical (percentage) performance on test data 
% Conf_mat: C-by-C confusion matrix
% Ratio_mat: C-by-C confusion matrix of the ratios
% Network_output: Output of the network for the test data for possible
% postprocessing


% RobiPolikar
% Originally written 2001, Revised 2003, 2005, 10/2007, August 2022
% Substantially revised and rewritten for Matlab v7.8 on October 3, 2009 
% Revised for Matlab 2012b on October 11, 2012 using new network functions
% Revised for Matlab 2022a on August 15, 2022.
% Rowan University.

        

%Sample Usage:
% OCR Data
% load opt_test
% load opt_train
% load opt_class.mat
% load opttest_class
% 
% [net, train_record, test_perf, Conf_mat, Ratio_mat, Network_output] = trainmlp_validation(opt_train, opt_class, opt_test, opttest_class);
% 

% SPiral Data
% [spiral spiral_2d_data labels tr_labels] = generate_spiral(1000, 2*pi, 3, 0.2);
% spiral_2d_data=spiral_2d_data';
% ts_data=create_griddata2(-6:0.1:6, -6:0.1:6);
% ts_data=ts_data';
% [net, train_record, test_perf, Conf_mat, Ratio_mat, Network_output] = trainmlp_validation(spiral_2d_data, tr_labels, ts_data);

%Gaussian Data
%   MU =[-1 2 3; 1 3 0];
%   Sigma1 = [.9 .4; .4 .3];
%   Sigma2 = [1 0; 0 1];
%   Sigma3 = [.3 0.8; 0.8 3];
%   SIGMA{1}=Sigma1; SIGMA{2}=Sigma2; SIGMA{3}=Sigma3;
%   X=[-5:0.1:5];
%   Y=[-8:0.1:8];
%   COUNT=[200 1000 500];
%   [Gaussian tr_data class tr_labels]=generate_multiple_gauss2d(MU, SIGMA, COUNT);
%   tr_data=tr_data';
%   ts_data=create_griddata2(-2.5:0.05:4, -4:0.05:5);
%   ts_data=ts_data';
%   [net, train_record, test_perf, Conf_mat, Ratio_mat, Network_output] = trainmlp_validation(tr_data, tr_labels, ts_data);


% Checkerboard data
% N=5000; %Number of data points
% a=0.2; %length of each square
% alpha=pi/3; % angle of rotation
% [tr_data,tr_labels]=generate_checkerboard(N,a,alpha);
% tr_data=tr_data';
% tr_labels=full(ind2vec(tr_labels'));
% ts_data=create_griddata2(linspace(0,1, 250), linspace(0,1,250));
% ts_data=ts_data';
% [net, train_record, test_perf, Conf_mat, Ratio_mat, Network_output] = trainmlp_validation(tr_data, tr_labels, ts_data);

%close all


if nargin<0
    errordlg('You must provide at least training and test data.', 'Incorrect number of inputs'); return
end

if nargin==2
    test_flag=0;
end

if (nargin==3 ||nargin==4)
    test_flag=1;
    [TE_M TE_L]=size(ts_data);
end

[M L]=size(tr_data);

%Verify data formatting


choice = questdlg(['Total data size is ', num2str(L), ' with ', num2str(M), ' features - Is this correct? Remember, data must be in columns'], ...
 'Verify Data Size', ...
 'Yes','No ', 'No ');
if choice == 'No '
    errordlg('Please resize your data matrices and try again'); return
end


prompt={'Please enter the key training parameters for the MLP: Please enter number of hidden layer nodes?', 'the error goal:', 'number of max training epochs:', 'and the max number of validation checks:'};
    name='Data Partitioning:';
    numlines=1;
    defaultanswer={'20', '0.01', '5000', '50'};
    design_response=(inputdlg(prompt,name,numlines,defaultanswer, 'on'));
    hidden_layer_nodes=str2num(design_response{1});
    error_goal=str2num(design_response{2});
    max_epochs=str2num(design_response{3});
    max_fail=str2num(design_response{4});

if (test_flag==1)
    
    prompt={'You have provided separate test data. However Matlab can still do a separate partitioning - What % of the training data should be used for validation?', 'and what % of this data should be used for internal testing?'};
    name='Data Partitioning:';
    numlines=1;
    defaultanswer={'20', '0'};
    design_response=(inputdlg(prompt,name,numlines,defaultanswer, 'on'));
    V_ratio=str2num(design_response{1})/100;
    T_ratio=str2num(design_response{2})/100;
    TR_ratio=1-V_ratio-T_ratio;
  
    msgbox(['Using ', num2str(round(L*TR_ratio)), ' instances for training, ', ...
        num2str(round(L*V_ratio)), ' for validation and a separate ', num2str(round(TE_L)), ' for testing.'], 'Verify Data Partitioning', 'warn');
    
    
    %One can also create their own partitioning of the data - We will not
    %use this, as Matlab will take care of this.
    % [tr_data,val_data,dummy1,trainInd,valInd,testInd] = dividerand(train_data,TR_ratio,V_ratio,T_ratio);
    % [tr_labels,val_labels,dummy2] = divideind(train_labels,trainInd,valInd,testInd);  
    
end


if (test_flag==0)
    
    prompt={'What % of data should be used for validation?', 'What % of data should be used for internal testing?'};
    name='Data Partitioning:';
    numlines=1;
    defaultanswer={'20', '20'};
    design_response=(inputdlg(prompt,name,numlines,defaultanswer, 'on'));
    V_ratio=str2num(design_response{1})/100;
    T_ratio=str2num(design_response{2})/100;
    TR_ratio=1-V_ratio-T_ratio;
    msgbox(['Using ', num2str(round(L*TR_ratio)), ' instances for training, ', ...
        num2str(round(L*V_ratio)), ' for validation and ', num2str(round(L*T_ratio)), ' for testing.'], 'Verify Data Partitioning', 'warn')
    
    [tr_data,val_data,ts_data,trainInd,valInd,testInd] = dividerand(tr_data,TR_ratio,V_ratio,T_ratio);
    [tr_labels,val_labels,ts_labels] = divideind(tr_labels,trainInd,valInd,testInd);
    
end

%UPdate the data size after the partitioning
[M2 L2]=size(tr_data);
%Let's shuffle the data
I=randperm(L2);
tr_data=tr_data(:,I);
tr_labels=tr_labels(:,I);
clear I


%Split the entire data into train, validation and testsets
%[train_data,validation_data,test_data] = dividevec(data,classes,V_ratio/100,T_ratio/100);

rand('state',sum(100*clock)); % Randomize the internal random number generator for MATLAB

%Convert data and labels from concurrent vectors to sequences 
%tr_data=con2seq(tr_data);
%tr_labels=con2seq(tr_labels);



% create the network 
net = feedforwardnet([hidden_layer_nodes], 'traingdx');
net.layers{1}.transferFcn='tansig';
net.layers{2}.transferFcn='tansig';
%net.layers{3}.transferFcn='tansig'; %Use only with 2 hidden layer networks


% The following two lines remove the input and output processing functions.
% Specifically, the default input and output layer normalziation function
% is removed, which maps both the input and output values to [-1 1] range.
% If this function is used, then logsig is NOT an appropriate transfer
% function at the output. If the[-1 1] normalization is applied, then
% 'tansig' in both layers, or at least "purelin" at the output layer must
% be used.


%net.inputs{1}.processFcns={} %Remove the default input processing functions of min/max normalization, fixing unknowns and removing repeat instances
%net.outputs{2}.processfcns={} %Remove the default output processing functions

%net.divideFcn='';  %This removes the default data partitioning (normally 60%, 20%, 20%)

net.divideparam.trainRatio=TR_ratio;
net.divideparam.valRatio=V_ratio;
net.divideparam.testRatio=T_ratio;


net.trainParam.epochs = max_epochs;     % Maximum number of epochs to train
net.trainParam.goal = error_goal;     % Performance goal
net.trainParam.lr = 0.01;       % Learning rate
net.trainParam.lr_inc = 1.05;   % Ratio to increase learning rate
net.trainParam.lr_dec = 0.7; 	% Ratio to decrease learning rate
net.trainParam.max_fail = max_fail;    % Maximum validation failures
net.trainParam.max_perf_inc = 1.04;     % Maximum performance increase
net.trainParam.mc = 0.9;                % Momentum constant
net.trainParam.min_grad = 1e-10;        % Minimum performance gradient
net.trainParam.show = 50;               % Epochs between displays (NaN for no displays)
net.trainParam.showCommandLine = 0;     % Generate command-line output
net.trainParam.showWindow = 1;          % Show training GUI
net.trainParam.time = inf;              % Maximum time to train in seconds



%train and simulate the network
%[net,train_record,net_outputs,net_errors] = train(net,trainV,trainT,[],[],validation_data,test_data);

[net,train_record,net_outputs,net_errors] = train(net,tr_data,tr_labels);

%[Network_output ignore1 ignore2 Network_error Network_perf]= sim(net,test_data.P, [], [], test_data.T);

if nargin==4
%[Network_output ignore1 ignore2 Network_error Network_perf]= sim(net,ts_data, [], [], ts_labels);
Network_output=net(ts_data);
Performance = perform(net, ts_labels, Network_output);

%Compute confusion matrix for text display
[Conf_mat Ratio_mat test_perf]=confusion_matrix(Network_output, ts_labels);

Conf_mat
test_perf
Ratio_mat

%Graphical output of the confusion matrix
plotconfusion(ts_labels, Network_output)

else
    
Network_output= sim(net,ts_data);
test_perf = 'Test Performance cannot be computed without test data labels';
Conf_mat = 'Confidence matrix cannot be computed without test data labels';
Ratio_mat = 'Confidence matrix cannot be computed without test data labels';
end






%Overall correct class for the entire data
%[c1 d1]=max(Network_output);
%[c d]=max(test_data.T);
%JT=find(d == d1); % Find correctly classified signals
%IT=find(d ~= d1); % Find misclassified signals
%test_perf=100*(length(test_data.T)-length(IT))/length(test_data.T) % Performance on test dataset


if (test_flag==1)
if M==2  % if this is a 2-dimensional problem, we shall plot!
    
    [dummy predicted_class]=max(Network_output);
    figure
    colorarray = {'.r'; '.b'; '.g'; '.m'; '.k'; '.c'; '.y'};
    
    for i=1:size(tr_labels,1)
        I=find(predicted_class==i); % indices of test data for each class
        plot(ts_data(1,I), ts_data(2,I), colorarray{i}) %plot all instances that are classified as class "i"
        clear I
        hold on        
    end
    title('MLP based classification of the test data')   
end
end

