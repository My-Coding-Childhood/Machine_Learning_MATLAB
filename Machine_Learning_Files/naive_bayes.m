function [labels prob]=naive_bayes(tr_data, tr_labels, ts_data, ts_labels);

%This function implements the naive Bayes classifier based on the
%assumption that class conditional probabilities are independent and
%Gaussian. Each feature is assumed to be normally distributed, but with
%different parameters. The program computes these parameters using the
%maximum likelihood estimate.

% tr_data:   Training data, in the columns, that is, each column is an 
%            instances, and each row is a feature. 
% tr_labels:  Correct labels for the training data. Should be in the form of
%            1, 2, 3, etc.
% ts_data:   Validation data to be used for testing. Same format as tr_data
% ts_labels: Labels for ts_data. Same format as tr_labels.


close all


if nargin<0
    errordlg('You must provide at least training and test data.', 'Incorrect number of inputs'); return
end

%Verify data formatting - Assume the number of training data samples is
%fewer than the dimensionality.

if size(tr_data,1)>size(tr_data,2)
    tr_data=tr_data'; 
end

if size(tr_labels,1)>size(tr_labels,2)
    tr_labels=tr_labels'; 
end

if size(ts_data,1)>size(ts_data,2)
    ts_data=ts_data'; 
end

if size(ts_labels,1)>size(ts_labels,2)
    ts_labels=ts_labels'; 
end


if (nargin==3 ||nargin==4)
    test_flag=1;
    [TE_M TE_L]=size(ts_data);
end

[M L]=size(tr_data);

if nargin==2  %if no test data provided
    test_flag=0;
    if M==2 %for two-dimensional data, generate X and Y grid locations
        gridsize=100;
        xmax=max(max(tr_data(1,:)));
        ymax=max(max(tr_data(2,:)));
        xmin=min(min(tr_data(1,:)));
        ymin=min(min(tr_data(2,:)));
        X=linspace(xmin, xmax,gridsize);
        Y=linspace(ymin, ymax,gridsize);
        ts_data=create_griddata2(X,Y);
        ts_data=ts_data'; %ts_data need to be in columns
    end
end



%%For Training and validation data, call the following function
%MU =[-1 2 3; 1 3 0];
%Sigma1 = [.9 .1; .1 .6];
%Sigma2 = [1 -0.5; -0.5 1];
%Sigma3 = [.3 0.8; 0.8 5];
%X=[-5:0.1:5];
%Y=[-8:0.1:8];

% 
% MU =[3 7 2; 2 4 5];
% Sigma1 = [2 0; 0 2];
% Sigma2 = [2 0; 0 2];
% Sigma3 = [2 0; 0 2];
% X=[-2:0.1:10];
% Y=[-2:0.1:10];
% 
% %Change the prior probabilities to see real effect!!!
% 
% SIGMA{1}=Sigma1; SIGMA{2}=Sigma2; SIGMA{3}=Sigma3;
% tr_COUNT=[500 500 500];
%  
% [Gaussians tr_data tr_labels]=generate_multiple_gauss2d(MU, SIGMA, tr_COUNT);
% tr_data=tr_data';
% 
% %Generate validation data grid
% 
% for i=1:length(X)
%    for j=1:length(Y)
%        ts_data((i-1)*length(Y)+j,:)=[X(i) Y(j)];
%    end
% end
% ts_data=ts_data';
% %================END OF DATA GENERATION=======================

%====BEGIN NAIVE BAYES========


%Determine data, class and feature sizes
[num_features, num_instance]=size(tr_data);
num_ts_data=size(ts_data,2);

label_format = isvector(tr_labels);
%if tr_labels are given in a binary encoded matrix, label_format will be
%zero, otherwise it will be "1"

if ~label_format
    [dummy tr_labels]=max(tr_labels);
    [dummy ts_labels]=max(ts_labels);
end

num_class=max(tr_labels);


% Training the Naive Bayes - 
% compute the Gaussian parameters for each clas and for each feature

for j=1:num_class 
    clear index_for_class_j
    clear data_for_class_j
    %Partition the data to individual classes
    index_for_class_j=find(tr_labels==j);
    data_for_class_j=tr_data(:,index_for_class_j);
    %Prior probabailities are based on data sizes in each class
    prior(j)=size(data_for_class_j, 2)/num_instance;
    for i=1:num_features
        mu(i,j)=mean(data_for_class_j(i,:));
        sigma(i,j)=std(data_for_class_j(i,:))+0.001; %0.001 is a regularization parameter to avoid zero sigma
    end
   
end

%Evaluation - compute the likelihoods for the validation data

for n=1:num_ts_data
    for j=1:num_class
        temp_likelihood=1;
        %Compute likelihoods based on the Gaussianity assumption
        for i=1:num_features
            temp_likelihood=temp_likelihood*normpdf(ts_data(i,n),mu(i,j), sigma(i,j));
        end
        %Compute the posterior probabilities
        NB_posterior(n,j)=prior(j)*temp_likelihood;
    end
    [max_posterior(n) NB_label(n)]=max(NB_posterior(n,:));
end


%=====MATLAB BUILT IN NAIVE BAYES

%The naive Bayes object requires the training data to be in the rows%
nb=NaiveBayes.fit(tr_data', tr_labels');
nb_label=nb.predict(ts_data');


% for 2-dimensional data, create the results on a grid grid
if M==2
    
    for i=1:length(X)
        for j=1:length(Y)
            my_predicted_labels(i,j)=NB_label((i-1)*length(Y)+j);
            nb_predicted_labels(i,j)=nb_label((i-1)*length(Y)+j);
            
        end
    end
    
    %Make sure that class colors match through colormap.
    RGB=zeros(64,3);
    RGB(1:21,:)=repmat([1 0 0],21,1);
    RGB(22:43,:)=repmat([0 1 0],22,1);
    RGB(44:64,:)=repmat([0 0 1],21,1);
    
    figure
    %Plot the results
    pcolor(X,Y, my_predicted_labels')
    shading interp
    title('{\bf Decision boundaries generated by naive Bayes implemented from scratch}')
    colormap(RGB);
    colorbar;
    
    figure
    pcolor(X,Y, nb_predicted_labels')
    shading interp
    title('{\bf Decision boundaries generated by Matlabs naive Bayes}')
    colormap(RGB);
    colorbar;
    
end


            
 