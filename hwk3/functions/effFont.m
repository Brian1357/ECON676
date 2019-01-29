function eff = effFont(cov_mat,mean_r,low_r,upp_r)
%effFont:
%cov_mat: covariance matrix
%mean_r: average returns
%low_r: lower limit of returns
%upp_r: upper limit of returns

one_vec = ones(length(mean_r),1);
eff = zeros(floor((upp_r-low_r)/0.01)+1,2+length(mean_r));
count = 1;
for i = low_r:0.01:upp_r
    w = inv(cov_mat)*[mean_r,one_vec]*inv([mean_r,one_vec]'*inv(cov_mat)*[mean_r,one_vec])*[i;1];
    eff(count,1) = w'*mean_r;
    eff(count,2) = sqrt(w'*cov_mat*w);
    eff(count,3:end) = w';
    count = count+1;
end
end