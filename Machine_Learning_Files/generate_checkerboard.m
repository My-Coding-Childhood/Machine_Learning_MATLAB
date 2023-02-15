%Rotated checker board data
%Written by L.I. Kuncheva
%Modified by R. Polikar, Nov. 5, 2006.

%N: data size, a:side of each sqaure, alpha: angle of rotation.



function [d,labels]=generate_checkerboard(N,a,alpha);

d=rand(N,2);
d_transformed=[d(:,1)*cos(alpha)- d(:,2)*sin(alpha), d(:,1)*sin(alpha)+  d(:,2)*cos(alpha)];
s=ceil(d_transformed(:,1)/a)+floor(d_transformed(:,2)/a);

labels=2-mod(s,2);
rotated_data=d;
I1=find(labels==1);
I2=find(labels==2);
figure
plot(d(I1,1), d(I1,2), '.r', d(I2,1), d(I2,2), '.b')
