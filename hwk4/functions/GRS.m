function GRS_stat = GRS(X,Y)
% GRS: compute the GRS test statistic
% X: independent variable(s). Should include a column of ones as the intercept
% Y: dependent variable(s)
% GRS_stat: [F-stat p-value]

N = length(Y(1,:));%number of dependent variables
L = length(X(1,:))-1;%number of independent variables
T = length(X);%number of observations

beta = zeros(L+1,N);%initialize betas
for i = 1:N
    beta(:,i) = regress(Y(:,i),X);%obtain betas for each dependent variables
end

resid = Y - X*beta;%obtain residuals


resid_cov = zeros(N,N);%initialize residuals covarinace matrix
for i = 1:N
    for j = 1:N
        resid_cov(i,j) = 1/(T-L-1)*sum(resid(:,i).*resid(:,j));
    end
end

X_mu = mean(X(:,2:end))';
X_cov = cov(X(:,2:end));
%alpha = mean(Y)'-beta(2,:)'*X_mu;
alpha = beta(1,:)';

W = alpha'*inv(resid_cov)*alpha/(1+X_mu'*inv(X_cov)*X_mu);%compute test-stat
W_norm = (T/N)*((T-N-L)/(T-L-1))*W;%normalize test-stat
p = fcdf(W_norm,N,T-N-L);
GRS_stat = [W_norm,p];
end






