
function trainsvm(tr_data, tr_labels, ts_data, ts_labels);

% trainsvm.m for PR projects
% Trains and tests an SVM using validation dataset
% A portion of the data will be set aside for validation and testing
% Sample training routine using MATLAB's built in functions
% data: M-by-L data matrix of M instances. The data should be in the rows - L=number of features.
% classes: M-by-1 vector of correct labels
% svm: svm structure. All parameters of the svm.
% test-perf: scalar. Empirical (percentage) performance on test data
% Conf_mat: C-by-C confusion matrix
% Ratio_mat: C-by-C confusion matrix of the ratios
% postprocessing


% RobiPolikar
% Originally written October 23, 2012
% Rowan University.

if nargin<1
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


choice = questdlg(['Total data size is ', num2str(M), ' with ', num2str(L), ' features - Is this correct? Remember, data must be in rows'], ...
    'Verify Data Size', ...
    'Yes','No ', 'No ');
if choice == 'No '
    errordlg('Please resize your data matrices and try again'); return
end

%
% if (test_flag==1)
%
%     prompt={'You have provided separate test data. Therefore this program will NOT do a separate cross-validation'};
%     %One can also create their own partitioning of the data - We will not
%     %use this, as Matlab will take care of this.
%     % [tr_data,val_data,dummy1,trainInd,valInd,testInd] = dividerand(train_data,TR_ratio,V_ratio,T_ratio);
%     % [tr_labels,val_labels,dummy2] = divideind(train_labels,trainInd,valInd,testInd);
%
% end
%
%
% if (test_flag==0)
%
%     prompt={'What % of data should be used for validation?', 'What % of data should be used for internal testing?'};
%     name='Data Partitioning:';
%     numlines=1;
%     defaultanswer={'20', '20'};
%     design_response=(inputdlg(prompt,name,numlines,defaultanswer, 'on'));
%     V_ratio=str2num(design_response{1})/100;
%     T_ratio=str2num(design_response{2})/100;
%     TR_ratio=1-V_ratio-T_ratio;
%     msgbox(['Using ', num2str(round(L*TR_ratio)), ' instances for training, ', ...
%         num2str(round(L*V_ratio)), ' for validation and ', num2str(round(L*T_ratio)), ' for testing.'], 'Verify Data Partitioning', 'warn')
%
%     [tr_data,val_data,ts_data,trainInd,valInd,testInd] = dividerand(tr_data,TR_ratio,V_ratio,T_ratio);
%     [tr_labels,val_labels,ts_labels] = divideind(tr_labels,trainInd,valInd,testInd);
%
% end

%UPdate the data size after the partitioning

%Let's shuffle the data
I=randperm(M);
tr_data=tr_data(I,:);
tr_labels=tr_labels(I,:);
clear I



% train the svm
prompt={'Boxconstrain (C) parameter', 'Choose kernel (linear, rbf or polynomial)' , 'Kernel parameter (sigma for RBF, d for poly)',...
    'Autoscale(true or false)', 'KKTviolation', 'Optimization Method (QP, SMO or LS)'};
name='SVM Parameters';
numlines=1;
defaultanswer={'1000', 'rbf', '1', 'false', '0.05', 'SMO'};
design_response=(inputdlg(prompt,name,numlines,defaultanswer, 'on'));
C=str2num(design_response{1});
kernel=(design_response{2});
kernel_param=str2num(design_response{3});
Autoscale=(design_response{4});
kkt_violation=str2num(design_response{5});
opt_method=(design_response{6});

% Replace with HyperparameterOptimizationOptions 
%options=[];
%if (opt_method=='SMO');
%    options=statset('Display', 'final', 'MaxIter', 30000);
%end

switch kernel
    case 'linear'
        svm=fitcsvm(tr_data, tr_labels, 'boxconstraint', C, 'KernelFunction', 'linear', ...
            'Solver',opt_method, 'KKTTolerance', kkt_violation);
    case 'rbf'
        svm=fitcsvm(tr_data, tr_labels, 'boxconstraint', C, 'KernelFunction', 'rbf', 'KernelScale', kernel_param, ...
            'Solver',opt_method, 'KKTTolerance', kkt_violation);
    case 'poly'
        svm=fitcsvm(tr_data, tr_labels, 'boxconstraint', C, 'KernelFunction', 'polynomial', 'PolynomialOrder', kernel_param, ...
            'Solver',opt_method, 'KKTTolerance', kkt_violation);
end

if nargin==4
    [predicted_labels]= predict(svm,ts_data);
    
    targets=ind2vec(ts_labels');
    outputs=ind2vec(predicted_labels');
    
    %Compute confusion matrix for text display
    %[Misclassification Confusion_matrix Indices Performances]=confusion(outputs, targets)
    
    %Graphical output of the confusion matrix
    figure
    plotconfusion(targets, outputs)
    
else
    
    [predicted_labels]= predict(svm,ts_data);
    
end


if (test_flag==1)
    if L==2  % if this is a 2-dimensional problem, we shall plot!
        
        figure
        colorarray = {'.r'; '.b'; '.g'; '.m'; '.k'; '.c'; '.y'};
        
        for i=1:length(unique(tr_labels))
            I=find(predicted_labels==i); % indices of test data for each class
            plot(ts_data(I,1), ts_data(I,2), colorarray{i}) %plot all instances that are classified as class "i"
            clear I
            hold on
        end
        title('SVM based classification of the test data')
    end
end

