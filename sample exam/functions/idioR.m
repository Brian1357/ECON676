function idio_risk = idioR(std_r,std_mkt,cov_mat, weight_mkt)

N = length(std_r);
betas = zeros(N,1);
idio_risk = zeros(N,1);

for i = 1:N
    betas(i) = sum(cov_mat(i,:).*weight_mkt)/std_mkt^2;
    idio_risk(i) = sqrt(std_r(i)^2-betas(i)^2*std_mkt^2);
end
end

