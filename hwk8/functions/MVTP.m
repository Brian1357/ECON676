function [MVP,TP,frontier] = MVTP(mean_r,mean_rf,cov_mat)
%MVTP: obtain Mean-Variance portfolio and tangency portfolio
%-----------------------------------------------------------
%result:
%   MVP:(1)ret_std:[return;std](2)weight:weight of each portfolio
%    TP:(1)ret_std:[return;std](2)weight:weight of each portfolio
%   frontier:[std,returns]
%-----------------------------------------------------------
%mean_r: average returns (N*1 matrix)
%mean_rf: average risk-free return (a value)
%cov_mat: covariance matrix (N*N matrix with no nans)

one_vec = ones(length(mean_r),1);
w_MVP = inv(cov_mat)*one_vec/(one_vec'*(inv(cov_mat))'*one_vec);
w_TP = inv(cov_mat)*(mean_r-one_vec*mean_rf)/(one_vec'*inv(cov_mat)*(mean_r-one_vec*mean_rf));

MVP.ret_std = [w_MVP'*mean_r;sqrt(w_MVP'*cov_mat*w_MVP)];
MVP.weight = w_MVP;
TP.ret_std = [w_TP'*mean_r;sqrt(w_TP'*cov_mat*w_TP)];
TP.weight = w_TP;

%obtain the efficient frontier(copied from Prof.Brian Weller's code)
S = cov_mat;
z = mean_r; % note the prime to make z a column vector of means
N = length(S);

A = ones(N,1)'*inv(S)*ones(N,1);
B = ones(N,1)'*inv(S)*z;
C = z'*inv(S)*z;
D = A*C - B^2;

mu = [0:1.5*max(z)/50:1.5*max(z)]; %% Use this line for more general program
%mu = [0:.02/50:.02]; %% Use this line to make graphs all comparable
for i = 1:length(mu)
%     lam(i) = (C - mu(i)*B)/D;
%     gam(i) = (mu(i)*A - B)/D;
%     w_star(:,i) = lam(i)*inv(S)*ones(N,1) + gam(i)*inv(S)*z;
    sig_2(i) = (A*mu(i)^2 - 2*B*mu(i) + C)/D;
end

frontier = [sqrt(sig_2)', mu'];
end