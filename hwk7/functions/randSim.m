function [MVP_list,TP_list] = randSim(mean_r,mean_rf,cov_mat,timerange,rep)
%randSim:
%r_mean:
%cov_mat: covariance matrix
%timerange: number of data in the given time period
%rep: repetition


MVP_list = zeros(2,rep);
TP_list =zeros(2,rep);
for i = 1:rep
    new_stocks = mvnrnd(mean_r,cov_mat,timerange);
    cov_mat1 = cov(new_stocks);
    mean_r1 = (mean(new_stocks))';
    
    [MVP,TP] = MVTP(mean_r1,mean_rf,cov_mat1);
    MVP_list(:,i) = [MVP(3:end)'*mean_r;sqrt(MVP(3:end)'*cov_mat*MVP(3:end))];
    TP_list(:,i) = [TP(3:end)'*mean_r;sqrt(TP(3:end)'*cov_mat*TP(3:end))];
end
end