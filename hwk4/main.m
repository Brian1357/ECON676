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
%read returns
r_industry = xlsread('Problem_Set4.xls','industry');
r_PRP = xlsread('Problem_Set4.xls','PRP');
r_beme = xlsread('Problem_Set4.xls','BEME');
Rm = xlsread('Problem_Set4.xls','Rm');
rf = xlsread('Problem_Set4.xls','Rf');
%read time
time_industry = timeConv(xlsread('Problem_Set4.xls','industry_time'));
time_PRP = timeConv(xlsread('Problem_Set4.xls','PRP_time'));
time_beme = timeConv(xlsread('Problem_Set4.xls','BEME_time'));
time_rm = timeConv(xlsread('Problem_Set4.xls','Rm_time'));

%% Part 1
summary_industry = [mean(r_industry);std(r_industry);(mean(r_industry)-mean(rf))./std(r_industry)];

