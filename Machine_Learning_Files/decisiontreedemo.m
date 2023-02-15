% MATLAB CART decision tree demo
clc;
clear;
close all;

%Updated Nov 2015 for Matlab 2015a - Polikar

load fisheriris;

% SL: sepal length
% SW: sepal width
% PL: petal length
% PW: petal width
features = {'SL' 'SW' 'PL' 'PW'};
labels = [ones(50,1);2*ones(50,1);3*ones(50,1)];

train_pattern = [meas(1:45,:);meas(51:95,:);meas(101:145,:)];
train_labels = [labels(1:45);labels(51:95);labels(101:145)];
test_pattern = [meas(46:50,:);meas(96:100,:);meas(146:150,:)];
test_labels = [labels(46:50);labels(96:100);labels(146:150)];

tree = fitctree(train_pattern,train_labels,'PredictorNames',features,...
    'prune','on');

view(tree)
view(tree, 'mode', 'graph')    % graphically show the tree
display(tree) % print the tree properties to the command window

predictions = predict(tree,test_pattern);
cart_error = sum(test_labels~=predictions)/length(predictions);

pruned_tree = prune(tree,'level',2);

view(pruned_tree) % graphically show the tree
view(pruned_tree, 'mode', 'graph')
display(pruned_tree) % print the tree to the command window
predictions = predict(pruned_tree,test_pattern);
cart_pruned_error = sum(test_labels~=predictions)/length(predictions);