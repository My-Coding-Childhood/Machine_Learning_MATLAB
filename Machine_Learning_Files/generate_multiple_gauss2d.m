function [Gaussians Alldata Class Labels]=generate_multiple_gauss2d(MU, SIGMA, COUNT)
% This function generates multiple 2D Gaussian data 

% MU: 2-by-M mean vectors for the individual Gaussians. THe means must be
% structured such that the means are in the columns. THe number or rows
% must be 2 (for 2D Gaussians) and the number of columns are the number of
% Gaussians. M is then the number of "means" ==> number of Gaussians.

% SIGMA is a 1-by-L cell array, where each cell is a 2x2 covariance matrix.
% L is the number of Gaussians, and must be equal to M.
% COUNT is a 1-by-L array indicating the number of data points to be generated
% for each Gaussian.

% Gaussians is a 1-by-L cell array, each cell is a COUNT-by-2 matrix
% Alldata is a COUNT*L-by-2 matrix of all data
% Class is a COUNT*L-by-1 array of correct class information (1, 2, 3,..) 
% Labels carries the same information as Class in binary encoding format for
% MLP training.
%Robi Polikar, 09/20/2007, Updated 09/09/09



%Example
% 
% MU =[-1 2 3; 1 3 0];
% Sigma1 = [.9 .4; .4 .3];
% Sigma2 = [1 0; 0 1];
% Sigma3 = [.3 0.8; 0.8 3];
% SIGMA{1}=Sigma1; SIGMA{2}=Sigma2; SIGMA{3}=Sigma3;
% X=[-5:0.1:5];
% Y=[-8:0.1:8];
% COUNT=[200 1000 500];
%  


close all

[N M]=size(MU); %M number of Gaussians to be mixed
L=length(SIGMA); %L=M Number of Gaussians to be mixed

if N~=2
    disp('Error, the mean vectors must be of two components each')
end

if L~=M
    disp('Error, the number of gaussian mixtures should be the same in both mean and covariance matrices')
end

colorarray = ['r'; 'b'; 'g'; 'm'; 'k'; 'c'; 'y'];
shapearray = ['.'; '.'; '.'; '.'; '.'; '.'; '.'];

%shapearray = ['.'; 's'; 'o'; 'd'; 't'; 'x'; 'h'];

Alldata=[];
Class=zeros(sum(COUNT), 1);  

SumCount=[0 cumsum(COUNT)];

for l=1:L
    Gaussians{l} = mvnrnd(MU(:,l),SIGMA{l},COUNT(l));  
    %Gaussian: 1-by=L cell array, each cell is a COUNT-by-2 matrix of 
    %normally distributed multivariate data accourding to MU and SIGMA{l}
    Alldata = [Alldata; Gaussians{l}(:,:)];
    Class(SumCount(l)+1: SumCount(l+1))=l;
    plot(Gaussians{l}(:,1),Gaussians{l}(:,2),[eval('shapearray(l)') eval('colorarray(l)')]); 
    title('{\bf Randomly generated Gaussian data}')
    hold on
end
grid on


S=sum(COUNT);
Labels=zeros(3,S);
for i=1:S
Labels(Class(i), i)=1;
end

