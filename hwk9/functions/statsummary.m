function summary = statsummary(data,rf)
%statsummary: a series of statistics of the data
%data: a TxN time-series matrix
%rf: used to calculate the Sharpe ratio, but if rf = 0, then it is not used
%------------------------------------------------------
%results:
%     summary.mean: 1st row: mean returns 
%                   2nd row: standard deviations
%                   3rd row: t-stats
%     summary.count: number of non-nan observations in each column
%     summary.skew: skewness of each column
%     summary.kurt: kurtosis of each column
%     summary.SR:1st row: Sharpe ratio estimates 
%                2nd-3rd row: Confidence Interval under normal dist
%                4th-5th row: Confidence Interval in general case
%                sigma3: The number of observations that exceeds 3 sigmas
%                and its percentage
%------------------------------------------------------

% mean and tstats
summary.mean = [nanmean(data);nanstd(data)];
summary.count = sum(~isnan(data));
summary.mean(3,:) = summary.mean(1,:)./summary.mean(2,:).*sqrt(summary.count);
%skewness and kurtosis
summary.skew = skewness(data);
summary.kurt = kurtosis(data);
%Sharpe ratio
summary.SR = (summary.mean(1,:)-nanmean(rf))./summary.mean(2,:)*sqrt(12);
summary.SR(2,:) = summary.SR(1,:)+1.96*sqrt(1./(summary.count-1).*(1+summary.mean(1,:).^2./(2*summary.mean(2,:).^2)));
summary.SR(3,:) = summary.SR(1,:)-1.96*sqrt(1./(summary.count-1).*(1+summary.mean(1,:).^2./(2*summary.mean(2,:).^2)));
summary.SR(4,:) = summary.SR(1,:)+1.96*sqrt(1./(summary.count-1).*(1+summary.SR(1,:).^2/4.*(summary.kurt-1)-summary.SR(1,:).*summary.skew));
summary.SR(5,:) = summary.SR(1,:)-1.96*sqrt(1./(summary.count-1).*(1+summary.SR(1,:).^2/4.*(summary.kurt-1)-summary.SR(1,:).*summary.skew));
%percentage of exceeeding +/- 3*sigma
summary.sigma3 = nansum(data>(summary.mean(1,:)+3*summary.mean(2,:)));
summary.sigma3(2,:) = nansum(data<(summary.mean(1,:)-3*summary.mean(2,:)));
summary.sigma3(3,:) = summary.sigma3(1,:)+summary.sigma3(2,:);
summary.sigma3(4,:) = summary.sigma3(3,:)./summary.count;
%maximum drawdown
summary.MDD = maxDD(data);
%Combinaion
%summary.comb = [summary.mean;summary.skew;summary.kurt;summary.SR;summary.sigma3(4)];
end