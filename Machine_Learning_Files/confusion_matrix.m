function [conf_mat Ratio_mat Test_perf]=confusion_matrix(net_out, test_class);

%Returns the confusion matrix and the ratio matrix, which is the same
%information in percentages. 

%net_out: actual network outputs for the given set of test data
%test_class: correct classes for the test data - rows is the number of
%classes, columns is the number of instances.

%Robi Polikar
%October 2007

C=size(test_class,1);

[out max_index]=max(net_out);
correct_class=vec2ind(test_class);

conf_mat=zeros(C,C);

for i=1:C
    %First determine which test instances belong to class "i"
    members_of_class{i}=find(correct_class==i); 
    %Of those class "i" instances, which ones are classified as class "j"
    for j=1:C
        conf_mat(i,j)=length(find(max_index(members_of_class{i})==j));
    end
    Ratio_mat(i,:)=100*conf_mat(i,:)/length(members_of_class{i});
end

Test_perf=100*(1-nnz(max_index-correct_class)/size(test_class,2));

%Rows are correct class, columns are predicted classes