function [J,p,cv] = GRS_test(y_table,x_table)
%   GRS test:a statistical test of the hypothesis that alpha=0 for all Y
%   y_table: Regression table( only Y )
%   x_table: Independent variables
%   rf1: risk-free rate
%   Note: if rf should be subtracted, it should be considered in y_table
%   already
% Returns: (1) J: GRS statistics
%          (2) p: p-value
%          (3) cv: critical value

% Filter Mechanism
total_table=[y_table,x_table];
order=zeros(size(total_table,2),1);
for i=1:size(total_table,2)
    start=find(total_table(:,i)>-9999);
    order(i,1)=start(1);
end
y_table=y_table(max(order):end,:);
x_table=x_table(max(order):end,:);


mu_1=nanmean(x_table)';

T=size(y_table,1);
N=size(y_table,2);
L=size(x_table,2);

% Regression
beta_1=zeros(L+1,size(y_table,2));
residual=zeros(T,N);
for i=1:size(y_table,2)
    [b,bint,e]=regress(y_table(:,i),[ones(size(y_table,1),1),x_table]);
    beta_1(:,i)=b;
    residual(:,i)=e;
end

% returns in max sharpe ratio
column_1=ones(L,1);
A_1=x_table;
V_1=cov(A_1);
%w_mvp_1=(column_1'*V_1^(-1))/(column_1'*V_1^(-1)*column_1);
%rt_mvp_1=w_mvp_1*A_1';



% Test Part
alpha_1=beta_1(1,:)';
residual_mat_1=residual;
cov_res_1=residual_mat_1'*residual_mat_1/(T-L-1);
F_1=A_1;
F_mat_1=zeros(T,size(x_table,2));
for i=1:T
    F_mat_1(i,:)=mu_1;
end
cov_mat_1=(F_1-F_mat_1)'*(F_1-F_mat_1)/(T-1);

J=(T/N)*((T-N-L)/(T-L-1))*(alpha_1'*cov_res_1^(-1)*alpha_1)/(1+mu_1'*cov_mat_1^(-1)*mu_1);
p=1-fcdf(J,N,T-N-L);% p-value
cv=finv(0.95,N,T-N-L); % critical value



end

