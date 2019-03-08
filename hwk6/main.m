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
%read time
date.FFF = xlsread('Problem_Set6.xls','date');
date.com = xlsread('Problem_Set6.xls','date_com');
date.pastret = xlsread('Problem_Set6.xls','date_125');

%read returns
r_ind = xlsread('Problem_Set6.xls','industry_30');
r_FFF = xlsread('Problem_Set6.xls','FFF');
r_com = xlsread('Problem_Set6.xls','com')*100;
r_pastret.pr1 = xlsread('Problem_Set6.xls','PR1');
r_pastret.pr212 = xlsread('Problem_Set6.xls','PR212');
r_pastret.pr1360 = xlsread('Problem_Set6.xls','PR1360');
  
%handle missing value
r_ind(r_ind <= -99) = nan;
r_FFF(r_FFF <= -99) = nan;
r_com(r_com <= -99) = nan;
r_pastret.pr1(r_pastret.pr1 <= -99) = nan;
r_pastret.pr212(r_pastret.pr212 <= -99) = nan;
r_pastret.pr1360(r_pastret.pr1360 <= -99) = nan;


%% data processing
% part a
[indmom.r1,indmom.sumstat.summary1] = mom(r_ind,r_FFF(:,4),1,1,3);

%% part b
% -- compont 1
indmom.compnts.varmean = var(nanmean(r_ind));
% -- compont 2
indmom.betas = zeros(1,30);
for i = 1:length(indmom.betas)
    temp = regress(r_ind(:,i),[ones(1085,1),r_FFF(:,1)]);
    indmom.betas(1,i) = temp(2);
end
temp = cov(r_FFF(2:end,1),r_FFF(1:end-1,1));
indmom.compnts.betaAuto = var(indmom.betas)*temp(1,2);
% -- compont 3
indmom.resid = zeros(1085,30);
for i = 1:length(indmom.resid(1,:))
    [~,~,indmom.resid(:,i)] = regress(r_ind(:,i),[ones(1085,1),r_FFF(:,1)]);
end

indmom.residAutoRaw = zeros(1,30);
for i = 1:length(indmom.residAutoRaw)
    temp = nancov(indmom.resid(2:end,i),indmom.resid(1:end-1,i));
    indmom.residAutoRaw(1,i) = temp(1,2);
end
indmom.compnts.residAuto = nanmean(indmom.residAutoRaw);
indmom.compnts.total = indmom.compnts.varmean + indmom.compnts.betaAuto + indmom.compnts.residAuto;
clear temp
%% part c

[indmom.r112,indmom.sumstat.summary112] = mom(r_ind,r_FFF(:,4),1,12,3);
% part d
[indmom.r212,indmom.sumstat.summary212] = mom(r_ind,r_FFF(:,4),2,12,3);
%% part e
result = fitlm(r_FFF(:,1:3),indmom.r1);
indmom.FF3.result1 = result.Coefficients;

result = fitlm(r_FFF(:,1:3),indmom.r112);
indmom.FF3.result112 = result.Coefficients;

result = fitlm(r_FFF(:,1:3),indmom.r212);
indmom.FF3.result212 = result.Coefficients;
clear result
%% part f
result = fitlm(r_FFF(:,[1,2,3,5]),indmom.r1);
indmom.FF4.result1 = result.Coefficients;

result = fitlm(r_FFF(:,[1,2,3,5]),indmom.r112);
indmom.FF4.result112 = result.Coefficients;

result = fitlm(r_FFF(:,[1,2,3,5]),indmom.r212);
indmom.FF4.result212 = result.Coefficients;
clear result
%% part g-i
% --past 1 month
[commom.r1,commom.sumstat.summary1] = mom(r_com,r_FFF(523:1074,4),1,1,3);
% -- past 1~12-month returns
[commom.r112,commom.sumstat.summary112] = mom(r_com,r_FFF(523:1074,4),1,12,3);
% --past 2~12-month returns
[commom.r212,commom.sumstat.summary212] = mom(r_com,r_FFF(523:1074,4),2,12,3);
%% part g-ii
% -- 3-factor FF model
result = fitlm(r_FFF(523:1074,1:3),commom.r1);
commom.FF3.result1 = result.Coefficients;

result = fitlm(r_FFF(523:1074,1:3),commom.r112);
commom.FF3.result112 = result.Coefficients;

result = fitlm(r_FFF(523:1074,1:3),commom.r212);
commom.FF3.result212 = result.Coefficients;
% -- 4-factor FF model
result = fitlm(r_FFF(523:1074,[1,2,3,5]),commom.r1);
commom.FF4.result1 = result.Coefficients;

result = fitlm(r_FFF(523:1074,[1,2,3,5]),commom.r112);
commom.FF4.result112 = result.Coefficients;

result = fitlm(r_FFF(523:1074,[1,2,3,5]),commom.r212);
commom.FF4.result212 = result.Coefficients;

%% part g-iii
temp = nancov(indmom.r1(523:1074),commom.r1);
commom.corr.corr1 = temp(1,2)/(nanstd(indmom.r1(523:1074))*nanstd(commom.r1));
temp = nancov(indmom.r112(523:1074),commom.r112);
commom.corr.corr112 = temp(1,2)/(nanstd(indmom.r112(523:1074))*nanstd(commom.r112));
temp = nancov(indmom.r212(523:1074),commom.r212);
commom.corr.corr212 = temp(1,2)/(nanstd(indmom.r212(523:1074))*nanstd(commom.r212));
clear temp
%% part g-iv
result = fitlm([r_FFF(523:1074,1:3),commom.r112],indmom.r112(523:1074));
indmom.FF3.result_com = result.Coefficients;
% part g-v
result = fitlm([r_FFF(523:1074,1:3),indmom.r112(523:1074)],commom.r112);
commom.FF3.result_com = result.Coefficients;
%% part h

GRS_t.rslt1 = GRS([ones(1090-11,1),r_FFF(7:end,[1,2,3,5])],r_pastret.pr1(12:end,:)-r_FFF(7:end,4));
GRS_t.rslt12 = GRS([ones(1090-11,1),r_FFF(7:end,[1,2,3,5])],r_pastret.pr212(12:end,:)-r_FFF(7:end,4));
GRS_t.rslt60 = GRS([ones(1090-59,1),r_FFF(55:end,[1,2,3,5])],r_pastret.pr1360(60:end,:)-r_FFF(55:end,4));
