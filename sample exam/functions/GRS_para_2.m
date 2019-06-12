function GRS_stat = GRS_para_2(mean_old,cov_mat,mean_mkt,sigma_mkt,rf,T)
% GRS_para: compute the GRS test statistic with statistics
% mean, sigma, rf
% GRS_stat: [F-stat p-value]

N = length(mean_old)-1;%number of other portfolios

[~,TP,~] = MVTP(mean_old',rf,cov_mat);

mean_new = TP.ret_std(1);
sigma_new = TP.ret_std(2);

W_norm = (T-N-1)/N*((mean_new-rf)^2/sigma_new^2-(mean_mkt-rf)^2/sigma_mkt^2)/(1+(mean_mkt-rf)^2/sigma_mkt^2);
p = fcdf(W_norm,N,T-N-1);
GRS_stat = [W_norm,1-p];
end