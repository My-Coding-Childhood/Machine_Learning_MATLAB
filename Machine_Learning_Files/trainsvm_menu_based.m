 
clear
close all
clc
dataset=menu('Choose Dataset', 'Gaussian', 'Checkerboard', 'Spiral', 'Banana');

switch dataset
    case 1  % Gaussian
        
        MU =[-1 2; 1 3];
        Sigma1 = [.9 .4; .4 .3];
        Sigma2 = [1 0; 0 1];
        SIGMA{1}=Sigma1; SIGMA{2}=Sigma2;
        X=[-5:0.1:5];
        Y=[-8:0.1:8];
        COUNT=[1000 1000];
        [Gaussian tr_data class tr_labels]=generate_multiple_gauss2d(MU, SIGMA, COUNT);
        ts_data=create_griddata2(-6:0.05:6, -4:0.05:8);
        tr_labels=vec2ind(tr_labels);
        tr_labels=tr_labels';
        trainsvm(tr_data, tr_labels, ts_data);        
        
    case 2  %Checkerboard
        N=5000; %Number of data points
        a=0.2; %length of each square
        alpha=pi/3; % angle of rotation
        [tr_data,tr_labels]=generate_checkerboard(N,a,alpha);
        ts_data=create_griddata2(linspace(0,1, 250), linspace(0,1,250));
        trainsvm(tr_data, tr_labels, ts_data);        
                    
    case 3 %Spiral Data
        [spiral spiral_2d_data labels tr_labels] = generate_spiral(1000, 2*pi, 2, 0.2);
        tr_data=spiral_2d_data;
        tr_labels=vec2ind(tr_labels);
        tr_labels=tr_labels';
        ts_data=create_griddata2(-8:0.1:8, -6:0.1:6);
        trainsvm(tr_data, tr_labels, ts_data);        
         
    case 4 %Banana Data
        
        N=100;
        s=1;
        [tr_data, tr_labels]=generate_banana(N,s);
        %ts_data=create_griddata2(-12:0.1:8, -12:0.1:8);
        [ts_data, ts_labels]=generate_banana(2000,s);
        trainsvm(tr_data, tr_labels, ts_data, ts_labels);        
            
end
