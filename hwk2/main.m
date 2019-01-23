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
stocks = xlsread('Data.xlsx','A1:J1085');
rf = xlsread('Data.xlsx','K1:K1085');
%% Part 1
%Part a
%compute the covariance matrix, mean and standard deviation
V_stk = cov(stocks);
R_stk = (mean(stocks))';
R_rf = mean(rf);
std_stk = (std(stocks))';
one_vec = ones(length(R_stk),1);

[MVP,TP] = MVTP(R_stk,R_rf,V_stk);

EffFront = effFont(V_stk,R_stk,0.01,2);

plot1A;

%Part b
R_stk_b = (mean(stocks))'+std_stk/sqrt(1085);

[MVP_b,TP_b] = MVTP(R_stk_b,R_rf,V_stk);

EffFront_b = effFont(V_stk,R_stk_b,0.01,2);

plot1B;

%Part c
V_stk_c1 = diag(std_stk.^2);

EffFront_c1 = effFont(V_stk_c1,R_stk,0.01,2);

V_stk_c2 = diag(one_vec);
EffFront_c2 = effFont(V_stk_c2,R_stk,0.01,2);

plot1C;
plot1C_bonus;
%%
%Part d
[MVP_list,TP_list] = randSim(R_stk,R_rf,V_stk,1085,1000);
plot1D;

%Part e
[MVP_list_bst,TP_list_bst] = bstSim(stocks,R_rf,1085,1000);
plot1E;