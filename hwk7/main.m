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
date.SP = xlsread('Problem_Set7.xls','SP-date');
date.FF = xlsread('Problem_Set7.xls','FF-date');

%read returns
r_FFF = xlsread('Problem_Set7.xls','FF');
r_pastret.pr1 = xlsread('Problem_Set7.xls','SP1');
r_pastret.pr212 = xlsread('Problem_Set7.xls','SP212');
r_pastret.pr1360 = xlsread('Problem_Set7.xls','SP1360');
r_pastret.pr = [r_pastret.pr1,r_pastret.pr212,r_pastret.pr1360];
  
%handle missing value
r_FFF(r_FFF <= -99) = nan;
r_pastret.pr(r_pastret.pr <= -99) = nan;
r_pastret.pr1(r_pastret.pr1 <= -99) = nan;
r_pastret.pr212(r_pastret.pr212 <= -99) = nan;
r_pastret.pr1360(r_pastret.pr1360 <= -99) = nan;

%Add a dataset with excess returns
r_pastret.prpremium = r_pastret.pr(6:end,:)-r_FFF(1:1069,4);
date.SPpremium = date.SP(6:end,:);
%% data processing
% part a
%create the january-dummy
jantest.jan_dum = zeros(length(date.SPpremium),1);
temp = find(date.SPpremium(:,2) == 1);
jantest.jan_dum(temp) = 1;

%The results of seasonality test
jantest.result = zeros(4,75);
for i = 1:75
    %results of regressions
    jantest.regresult = fitlm(jantest.jan_dum,r_pastret.prpremium(:,i));
    
    jantest.result(1:2,i) = jantest.regresult.Coefficients.Estimate;
    jantest.result(3,i) = sum(jantest.result(1:2,i));
    jantest.result(4,i) = jantest.regresult.Coefficients.tStat(2,1);
end

%part b
%create the December-dummy
dectest.dec_dum = zeros(length(date.SPpremium),1);
temp = find(date.SPpremium(:,2) == 12);
dectest.dec_dum(temp) = 1;

%The results of seasonality test
comtest.result = zeros(7,75);
for i = 1:75
    %results of regressions
    comtest.regresult = fitlm([jantest.jan_dum,dectest.dec_dum,r_FFF(1:1069,1),r_FFF(1:1069,2),r_FFF(1:1069,3)],r_pastret.prpremium(:,i));
    
    comtest.result(1:2,i) = comtest.regresult.Coefficients.Estimate(1:2,1);
    comtest.result(3,i) = sum(comtest.result(1:2,i));
    comtest.result(4,i) = comtest.regresult.Coefficients.tStat(2,1);
    comtest.result(5,i) = comtest.regresult.Coefficients.Estimate(3,1);
    comtest.result(6,i) = comtest.result(1,i)+comtest.result(5,i);
    comtest.result(7,i) = comtest.regresult.Coefficients.tStat(3,1);
    
end

for i = 1:75
    %results of regressions
    dectest.regresult = fitlm([jantest.jan_dum,dectest.dec_dum],r_pastret.prpremium(:,i));
    
    dectest.result(1:2,i) = dectest.regresult.Coefficients.Estimate(1:2,1);
    dectest.result(3,i) = sum(dectest.result(1:2,i));
    dectest.result(4,i) = dectest.regresult.Coefficients.tStat(2,1);
    dectest.result(5,i) = dectest.regresult.Coefficients.Estimate(3,1);
    dectest.result(6,i) = dectest.result(1,i)+dectest.result(5,i);
    dectest.result(7,i) = dectest.regresult.Coefficients.tStat(3,1);
end

%part c
%%
%part d
mom.betas = zeros(954,3);
for i = 120:1069
    mom.result = fitlm([r_pastret.prpremium(i-1,:)',sum(r_pastret.prpremium(i-12:i-2,:))',sum(r_pastret.prpremium(i-60:i-13,:))'],r_pastret.prpremium(i,:));
    mom.betas(i,1:3) = mom.result.Coefficients.Estimate(2:4)';
end

%summary
mom.summary = [nanmean(mom.betas);...
               nanmean(mom.betas)./nanstd(mom.betas)*sqrt(954)];

%part e

%part f

%%
%part g
rand.matrix = ceil(75*rand(1069-59,5000));
rand.return = zeros(1069-59,5000);
for i = 1:1069-59
    rand.return(i,:) = r_pastret.pr(i+59,rand.matrix(i,:));
end

rand.summary = [nanmean(rand.return);nanstd(rand.return);...
                (nanmean(rand.return)-nanmean(r_FFF(60:1069,4)))./nanstd(rand.return);...
                nanmean(rand.return)./nanstd(rand.return)*sqrt(1069-59)];
            
