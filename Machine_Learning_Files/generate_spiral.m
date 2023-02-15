function [spiral spiral_2d_data labels tr_labels] = generate_spiral(N, RangeMax, S, B)
% GENSPIRAL: Generate Spiral Patterns
% spiral = genparametric(N, RangeMax, Spirals, B)
%
%   Generate spirals using parametric equations
%
%     INPUT
%         N: number of points made
%         RANGEMAX: t -> linspace(0,RangeMax,N), some multiple of pi
%         S: number of spirals to generate 
%         B: noise level (using randn(.))
%     OUTPUT
%         spirals: X contains the X and Y values of the 
%             generated data, two columns per spiral - so, e.g., for three
%             spirals, X will have 6 columns, one column of x and y for each spiral. 
%         spiral_2d_data: data in Nx2 format to be used by other
%         classifiers
%         labels: corresponsing labes for the spiral_2d_data
%          tr_labels: binary encoded labels for MLP training [0 1 0] format
%
% By - Greg Ditzler - Modified by Robi Polikar
% June 2009

%Function Starts Here
theta = linspace(0, RangeMax, N);
k = 1;

% Try varying these 4 parameters.
angle = 2*pi/S;      % rotation angle



%
%generate the spiral data set
%
for n = 1:S,
    %generate parametric equations
 
      
    x = theta.*cos(theta);
    y = theta.*sin(theta);
    
    sc = cos((n-1) * angle) ;
    ss = sin((n-1) * angle) ;
    
    % rotation transformation matrix to separe the spirals from each other
    T = [ sc ss; ss  -sc];
    
    %combine all the components 
    A = [x;y]';
    Z = A*T;
    
    %save into a matrix
    spiral(k,:) = Z(:,1);
    spiral(k+1,:) = Z(:,2);
    
    %increment the counter for the index of the vectors
    %in the 'X' matrix
    k = k +2;
end


%
%add in some gaussian noise
%
[m n] = size(spiral);
nu = B * randn(m,n);
spiral = spiral + nu;
spiral=spiral';

figure
colorarray = {'.r'; '.b'; '.g'; '.m'; '.k'; '.c'; '.y'};

for i=1:S
    index=[2*(i-1)+1 2*(i-1)+2];  %index will be [1 2], [3 4], [5 6], etc.
    plot((spiral(:,index(1))), (spiral(:,index(2))), colorarray{i})
    spiral_2d_data((i-1)*N+1:i*N,:)=[spiral(:,index(1)), spiral(:,index(2))];
    labels((i-1)*N+1:i*N)=i;
    clear I
    hold on
    grid on
end
title('Spiral data')

tr_labels=zeros(S,S*N);
for i=1:S*N
tr_labels(labels(i), i)=1;
end


%Combine the spirals into a single two column vector.

        


