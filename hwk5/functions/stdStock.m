function stdev = stdStock(covariance, number, weight)
%stdStock: 
%covariance:
%number:
%weight:

covariance_weight = covariance(1:number,1:number);
%assign weight to each covariance
for i = 1:number
    for j = 1:number
        covariance_weight(i,j) = weight(i)*weight(j)*covariance_weight(i,j);
    end
end
%add these weighted covariance up to obtain the variance
%stdev = sqrt(variance)
stdev = sqrt(sum(sum(covariance_weight)));
end