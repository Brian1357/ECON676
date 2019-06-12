function result = FamaMac(portRet,factor,rf)
%FamaMac: Fama-Macbeth tests
%portRet: portfolio returns
%factor: factor returns

% number of portfolios
N = length(portRet(1,:));
% number of factors
M = length(factor(1,:));
% number of days
if length(portRet(:,1)) == length(factor(:,1))
    T = length(portRet(:,1));
else
    T = min([length(portRet(:,1)),length(factor(:,1))]);
end

%time-series regressions to obtain the estimates for betas
%column: betas for portfolio i
%row: beta i's for all portfolios
result.betas = zeros(M,N);
for i = 1:N
     temp = regress(portRet(:,i),[ones(T,1),factor]);
     result.betas(:,i) = temp(2:end);
end
clear temp

%cross-sectional regressions to obtain the estimates for gammas
result.gammas = zeros(T,M+1);% +1 becuase of gamma_0
result.Rsq = zeros(T,1);
for j = 1:T
    temp = fitlm(result.betas',portRet(j,:)');
    result.gammas(j,:) = temp.Coefficients.Estimate';
    result.Rsq(j,:) = temp.Rsquared.Ordinary;
end

result.summary_Rsq = mean(result.Rsq);
result.summary = [mean(result.gammas);std(result.gammas);mean(result.gammas)./std(result.gammas)*sqrt(T)];
result.pred_excess_ret = results.betas;
end


    
    
    
    
    

