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
%% Part 1

%Part a
stocks = xlsread('Problem_Set1.xlsx','B7:AY186');
index = xlsread('Problem_Set1.xlsx','BA7:BA186');

stocks_5 = nanmean(stocks(:,1:5),2);
stocks_10 = nanmean(stocks(:,1:10),2);
stocks_25 = nanmean(stocks(:,1:25),2);
stocks_50 = nanmean(stocks(:,1:50),2);

mean_5 = nanmean(stocks_5);
mean_10 = nanmean(stocks_10);
mean_25 = nanmean(stocks_25);
mean_50 = nanmean(stocks_50);

cov_stk = nancov(stocks);
std_5 = nanstd(stocks_5);
std_10 = nanstd(stocks_10);
std_25 = nanstd(stocks_25);
std_50 = nanstd(stocks_50);
plot1A;

%Part b
std_stk = nanstd(stocks);
percent_5 = 1/25*sum(std_stk(1:5).^2)/std_5^2;
percent_10 = 1/100*sum(std_stk(1:10).^2)/std_10^2;
percent_25 = 1/25^2*sum(std_stk(1:25).^2)/std_25^2;
percent_50 = 1/50^2*sum(std_stk(1:50).^2)/std_50^2;

plot1B;

%Part c

%Part d
z_5 = mean_5/std_5*sqrt(180);
z_10 = mean_10/std_10*sqrt(180);
z_25 = mean_25/std_25*sqrt(180);
z_50 = mean_50/std_50*sqrt(180);

%Part e
stocks_1 = stocks(:,1);
stdrange_1 = (max(stocks_1)-min(stocks_1))/std(stocks_1);
skew_1 = skewness(stocks_1);
kurt_1 = kurtosis(stocks_1);
BS_1 = length(stocks)*(skew_1^2/6+(kurt_1-3)^2/24);
% 95%significance level of chi(2) is 0.051,7.378. reject

stdrange_50 = (max(stocks_50)-min(stocks_50))/std_50;
skew_50 = skewness(stocks_50);
kurt_50 = kurtosis(stocks_50);
BS_50 = length(stocks)*(skew_50^2/6+(kurt_50-3)^2/24);

stdrange_ind = (max(index)-min(index))/std(index);
skew_ind = skewness(index);
kurt_ind = kurtosis(index);
BS_ind = length(index)*(skew_ind^2/6+(kurt_ind-3)^2/24);

%Part f

%% Part 2
Vol = xlsread('Problem_Set1.xlsx','Part2','D18:G186');
beta = xlsread('Problem_Set1.xlsx','Part2','H18:I186');
yr = xlsread('Problem_Set1.xlsx','Part2','J18:J186');
mon = xlsread('Problem_Set1.xlsx','Part2','K18:K186');
da = xlsread('Problem_Set1.xlsx','Part2','L18:L186');
time = datetime(yr,mon,da);
%%
%Part a
Vol_TXN1 = Vol(:,1);
Vol_mkt1 = Vol(:,2);
Vol_TXN2 = Vol(:,3);
Vol_mkt2 = Vol(:,4);
plot2A;
%%
%Part b
beta_1 = zeros(180-11,1);
beta_2 = zeros(180-11,1);
bind_1 = zeros(180-11,2);
bind_2 = zeros(180-11,2);

TXN = stocks(:,1);
mkt = [ones(length(stocks),1),index];

for i = 12:180
    [beta1, bind1] = regress(TXN(1:i,1),mkt(1:i,:));
    [beta2, bind2] = regress(TXN(i-11:i,1),mkt(i-11:i,:));
    beta_1(i-11,1) = beta1(2,1);
    bind_1(i-11,:) = bind1(2,:);
    beta_2(i-11,1) = beta2(2,1);
    bind_2(i-11,:) = bind2(2,:);
end

plot2B;





