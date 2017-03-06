clc 
clear all 

% random seed initialization 
% TODO 

% data parameters 
N = 100;
r_array = [0, 10];  % outlier ratio: 0 / 10 (%)
tau = 0.1;

x_max = 10;
x_min = -10;
y_max = 10;
y_min = -10;

domain = [x_min, x_max, y_min, y_max];

% model parameters
a = 1;
b = 0;
noise_radius = 0.1;

%% DATA GENERATION, IRLS & L1, LP & L1, LP & Linf
data = zeros(N, 2, size(r_array, 2));

% result 
result_L1_IRLS = zeros(2, 1);

for i=1:size(r_array, 2)
    %% DATA GENERATION
    % outlier_ratio
    r = r_array(i);
    n_inlier = int32(N * (1 - r/100));
    n_outlier = int32(N * r/100);
    
    disp('======================================')
    disp(['data generating for r = ', num2str(r)])
    
    % inlier_vector 
    inlier_vectors = GenerateInlierData('line', N, r, tau, domain, [a, b], noise_radius);
    
    % outlier_vector 
    outlier_vectors = GenerateOutlierData('line', N, r, tau, domain, [a, b]);
    
    disp('data verifying... ')
    
    % data verification 
    n_inlier_verified = nnz(abs(Cost('vertical', inlier_vectors, [a,b])) <= tau);
    n_outlier_verified = nnz(abs(Cost('vertical', outlier_vectors, [a,b])) > tau);
    
    % assert error if number of inliers/outliers are different with setup
    assert(n_inlier_verified == n_inlier);
    assert(n_outlier_verified == n_outlier);
    assert(n_inlier_verified + n_outlier_verified == N);
    
    disp(['data verified! (# of inlier = ', num2str(n_inlier), ', # of outlier = ', num2str(n_outlier), ')'])
    disp(' ')
    
    % generated data
    data(:,:,i) = [inlier_vectors; outlier_vectors];   
    
    %% IRLS & L1
    
    %% LP & L1
    
    %% LP & Linf
end

%% PLOTS
disp('======================================')
disp('plot...')

for i=1:size(r_array, 2)
    % new figure
    figure(i+1)
    
    % synthetic model
    syms x_syn y_syn
    
    % plotting
    ezplot(y_syn == a * x_syn + b, [x_min, x_max]);
    hold on
    plot(data(:, 1, i), data(:, 2, i), 'bo')
    hold off
end

