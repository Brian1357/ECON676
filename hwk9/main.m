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
date.VMF = xlsread('Problem_Set8.xls','Date_VMF');
date.TSMOM = xlsread('Problem_Set8.xls','Date_TSMOM');
date.FFF = xlsread('Problem_Set8.xls','Date_FFF');
date.CBABQ = xlsread('Problem_Set8.xls','Date_CBABQ');
date.AMP = xlsread('Problem_Set8.xls','Date_AMP');
date.HFDJ = xlsread('Problem_Set8.xls','Date_HFDJ');


%read returns
r_VMF = xlsread('Problem_Set8.xls','VMF');
r_TSMOM = xlsread('Problem_Set8.xls','TSMOM_');
r_FFF = xlsread('Problem_Set8.xls','FFF');
r_CBABQ = xlsread('Problem_Set8.xls','CBABQ');
r_AMP = xlsread('Problem_Set8.xls','AMP');
r_HFDJ = xlsread('Problem_Set8.xls','HF_DJ');

%handle missing value
r_VMF(r_VMF <= -99) = nan;
r_TSMOM(r_TSMOM <= -99) = nan;
r_FFF(r_FFF <= -99) = nan;
r_CBABQ(r_CBABQ <= -99) = nan;
r_AMP(r_AMP <= -99) = nan;
r_HFDJ(r_HFDJ <= -99) = nan;

%adjust units
r_FFF = r_FFF/100;

%% Part 1
% part a
a = statsummary(r_VMF,0);

% part b
%separate the value and momentum strategies apart
r_VMF_V = r_VMF(:,[1,3,5,7,9,11,13,15]);
r_VMF_M = r_VMF(:,[2,4,6,8,10,12,14,16]);
%Value everywhere
[b.VAL_ew.p,b.VAL_ew.tbl] = anova1(r_VMF_V);
%Value in equity mkt
[b.VAL_equity.p,b.VAL_equity.tbl] = anova1(r_VMF_V(:,1:4));
%Momentum everywhere
[b.MOM_ew.p,b.MOM_ew.tbl] = anova1(r_VMF_M);
%Momentum in equity mkt
[b.MOM_equity.p,b.MOM_equity.tbl] = anova1(r_VMF_M(:,1:4));

%Fama-Macbeth test
%time-series regression
b.betas_timeseries = zeros(4,16);
T = min(length(date.VMF),length(date.AMP));
for x = 1:16
    b.betas_ts(:,x) = regress(r_VMF(1:T,x),[ones(T,1) r_AMP(1:T,:)]);
end

%cross-sectional regression
b.betas_cs = zeros(T,4);
for x = 1:length(date.AMP)
    b.result = fitlm(b.betas_ts(2:4,:)',r_VMF(x,:)');
    b.betas_cs(x,:) = b.result.Coefficients.Estimate';
end
%take the avg of cross-sectional estimates
b.summary = [nanmean(b.betas_cs);nanstd(b.betas_cs)];
b.summary(3,:) = b.summary(1,:)./b.summary(2,:)*sqrt(T);
%%
% part c
c = maxDD(r_VMF);

% part d
%obtain the volatility
d.portvol_V=nanstd(r_VMF_V);
d.portvol_M=nanstd(r_VMF_M);
%obtain the weights: reciprocals of volatilities
d.weight_V = 1./d.portvol_V./sum(1./d.portvol_V);
d.weight_M = 1./d.portvol_M./sum(1./d.portvol_M);
%obtain the returns (there are some missing values)
d.VAL_ew = r_VMF_V*d.weight_V';
d.MOM_ew = r_VMF_M*d.weight_M';
%obtain the summary
d.sum_VAL = statsummary(d.VAL_ew,0);
d.sum_MOM = statsummary(d.MOM_ew,0);

%%
% part e
% The returns for each 50-50 portfolios
e.US = 0.5*r_VMF(:,1)+0.5*r_VMF(:,2);
e.UK = 0.5*r_VMF(:,3)+0.5*r_VMF(:,4);
e.EU = 0.5*r_VMF(:,5)+0.5*r_VMF(:,6);
e.JP = 0.5*r_VMF(:,7)+0.5*r_VMF(:,8);
e.EQ = 0.5*r_VMF(:,9)+0.5*r_VMF(:,10);
e.FX = 0.5*r_VMF(:,11)+0.5*r_VMF(:,12);
e.FI = 0.5*r_VMF(:,13)+0.5*r_VMF(:,14);
e.CM = 0.5*r_VMF(:,15)+0.5*r_VMF(:,16);

e.ret_total = [e.US,e.UK,e.EU,e.JP,e.EQ,e.FX,e.FI,e.CM];

%obtain the summary
e.sum_US = statsummary(e.US,0);
e.sum_UK = statsummary(e.UK,0);
e.sum_EU = statsummary(e.EU,0);
e.sum_JP = statsummary(e.JP,0);
e.sum_EQ = statsummary(e.EQ,0);
e.sum_FX = statsummary(e.FX,0);
e.sum_FI = statsummary(e.FI,0);
e.sum_CM = statsummary(e.CM,0);


% part f
%obtain the volatility
f.portvol=nanstd(e.ret_total);
%obtain the weights: reciprocals of volatilities
f.weight_VM = 1./f.portvol./sum(1./f.portvol);
%obtain the returns (there are some missing values)
f.VM_ew = e.ret_total*f.weight_VM';
%obtain the summary
f.sum_VM = statsummary(f.VM_ew,0);
%%
% part g

% part h
h.mean_r = nanmean(r_VMF)';
h.cov_mat = nancov(r_VMF);
[~,h.TP,h.frontier] = MVTP(h.mean_r,0,h.cov_mat);
plot1h;
clear i

% part i
%obtain the returns for odd months and even months
temp = find(mod(date.VMF(:,2),2)==0);
i.r_even = r_VMF(temp,:);
temp = find(mod(date.VMF(:,2),2)==1);
i.r_odd = r_VMF(temp,:);

%Weights obtained from even months and apply them to odd months
[~,i.TP_even,~] = MVTP(nanmean(i.r_even)',0,nancov(i.r_even));
i.TP_even.returns_odd = i.r_odd*i.TP_even.weight;
i.TP_even.ret_std_odd = [nanmean(i.TP_even.returns_odd);nanstd(i.TP_even.returns_odd)];

%Weights obtained from odd months and apply them to even months
[~,i.TP_odd,~] = MVTP(nanmean(i.r_odd)',0,nancov(i.r_odd));
i.TP_odd.returns_even = i.r_even*i.TP_odd.weight;
i.TP_odd.ret_std_even = [nanmean(i.TP_odd.returns_even);nanstd(i.TP_odd.returns_even)];

%Combine the odd months and even months together
i.TP_evenodd.returns = zeros(length(r_VMF),1);
for x = 1:length(r_VMF)
    if mod(x,2) == 1
        i.TP_evenodd.returns(x) = i.TP_even.returns_odd((x+1)/2);
    else
        i.TP_evenodd.returns(x) = i.TP_odd.returns_even(x/2);
    end
end
i.TP_evenodd.ret_std = [nanmean(i.TP_evenodd.returns);nanstd(i.TP_evenodd.returns)];
plot1i;

clear temp
%%
% part j
j.cov_mat = nancov(r_VMF);
for x = 1:16
    for y = 1:16
        j.corr_mat(x,y) = j.cov_mat(x,y)/(a.mean(2,x)*a.mean(2,y));
    end
end

j.corr_mat_nonan = corr(r_VMF(133:end,:));
clear x y
%%
% part k
k.alpha = zeros(3,16);
k.squares = zeros(2,16);
k.plot = zeros(16,2);
for x = 1:16
    %use two temp sequence to help subsetting
    temp_V = [1,3,5,7,9,11,13,15];
    temp_M = [2,4,6,8,10,12,14,16];
    
    if mod(x,2) == 1
        y = x+1;
    else
        y = x-1;
    end
    
    temp_V = temp_V(temp_V~=x);
    temp_V = temp_V(temp_V~=y);
    temp_M = temp_M(temp_M~=x);
    temp_M = temp_M(temp_M~=y);
    
    %obtain the volatility
    portvol_V=nanstd(r_VMF(:,temp_V));
    portvol_M=nanstd(r_VMF(:,temp_M));
    %obtain the weights: reciprocals of volatilities
    weight_V = 1./portvol_V./sum(1./portvol_V);
    weight_M = 1./portvol_M./sum(1./portvol_M);
    %obtain the Value and Momentum factors (there are some missing values)
    VAL_ew = r_VMF(:,temp_V)*weight_V';
    MOM_ew = r_VMF(:,temp_M)*weight_M';
    %run regression
    result = fitlm([VAL_ew MOM_ew],r_VMF(:,x));
    %alpha
    k.alpha(1,x) = result.Coefficients.Estimate(1);
    k.alpha(2,x) = result.Coefficients.SE(1);
    k.alpha(3,x) = result.Coefficients.tStat(1);
    %R-squares
    k.squares(1,x) = result.Rsquared.Ordinary;
    k.squares(2,x) = result.Rsquared.Adjusted;
    %predicted expected return
    k.plotx(x,1) = nanmean(result.Fitted);
    k.plotx(x,2) = nanmean(r_VMF(:,x));
    
end

clear portvol_V portvol_M weight_V weight_M VAL_ew MOM_ew result temp_M temp_V

plot1k;
% We cannot use GRS-test here, because the value and momentum factor
% changes as the dependent variables change.
%%
% part l
T = length(r_VMF);

l.mkt = regGRS([ones(T,1) r_FFF(547:end,1)],r_VMF);
l.FF4 = regGRS([ones(T,1) r_FFF(547:end,[1:3,5])],r_VMF);
l.AMP3 = regGRS([ones(492,1),r_AMP(:,1:3)],r_VMF(1:492,:));
l.AMP4 = regGRS([ones(336,1),r_AMP(157:end,1:3),r_TSMOM(1:336,1)],r_VMF(157:492,:));
l.AMP6 = regGRS([ones(336,1),r_AMP(157:end,1:3),r_TSMOM(1:336,1),...
    r_FFF(703:1038,6:7)],r_VMF(157:492,:));

l.summary.alpha = [l.mkt.alpha(1,:)',l.FF4.alpha(1,:)',l.AMP3.alpha(1,:)',l.AMP4.alpha(1,:)',l.AMP6.alpha(1,:)'];
l.summary.alpha_tstat = [l.mkt.alpha(3,:)',l.FF4.alpha(3,:)',l.AMP3.alpha(3,:)',l.AMP4.alpha(3,:)',l.AMP6.alpha(3,:)'];
l.summary.Rsq = [l.mkt.squares(1,:)',l.FF4.squares(1,:)',l.AMP3.squares(1,:)',l.AMP4.squares(1,:)',l.AMP6.squares(1,:)'];
l.summary.GRSstat = [l.mkt.GRS',l.FF4.GRS',l.AMP3.GRS',l.AMP4.GRS',l.AMP6.GRS'];
%% part 2
% part m
r_MOM_AC = r_VMF_M(157:end,5:end);
r_TSMOM_AC = r_TSMOM(:,2:end);
% method 1: GRS tests
% +
% method 2: test each one factor and see if their correlation are 
% significantly different from 0; chi2 test
m.mom_ts = regGRS([ones(371,1) r_MOM_AC],r_TSMOM_AC);
m.ts_mom = regGRS([ones(371,1) r_TSMOM_AC],r_MOM_AC);


%% part 3
% part n
% subtract the rf
r_HFDJ_ex = r_HFDJ(1:end-1,:)-r_FFF(763:1073,4);

% models
n.mkt = regGRS([ones(311,1) r_FFF(763:1073,1)],r_HFDJ_ex);
n.mkt_lag = regGRS([ones(310,1) r_FFF(764:1073,1) r_FFF(763:1072,1)],r_HFDJ_ex(2:end,:));
n.FF4 = regGRS([ones(310,1) r_FFF(764:1073,1) r_FFF(763:1072,1)... 
    r_FFF(764:1073,[2,3,5])],r_HFDJ_ex(2:end,:));
n.AMP3 = regGRS([ones(276,1) r_AMP(217:492,3) r_AMP(216:491,3) r_AMP(217:492,1:2)],r_HFDJ_ex(1:276,:));
n.AMP4 = regGRS([ones(276,1) r_AMP(217:492,3) r_AMP(216:491,3) r_AMP(217:492,1:2)...
    r_TSMOM(61:336,1)],r_HFDJ_ex(1:276,:));
n.AMP6 = regGRS([ones(276,1) r_AMP(217:492,3) r_AMP(216:491,3) r_AMP(217:492,1:2)...
    r_TSMOM(61:336,1) r_FFF(763:1038,6:7)],r_HFDJ_ex(1:276,:));
n.AMP9 = regGRS([ones(276,1) r_AMP(217:492,3) r_AMP(216:491,3) r_AMP(217:492,1:2)...
    r_TSMOM(61:336,1) r_FFF(763:1038,6:7) r_CBABQ(709:984,:)],r_HFDJ_ex(1:276,:));

n.summary.alpha = [n.mkt.alpha(1,:)',n.mkt_lag.alpha(1,:)',n.FF4.alpha(1,:)',n.AMP3.alpha(1,:)',n.AMP4.alpha(1,:)',n.AMP6.alpha(1,:)',n.AMP9.alpha(1,:)'];
n.summary.alpha_tstat = [n.mkt.alpha(3,:)',n.mkt_lag.alpha(3,:)',n.FF4.alpha(3,:)',n.AMP3.alpha(3,:)',n.AMP4.alpha(3,:)',n.AMP6.alpha(3,:)',n.AMP9.alpha(3,:)'];
n.summary.Rsq = [n.mkt.squares(1,:)',n.mkt_lag.squares(1,:)',n.FF4.squares(1,:)',n.AMP3.squares(1,:)',n.AMP4.squares(1,:)',n.AMP6.squares(1,:)',n.AMP9.squares(1,:)'];
n.summary.AdRsq = [n.mkt.squares(2,:)',n.mkt_lag.squares(2,:)',n.FF4.squares(2,:)',n.AMP3.squares(2,:)',n.AMP4.squares(2,:)',n.AMP6.squares(2,:)',n.AMP9.squares(2,:)'];
n.summary.GRSstat = [n.mkt.GRS',n.mkt_lag.GRS',n.FF4.GRS',n.AMP3.GRS',n.AMP4.GRS',n.AMP6.GRS',n.AMP9.GRS'];
n.summary.betas = [n.mkt.GRS',n.mkt_lag.GRS',n.FF4.GRS',n.AMP3.GRS',n.AMP4.GRS',n.AMP6.GRS',n.AMP9.GRS'];
%% part 4
% part o
% combine the returns
r_comb = [r_FFF(547:1038,1:2) r_AMP(1:492,1:2) r_CBABQ(493:984,:)...
    r_FFF(547:1038,6:7)];
date.comb = date.FFF(547:1038,:);
% obtain the tangency portfolio
o.mean_r = nanmean(r_comb)';
o.cov_mat = nancov(r_comb);
[~,o.TP,o.frontier] = MVTP(o.mean_r,0,o.cov_mat);
%calculate SR
o.TP.SR = o.TP.ret_std(1)/o.TP.ret_std(2);
plot1o;

% part p
temp = find(mod(date.comb(:,2),2)==0);
p.r_even = r_comb(temp,:);
temp = find(mod(date.comb(:,2),2)==1);
p.r_odd = r_comb(temp,:);

%Weights obtained from even months and apply them to odd months
[~,p.TP_even,~] = MVTP(nanmean(p.r_even)',0,nancov(p.r_even));
p.TP_even.returns_odd = p.r_odd*p.TP_even.weight;
p.TP_even.ret_std_odd = [nanmean(p.TP_even.returns_odd);nanstd(p.TP_even.returns_odd)];

%Weights obtained from odd months and apply them to even months
[~,p.TP_odd,~] = MVTP(nanmean(p.r_odd)',0,nancov(p.r_odd));
p.TP_odd.returns_even = p.r_even*p.TP_odd.weight;
p.TP_odd.ret_std_even = [nanmean(p.TP_odd.returns_even);nanstd(p.TP_odd.returns_even)];

%Combine the odd months and even months together
p.TP_evenodd.returns = zeros(length(r_comb),1);
for x = 1:length(r_comb)
    if mod(x,2) == 1
        p.TP_evenodd.returns(x) = p.TP_even.returns_odd((x+1)/2);
    else
        p.TP_evenodd.returns(x) = p.TP_odd.returns_even(x/2);
    end
end
p.TP_evenodd.ret_std = [nanmean(p.TP_evenodd.returns);nanstd(p.TP_evenodd.returns);nanmean(p.TP_evenodd.returns)/nanstd(p.TP_evenodd.returns)];
plot1p;
