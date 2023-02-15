clear 
close all

dataset=menu('Choose Dataset', 'Gaussian', 'Checkerboard', 'Spiral', 'OCR');

switch dataset
    case 1  % Gaussian
        
        MU =[-1 2 3; 1 3 0];
        Sigma1 = [.9 .4; .4 .3];
        Sigma2 = [1 0; 0 1];
        Sigma3 = [.3 0.8; 0.8 3];
        SIGMA{1}=Sigma1; SIGMA{2}=Sigma2; SIGMA{3}=Sigma3;
        X=[-5:0.1:5];
        Y=[-8:0.1:8];
        COUNT=[200 1000 500];
        [Gaussian tr_data class tr_labels]=generate_multiple_gauss2d(MU, SIGMA, COUNT);
        tr_data=tr_data';
        ts_data=create_griddata2(-2.5:0.05:4, -4:0.05:5);
        ts_data=ts_data';
        [net, train_record, test_perf, Conf_mat, Ratio_mat, Network_output] = trainmlp_validation(tr_data, tr_labels, ts_data);
        
    case 2  %Checkerboard
        N=5000; %Number of data points
        a=0.2; %length of each square
        alpha=pi/3; % angle of rotation
        [tr_data,tr_labels]=generate_checkerboard(N,a,alpha);
        tr_data=tr_data';
        tr_labels=full(ind2vec(tr_labels'));
        ts_data=create_griddata2(linspace(0,1, 250), linspace(0,1,250));
        ts_data=ts_data';
        [net, train_record, test_perf, Conf_mat, Ratio_mat, Network_output] = trainmlp_validation(tr_data, tr_labels, ts_data);
        
    case 3 %Spiral Data
        [spiral spiral_2d_data labels tr_labels] = generate_spiral(1000, 2*pi, 3, 0.2);
        spiral_2d_data=spiral_2d_data';
        ts_data=create_griddata2(-6:0.1:6, -6:0.1:6);
        ts_data=ts_data';
        [net, train_record, test_perf, Conf_mat, Ratio_mat, Network_output] = trainmlp_validation(spiral_2d_data, tr_labels, ts_data);
        
    case 4 %OCR Data
        
        load opt_test
        load opt_train
        load opt_class.mat
        load opttest_class
        
        [net, train_record, test_perf, Conf_mat, Ratio_mat, Network_output] = trainmlp_validation(opt_train, opt_class, opt_test, opttest_class);
        
end
