% main.m
% This script when run should compute all values and make all plots
% required by the project.
% To do so, you must fill the functions in the functions/ folder,
% and create scripts in the scripts/ folder to make the required
% plots.

% Add folders to path
addpath('./functions/','./scripts/');

% Add plot defaults
plotDefaults;
%% read data
fac_mean = mean(factors);
fac_std = std(factors);

factor_stdized = (factors-fac_mean)./fac_std;

result_FM = FamaMac(returns-rf,factors);

result_FM_std = FamaMac(returns-rf,factor_stdized);

plot7b;

result_FM_std_DT = FamaMac(returns-rf,factor_stdized(:,1:2));
result_FM_std_RD = FamaMac(returns-rf,factor_stdized(:,6:7));
result_FM_std_VSM = FamaMac(returns-rf,factor_stdized(:,3:5));


%% question 4

mean_4 = [9.02,10.61,11.83,6.91,11.02]/100;
sig = [42.61,19.08,38.48,29.81,18.97]/100;
corr_mat = [1,0.65,0.79,0.64,0.72;0.65,1,0.68,0.8,0.96;0.79,0.68,1,0.77,0.78;...
    0.64,0.80,0.77,1,0.85;0.72,0.96,0.78,0.85,1];
cov_mat = diag(sig)*corr_mat*diag(sig);

GRS_stat = GRS_para_2(mean_4,cov_mat,11.02/100,18.97/100,0.02,92);

%% question 2
corr_mat = [1,0.5,0,0;0.5,1,0,0;0,0,1,0.5;0,0,0.5,1];
std_mat = diag([0.1,0.25,0.2,0.25]);
cov_mat = std_mat*corr_mat*std_mat;

mean_mat = [0.1,0.12,0.15,0.2];
% 提取function中的ABCD，求efficient frontier
[frontier,MVP,MVP_w, TanP, TanP_w]= mvp(mean_mat,cov_mat,0,0,'asd', 'edf');


disp('b')
sqrt((TanP(2)/TanP(1))^2+1)-sqrt((0.12/0.25)^2+1)

[frontier_rf,MVP_rf,MVP_w_rf, TanP_rf, TanP_w_rf]= mvp(mean_mat,cov_mat,0.02,0,'asd', 'edf');
 
disp('d')
sqrt(((TanP_rf(2)-0.02)/TanP_rf(1))^2+1)-sqrt(((0.12-0.02)/0.25)^2+1)

idio_risk = idioR(diag(std_mat),TanP(1),cov_mat, TanP_w');