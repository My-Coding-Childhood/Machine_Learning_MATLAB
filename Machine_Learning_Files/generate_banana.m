%GENENATE_BANANA Generation of banana shaped classes
% 
% [banana_data banana_labels]=generate_banana(N,S);
% 
% INPUT
% N number of generated samples of vector with 
% number of samples per class
% S variance of the normal distribution (opt, def: s=1)
%
% OUTPUT
% A generated dataset
%
% DESCRIPTION
% Generation of a 2-dimensional 2-class dataset A of 2*N objects with a
% banana shaped distribution. The data is uniformly distributed along the
% bananas and is superimposed with a normal distribution with standard
% deviation S in all directions. Class priors are P(1) = P(2) = 0.5.
% 
% SEE ALSO
% DATASETS, PRDATASETS

% Modified by Robi Polikar from the following authors' code
% Copyright: A. Hoekstra, R.P.W. Duin, duin@ph.tn.tudelft.nl
% Faculty of Applied Sciences, Delft University of Technology
% P.O. Box 5046, 2600 GA Delft, The Netherlands

% $Id: gendatb.m,v 1.3 2003/07/21 09:27:21 davidt Exp $

function [banana_data banana_labels] = generate_banana(N,s)

% Default size of the banana: 
r = 5;
   % Default class prior probabilities:
%p = [0.5 0.5];
%N = genclass(N,p);
N=[N N];

domaina = 0.125*pi + rand(1,N(1))*1.25*pi;
class1 = [r*sin(domaina') r*cos(domaina')] + randn(N(1),2)*s;

domainb = 0.375*pi - rand(1,N(2))*1.25*pi;
class2 = [r*sin(domainb') r*cos(domainb')] + randn(N(2),2)*s + ...
         ones(N(2),1)*[-0.75*r -0.75*r];
%lab = genlab(N);

%a = dataset(a,lab,'name','Banana Set','lablist',genlab([1;1]),'prior',p);
banana=[class1; class2];
labels=[ones(N(1),1); 2*ones(N(1),1)];

I=randperm(sum(N));
banana_data=banana(I,:);
banana_labels=labels(I);

clear class1 class2
I1=find(banana_labels==1);
I2=find(banana_labels==2);

plot(banana_data(I1,1), banana_data(I1,2), '.b'); hold on
plot(banana_data(I2,1), banana_data(I2,2), '.r'); 




return
