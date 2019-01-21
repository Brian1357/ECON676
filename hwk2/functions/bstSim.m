function [MVP_list,TP_list] = bstSim(stocks,mean_rf,timerange,rep)
%randSim:
%stocks: return data for stocks
%mean_rf: avg risk-free rate
%timerange: number of data in the given time period
%rep: repetition

MVP_list = zeros(2,rep);
TP_list =zeros(2,rep);
for i = 1:rep
    randList = randi([1 timerange],timerange,1);
    new_stocks = stocks(randList,:);
    cov_mat1 = cov(new_stocks);
    mean_r1 = (mean(new_stocks))';
    
    [MVP,TP] = MVTP(mean_r1,mean_rf,cov_mat1);
    MVP_list(:,i) = MVP;
    TP_list(:,i) = TP;
end
end