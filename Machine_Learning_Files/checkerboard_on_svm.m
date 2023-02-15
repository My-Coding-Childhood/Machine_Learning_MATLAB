clear
close all


[a b] = gendatcb(1000,.35,.5);
p = a(1:1000,:); 
t = b(1:1000,:);
tt=t;
t(find(t==2))=-1;

res=100;
x=linspace(0,1,res); y=x;
[xx yy]=meshgrid(x,y);
tdata=[reshape(xx,1,res^2); reshape(yy,1,res^2)];




SVMstruct=svmtrain(p,t, 'Kernel_Function', 'rbf', 'RBF_Sigma', 0.1, 'BoxConstraint', 0.1, 'showplot',true)

%SVMstruct=svmtrain(p,t, 'Kernel_Function', 'polynomial', 'Polyorder', 10, 'BoxConstraint', 1, 'showplot',true)

classes = svmclassify(SVMstruct,tdata','showplot',true);


figure
tdata=tdata';
plot(tdata(classes==1,1), tdata(classes==1,2),'k*');
hold on; 
plot(tdata(classes==-1,1), tdata(classes==-1,2),'r*');
hold off;