function p=generate_gauss2d(X,Y, MU, SIGMA)
% This function creates a 2D Gaussian probability distribution funnction
% Then, it randomly draws data from a 2D gaussian distribution and plots it
% MU: Mean vector, its length must be equalt to 2 (must be column vector)
% SIGMA: Covariance vector, must be semi-positive definite matrix of 2x2
% X and Y: Cartesian cooridnates of the points at which the Gaussian will
% be computed

%(c) Robi Polikar, August 2009, 2009


% Sample usage
% mu=[-1 1];
% Sigma = [.9 .4; .4 .3];
% X=-10:0.05:10;
% Y=-10:0.05:10;


close all


I=length(X);
J=length(Y);

p=zeros(I,J);


for i=1:I
    for j=1:J
        p(i,j) = mvnpdf([X(i) Y(j)],MU,SIGMA);
    end
end

subplot(221)
mesh(X,Y,p');
title('The theoretical distribution of 2-D Gaussian')
grid on


RND = mvnrnd(MU,SIGMA,10000);  %RND: Random, normally distributed multivariate data
subplot(222)
plot(RND(:,1),RND(:,2),'r.')
title('10000 data points randomly drawn from 2D Gaussian')
grid on


subplot(223)
hist3(RND, [30 30]); %This one plots the histogram on a 30x30 bin array
histogram=hist3(RND, [30 30]); %This returns the histogram data, but does not plot the histogram itself
title('3-D Histogram of the 2-D data')
histogram1 = histogram'; 
histogram1( size(histogram,1) + 1 ,size(histogram,2) + 1 ) = 0; 

% Generate grid for 2-D projected view of intensities
xb = linspace(min(RND(:,1)),max(RND(:,1)),size(histogram,1)+1);
yb = linspace(min(RND(:,2)),max(RND(:,2)),size(histogram,1)+1);

% Make a pseudocolor plot on this grid 
subplot(224)
handle = pcolor(xb,yb,histogram1);
set(handle, 'zdata', ones(size(histogram1)) * -max(max(histogram))) 
colormap(hot) % heat map 
colorbar('location', 'EastOutside')
title('Pseudocolor plot of the 3-D histogram of the 2-D Guassian random data');
grid on 
%colorbar('location', 'southoutside')

figure
hist3(RND, [30 30]); %THis one plots the histogram on a 30x30 bin array with a transparency factor of 0.5
histogram=hist3(RND, [30 30], 'FaceColor', 'interp', 'FaceAlpha', 0.55); %This returns the histogram data, but does not plot the histogram itself
title('3-D Histogram of the 2-D data')
set(gcf,'renderer','opengl');
hold on
handle2 = pcolor(xb,yb,histogram1);
set(handle2, 'zdata', ones(size(histogram1)) * -max(max(histogram)), 'FaceColor', 'interp', 'FaceAlpha', 0.55) 
colormap(hot) % heat map 
title('Pseudocolor plot of the 3-D histogram of the 2-D Guassian random data');
grid on 

view(3)