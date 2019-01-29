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
Rm = xlsread('Problem_Set3.xls','Market_proxy_Rm');
rf = xlsread('Problem_Set3.xls','Market_proxy_rf');
r_25 = xlsread('Problem_Set3.xls','25_Size_BEME_Portfolios_r');
size_25 = xlsread('Problem_Set3.xls','25_Size_BEME_Portfolios_size');
BEME_25 = xlsread('Problem_Set3.xls','25_Size_BEME_Portfolios_BEME');
r_49 = xlsread('Problem_Set3.xls','49_Industry_Portfolios_r');
size_49 = xlsread('Problem_Set3.xls','49_Industry_Portfolios_size');
BEME_49 = xlsread('Problem_Set3.xls','49_Industry_Portfolios_BEME');
yr = xlsread('Problem_Set3.xls','year');
mon = xlsread('Problem_Set3.xls','month');
%% data cleaning
%set missing values to NaN
miss_value1 = find(r_49<=-99.99);
miss_value2 = find(BEME_49<=-99.99);
for i = miss_value1
    r_49(i) = nan;
    size_49(i) = nan;
end

for j = miss_value2
    BEME_49(j) = nan;
end

% make BE/ME monthly
BEME_49_mon = zeros(1085,49);
BEME_25_mon = zeros(1085,25);
BEME_49_mon(1,:) = BEME_49(1,:);
BEME_25_mon(1,:) = BEME_25(1,:);

count = 1;
for i = 2:1085
    if yr(i) ~= yr(i-1)
        count = count + 1; %add one year
    end
    BEME_49_mon(i,:) = BEME_49(count,:);
    BEME_25_mon(i,:) = BEME_25(count,:);
end

size_49_ln = log(size_49);
BEME_49_ln = log(BEME_49_mon);
size_25_ln = log(size_25);
BEME_25_ln = log(BEME_25_mon);
clear miss_value miss_value1 miss_value2 i j count


%% Part 1
%Part a

%Part b
%Run the regression on each industry portfolio
beta_49 = zeros(2,49);
for i = 1:49
    beta_49(:,i) = regress(r_49(:,i)-rf,[ones(1085,1) Rm]);
end
beta_49 = beta_49(2,:)';

gamma_49 = zeros(2,1085);
for i = 1:1085
    gamma_49(:,i) = regress((r_49(i,:)-rf(i,1))',[ones(49,1) beta_49]);
end
gamma_49 = gamma_49';


summary_49 = [nanmean(gamma_49);nanstd(gamma_49)./sqrt(1085)];
summary_49(3,1:2) = summary_49(1,:)./summary_49(2,:);

%Part c
%run regression on r_49-rf 
avg_r_49 = nanmean(r_49)';
avg_gamma_49 = regress(avg_r_49-mean(rf),[ones(49,1) beta_49]);


%Part d
plot1D;

%Part e

%Part f
gamma_49_SBM = zeros(4,1085);
for i = 2:1085
    gamma_49_SBM(:,i) = regress((r_49(i,:)-rf(i,1))',[ones(49,1) beta_49 size_49_ln(i-1,:)' BEME_49_ln(i-1,:)']);
end
gamma_49_SBM = gamma_49_SBM(:,2:end)';

summary_49_SBM = [nanmean(gamma_49_SBM);nanstd(gamma_49_SBM)/sqrt(1084)];
summary_49_SBM(3,1:4) = summary_49_SBM(1,:)./summary_49_SBM(2,:);

%% Part 2 - 1

%Run the regression on each industry portfolio
beta_25 = zeros(2,25);
for i = 1:25
    beta_25(:,i) = regress(r_25(:,i)-rf,[ones(1085,1) Rm]);
end
beta_25 = beta_25(2,:)';

gamma_25 = zeros(2,1085);
for i = 1:1085
    gamma_25(:,i) = regress((r_25(i,:)-rf(i,1))',[ones(25,1) beta_25]);
end
gamma_25 = gamma_25';


summary_25 = [nanmean(gamma_25);nanstd(gamma_25)./sqrt(1085)];
summary_25(3,1:2) = summary_25(1,:)./summary_25(2,:);

%Part c
avg_r_25 = nanmean(r_25)';
avg_gamma_25 = regress(avg_r_25-mean(rf),[ones(25,1) beta_25]);

%Part d
plot2a_D;

%Part e

%Part f
gamma_25_SBM = zeros(4,1085);
for i = 2:1085
    gamma_25_SBM(:,i) = regress((r_25(i,:)-rf(i,1))',[ones(25,1) beta_25 size_25_ln(i-1,:)' BEME_25_ln(i-1,:)']);
end
gamma_25_SBM = gamma_25_SBM(:,2:end)';

summary_25_SBM = [nanmean(gamma_25_SBM);nanstd(gamma_25_SBM)/sqrt(1084)];
summary_25_SBM(3,1:4) = summary_25_SBM(1,:)./summary_25_SBM(2,:);

%% Part2 - 2
[~,~,~,~, TanP_w]=mvp(nanmean(r_25),nancov(r_25),mean(rf),0);
beta_25_tan = zeros(2,25);
for i = 1:25
    beta_25_tan(:,i) = regress(r_25(:,i)-rf,[ones(1085,1) r_25*TanP_w-rf]);
end
beta_25_tan = beta_25_tan(2,:)';

%part c
avg_gamma_25_tan = regress(avg_r_25-mean(rf),[ones(25,1) beta_25_tan]);

%part d
plot2b_D

%% Part2 - 3
count = 1;
OMEY_EMOY_t = zeros(1085,1);
for t = 1:1085
    if (mod(yr(t),2) ~= 0 && mod(mon(t),2) == 0) || (mod(yr(t),2) == 0 && mod(mon(t),2) ~= 0)
        OMEY_EMOY_t(count,1) = t;
        count = count + 1;
    end
end
nonzero_list = find(OMEY_EMOY_t);
OMEY_EMOY_t = OMEY_EMOY_t(nonzero_list);
OMEY_EMOY = r_25(OMEY_EMOY_t,:);
OMOY_EMEY = repmat(r_25,1);
OMOY_EMEY(OMEY_EMOY_t,:) = [];
rf_OMOY =repmat(rf,1);
rf_OMOY(OMEY_EMOY_t,:) = [];
rf_OMEY =rf(OMEY_EMOY_t,:);
%Part a
[~,~,~,~, TanP_w_OMEY]=mvp(nanmean(OMEY_EMOY),nancov(OMEY_EMOY),mean(rf),0);
beta_25_tan_OMEY = zeros(2,25);
for i = 1:25
    beta_25_tan_OMEY(:,i) = regress(OMOY_EMEY(:,i)-rf_OMOY,[ones(542,1) OMOY_EMEY*TanP_w_OMEY-rf_OMOY]);
end
beta_25_tan_OMEY = beta_25_tan_OMEY(2,:)';

avg_gamma_25_tan_OMEY = regrelmfitss((nanmean(OMOY_EMEY)-mean(rf_OMOY))',[ones(25,1) beta_25_tan_OMEY]);









