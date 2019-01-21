function [MVP_list,TP_list] = randSim(mean_r,mean_rf,cov_mat,timerange,rep)
%randSim:
%r_mean:
%cov_mat: covariance matrix
%timerange: number of data in the given time period
%rep: repetition

MVP_list = zeros(2,rep);
TP_list =zeros(2,rep);
for i = 1:rep
    new_stocks = repmat(mean_r',timerange,1)+randn(timerange,length(mean_r))*chol(cov_mat);
    cov_mat1 = cov(new_stocks);
    mean_r1 = (mean(new_stocks))';
    
    [MVP,TP] = MVTP(mean_r1,mean_rf,cov_mat1);
    MVP_list(:,i) = MVP;
    TP_list(:,i) = TP;
end
end