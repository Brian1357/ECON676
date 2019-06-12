function GRS_stat = GRS_para(mean_port,mean_mkt,sigma_port,sigma_mkt,rf,cov_mkt,cov_port, T)
% GRS_para: compute the GRS test statistic with statistics
% mean, sigma, rf
% cov_mkt: cov between the indeps and depends.行indep，列dep
% GRS_stat: [F-stat p-value]

N = length(mean_port);%number of other portfolios

betas = zeros(1,N);%initialize betas

for i = 1:N
    betas(:,i) = cov_mkt(:,i)./sigma_mkt;%obtain betas for each dependent variables
end

resid = mean_port - mean_mkt*betas;%obtain residuals

resid_cov = zeros(N,N);%initialize residuals covariance matrix
for i = 1:N
    for j = 1:N
        resid_cov(i,j) = cov_port(i,j)-betas(i)*cov_mkt(j)-betas(j)*cov_mkt(i)+betas(i)*betas(j)*sigma_mkt^2;
    end
end


X_mu = nanmean(X(:,2:end))';
X_cov = nancov(X(:,2:end));
%alpha = mean(Y)'-beta(2,:)'*X_mu;
alpha = beta(1,:)';

W = alpha'*inv(resid_cov)*alpha/(1+X_mu'*inv(X_cov)*X_mu);%compute test-stat
W_norm = (T/N)*((T-N-L)/(T-L-1))*W;%normalize test-stat
p = fcdf(W_norm,N,T-N-L);
GRS_stat = [W_norm,1-p];
end