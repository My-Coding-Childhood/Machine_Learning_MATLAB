%get checkers and inputs and targets
[a, b] = gendatcb(10000,.45,.5);
p = [a(1:500,:)']; 
t = [b(1:500,:)'];
ptest=[a(501:10000,:)'];

%t values are 1s and 2s. 
%If target array needs binary, uncomment (change the plot command as well),
%and change t to tt in network initialization
%t(find(t==2))=0;
%t2=zeros(1,length(t));
%t2(find(t==0))=1;
%tt=[t; t2];

net=newff(p,t,20);
net.trainParam.lr=0.5;
net.trainParam.epochs=1000; 
net.trainparam.goal=1e-2; 
net=train(net,p,t)

%simulation of test data
y=sim(net,ptest)

%plotting section
z=ceil(y);

ptest=ptest';
plot(ptest(z==1,1), ptest(z==1,2),'k*');
hold on; 
plot(ptest(z==2,1), ptest(z==2,2),'r*');