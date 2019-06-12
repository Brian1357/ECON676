function [r_mom,r_summary] = mom(r_matrix,rf,startperiod,endperiod,N)
%mom3: pick up the N maximum assets/industries, and N minimum
%assets/industries from the prior "startperiod" to "endperiod"
%r_matrix:raw data
%rf: risk-free rate to calculate Sharpe ratio
%N: number of assets/industries picked
%P.S.: Sharpe ratio is annualized, which means SR*sqrt(12)
if startperiod == endperiod
    %set up the r_prior
    r_prior = zeros(size(r_matrix));
    r_prior(1:endperiod,:) = nan;
    for i = endperiod+1:length(r_matrix(:,1))
        r_prior(i,:) = r_matrix(i-endperiod,:);
    end
    
    rankmaxmin = zeros(length(r_matrix(:,1)),2*N);
    rankmaxmin(1:endperiod,:) = nan;
    for i = 1:length(r_matrix(:,1))-endperiod
        [~,rankmaxmin(i+endperiod,1:N)] = maxk(r_prior(i+endperiod,:),N);
        [~,rankmaxmin(i+endperiod,N+1:2*N)] = mink(r_prior(i+endperiod,:),N);
    end
    
    r_mom = zeros(length(r_matrix(:,1)),1);
    r_mom(1:endperiod,:) = nan;
    for i = endperiod+1:length(r_matrix)
        r_mom(i,1) = nanmean(r_matrix(i,rankmaxmin(i,1:3))) - nanmean(r_matrix(i,rankmaxmin(i,4:6)));
    end  
    
end


if startperiod ~= endperiod
    r_prior = zeros(size(r_matrix));
    r_prior(1:endperiod,:) = nan;
    for i = endperiod+1:length(r_matrix(:,1))
        r_prior(i,:) = sum(r_matrix(i-endperiod:i-startperiod,:));
    end
    
    rankmaxmin = zeros(length(r_matrix(:,1)),2*N);
    rankmaxmin(1:endperiod,:) = nan;
    for i = 1:length(r_matrix(:,1))-endperiod
        [~,rankmaxmin(i+endperiod,1:N)] = maxk(r_prior(i+endperiod,:),N);
        [~,rankmaxmin(i+endperiod,N+1:2*N)] = mink(r_prior(i+endperiod,:),N);
    end
    
    r_mom = zeros(length(r_matrix(:,1)),1);
    r_mom(1:endperiod,:) = nan;
    for i = endperiod+1:length(r_matrix)
        r_mom(i,1) = nanmean(r_matrix(i,rankmaxmin(i,1:3))) - nanmean(r_matrix(i,rankmaxmin(i,4:6)));
    end
end

r_summary = [nanmean(r_mom),nanmean(r_mom)/(nanstd(r_mom)/sqrt(sum(r_matrix(:,1)))),...
    nanmean(r_mom-rf)/nanstd(r_mom)*sqrt(12),nanstd(r_mom)];