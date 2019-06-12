function MDD = maxDD(returns)
%maxDD: Historical Maximum Drawdown thorughout the time
%returns: a TxN time-series return matrix
%------------------------------------------------------
%results:
%     MDD.trough: the historical trough values 
%     MDD.troughposition: which day is the historical trough
%     MDD.peak: the historical peak values before the trough
%     MDD.MDD: the Maximum Drawdown
%     MDD.summary: the minimum Maximum Darwdown and its length of pain
%     period
%------------------------------------------------------


T = length(returns(:,1));
N = length(returns(1,:));

data = zeros(T,N);

price = returns + 1;

logprice = zeros(T,N);
for i = 1:N
    for j = 1:T
        logprice(j,i) = log(price(j,i));
    end
end


for i = 2:T
    data(i,1:N) = nansum(logprice(1:i,:));
end

data = exp(data);

MDD.MDD = zeros(4,N);
[MDD.MDD(1,1:N),MDD.MDD(3:4,1:N)]= maxdrawdown(data,'return');
MDD.MDD(2,:) = MDD.MDD(4,:)-MDD.MDD(3,:);

end