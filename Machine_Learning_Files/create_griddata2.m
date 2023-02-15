function Grid=create_griddata2(x,y);

%Create 2-dimensional grid data
%x: N values of x-dimension
%y: M values of y-dimension
%Grid: The grid data that consists of N*M 2-pairs for all combinations of x
%and y

% (C) Robi Polikar, 09/16/2009

N=length(x);
M=length(y);

for i=1:N
    for j=1:M
        Grid((i-1)*M+j,:)=[x(i), y(j)];
    end
end