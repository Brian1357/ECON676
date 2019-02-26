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
%Part a
summary_industry = [mean(r_industry);std(r_industry);(mean(r_industry)-mean(rf))./std(r_industry)];
%????No pattern...close to 1??
%Part b
intercept = ones(length(time_industry),1);
X_1b = [intercept,Rm];
Y_1b = r_industry-rf;

N = length(Y_1b(1,:));%number of dependent variables
L = length(X_1b(1,:))-1;%number of independent variables

beta_1b = zeros(L+1,N);%initialize betas
for i = 1:N
    beta_1b(:,i) = regress(Y_1b(:,i),X_1b);%obtain betas for each dependent variables
end

GRS_1b = GRS(X_1b,Y_1b);

%Part c
%H0: The portfolio is mean-variance efficient
%H0: The SR of the portfolio = SR of the market portfolio
%H0: SR of market port = max(SRs of portfolios)
%H0: alpha = 0
%CAPM tests beta, but it tests SR

%Part d
int_1d = zeros(N,3);
int_1d = beta_1b(1,:)';
for i = 1:N
    results = fitlm(X_1b(:,2),Y_1b(:,i));
    int_1d(i,1) = results.Coefficients.Estimate(1);
    int_1d(i,2) = results.Coefficients.tStat(1);
    int_1d(i,3) = results.Coefficients.pValue(1);
end

clear N L

%% part 2
%Part e
%Part a
summary_PRP = [mean(r_PRP);std(r_PRP);(mean(r_PRP)-mean(rf))./std(r_PRP)];

%Part b
intercept = ones(length(time_PRP),1);
X_2b = [intercept,Rm(7:end)];
Y_2b = r_PRP-rf(7:end);

N = length(Y_2b(1,:));%number of dependent variables
L = length(X_2b(1,:))-1;%number of independent variables

beta_2b = zeros(L+1,N);%initialize betas
for i = 1:N
    beta_2b(:,i) = regress(Y_2b(:,i),X_2b);%obtain betas for each dependent variables
end

GRS_2b = GRS(X_2b,Y_2b);

%Part d
int_2d = zeros(N,3);
int_2d = beta_2b(1,:)';
for i = 1:N
    results = fitlm(X_2b(:,2),Y_2b(:,i));
    int_2d(i,2) = results.Coefficients.tStat(1);
    int_2d(i,3) = results.Coefficients.pValue(1);
end

clear N L

%% part 3
%Part f
%Part a
summary_beme = [mean(r_beme);std(r_beme);(mean(r_beme)-mean(rf))./std(r_beme)];

%Part b
intercept = ones(length(time_beme),1);
X_3b = [intercept,Rm];
Y_3b = r_beme-rf;

N = length(Y_3b(1,:));%number of dependent variables
L = length(X_3b(1,:))-1;%number of independent variables

beta_3b = zeros(L+1,N);%initialize betas
for i = 1:N
    beta_3b(:,i) = regress(Y_3b(:,i),X_3b);%obtain betas for each dependent variables
end

GRS_3b = GRS(X_3b,Y_3b);

%Part d
int_3d = zeros(N,3);
int_3d = beta_3b(1,:)';
for i = 1:N
    results = fitlm(X_3b(:,2),Y_3b(:,i));
    int_3d(i,2) = results.Coefficients.tStat(1);
    int_3d(i,3) = results.Coefficients.pValue(1);
end

%part g
[~,~,~,~, tanP_beme]=mvp(nanmean(r_beme),nancov(r_beme),mean(rf),0);
Rm_beme = r_beme*tanP_beme;
X_3g = [intercept, Rm_beme-rf];
GRS_3g = GRS(X_3g, Y_3b);

beta_3g = zeros(L+1,N);%initialize betas
for i = 1:N
    beta_3g(:,i) = regress(Y_3b(:,i),X_3g);%obtain betas for each dependent variables
end

int_3g = zeros(N,3);
int_3g = beta_3g(1,:)';
for i = 1:N
    results = fitlm(X_3g(:,2),Y_3b(:,i));
    int_3g(i,2) = results.Coefficients.tStat(1);
    int_3g(i,3) = results.Coefficients.pValue(1);
end

%part h
count = 1;
yr=year(time_beme);
mon=month(time_beme);

OMEY_EMOY_t = zeros(1085,1);
for t = 1:1085
    if (mod(yr(t),2) ~= 0 && mod(mon(t),2) == 0) || (mod(yr(t),2) == 0 && mod(mon(t),2) ~= 0)
        OMEY_EMOY_t(count,1) = t;
        count = count + 1;
    end
end
nonzero_list = find(OMEY_EMOY_t);
OMOY_EMEY_t = (1:1085)';
OMEY_EMOY_t = OMEY_EMOY_t(nonzero_list);
OMOY_EMEY_t(OMEY_EMOY_t,:) = [];
OMEY_EMOY = r_beme(OMEY_EMOY_t,:);
OMOY_EMEY = repmat(r_beme,1);
OMOY_EMEY(OMEY_EMOY_t,:) = [];
rf_OMOY =repmat(rf,1);
rf_OMOY(OMEY_EMOY_t,:) = [];
rf_OMEY =rf(OMEY_EMOY_t,:);

[~,~,~,~, TanP_w_OMEY]=mvp(nanmean(OMEY_EMOY),nancov(OMEY_EMOY),mean(rf_OMEY),0);
[~,~,~,~, TanP_w_OMOY]=mvp(nanmean(OMOY_EMEY),nancov(OMOY_EMEY),mean(rf_OMOY),0);
Rm_EMEY = OMOY_EMEY*TanP_w_OMEY;
Rm_EMOY = OMEY_EMOY*TanP_w_OMOY;

Rm_MY = zeros(1085,1);
Rm_MY(OMOY_EMEY_t,1) = Rm_EMEY;
Rm_MY(OMEY_EMOY_t,1) = Rm_EMOY;

clear count yr mon nonzero_list OMOY_EMEY_t OMEY_EMOY_t OMEY_EMOY OMOY_EMEY
clear rf_OMOY rf_OMEY TanP_w_OMEY TanP_w_OMOY Rm_EMEY Rm_EMOY

X_3h = [intercept, Rm_MY-rf];
GRS_3h = GRS(X_3h,Y_3b);

beta_3h = zeros(L+1,N);%initialize betas
for i = 1:N
    beta_3h(:,i) = regress(Y_3b(:,i),X_3h);%obtain betas for each dependent variables
end

int_3h = zeros(N,3);
int_3h = beta_3h(1,:)';
for i = 1:N
    results = fitlm(X_3h(:,2),Y_3b(:,i));
    int_3h(i,2) = results.Coefficients.tStat(1);
    int_3h(i,3) = results.Coefficients.pValue(1);
end
%part i
[~,~,~,~, tanP_industry]=mvp(nanmean(r_industry),nancov(r_industry),mean(rf),0);
Rm_industry = r_industry*tanP_industry;
X_3i = [intercept, Rm_industry-rf];
GRS_3i = GRS(X_3i, Y_3b);

beta_3i = zeros(L+1,N);%initialize betas
for i = 1:N
    beta_3i(:,i) = regress(Y_3b(:,i),X_3i);%obtain betas for each dependent variables
end

int_3i = zeros(N,3);
int_3i = beta_3i(1,:)';
for i = 1:N
    results = fitlm(X_3i(:,2),Y_3b(:,i));
    int_3i(i,2) = results.Coefficients.tStat(1);
    int_3i(i,3) = results.Coefficients.pValue(1);
end

%part j
[~,~,~,~, tanP_PRP]=mvp(nanmean(r_PRP),nancov(r_PRP),mean(rf(7:end)),0);
Rm_PRP = r_PRP*tanP_PRP;
X_3j = [intercept(7:end), Rm_PRP-rf(7:end)];
GRS_3j = GRS(X_3j, Y_3b(7:end,:));

beta_3j = zeros(L+1,N);%initialize betas
for i = 1:N
    beta_3j(:,i) = regress(Y_3b(7:end,i),X_3j);%obtain betas for each dependent variables
end

int_3j = zeros(N,3);
int_3j = beta_3j(1,:)';
for i = 1:N
    results = fitlm(X_3j(:,2),Y_3b(7:end,i));
    int_3j(i,2) = results.Coefficients.tStat(1);
    int_3j(i,3) = results.Coefficients.pValue(1);
end
%part k
Rm_combine = [Rm_industry(7:end), Rm_PRP, Rm_beme(7:end)];
Rm_corr = corr(Rm_combine);

clear N L