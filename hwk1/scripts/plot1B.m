f1 = figure;
set(f1,'units','normalized','outerposition',[0 0 1 1]);

percent_list = zeros(50,2);
for i = 1:50
    percent_list(i,1) = 1/i^2*sum(std_stk(1:i).^2)/std_list(i)^2;
    percent_list(i,2) = 1-percent_list(i,1);
end

bar(100*percent_list,'stacked');
ylabel('Contribution(%)');
ylim([0 100]);
xlabel('Number of stocks');
legend('Variance','Covariance');
box off; grid on;
title('Contribution of variance and covariance');
print(f1,'-dpng','-r200','figures/1B');
close(f1);
