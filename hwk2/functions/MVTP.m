function [MVP,TP] = MVTP(mean_r,mean_rf,cov_mat)
%MVTP:
%mean_r: average returns
%mean_rf: average risk-free return
%cov_mat: covariance matrix

one_vec = ones(length(mean_r),1);
w_MVP = inv(cov_mat)*one_vec/(one_vec'*(inv(cov_mat))'*one_vec);
w_TP = inv(cov_mat)*(mean_r-one_vec*mean_rf)/(one_vec'*inv(cov_mat)*(mean_r-one_vec*mean_rf));

MVP = [w_MVP'*mean_r;sqrt(w_MVP'*cov_mat*w_MVP)];
TP = [w_TP'*mean_r;sqrt(w_TP'*cov_mat*w_TP)];

end