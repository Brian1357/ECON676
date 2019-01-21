f1 = figure;
set(f1,'units','normalized','outerposition',[0 0 1 1]);

std_list = zeros(50,1);
for i = 1:50
    std_list(i) = stdStock(cov_stk,i,repmat(1/i,i,1));
end

plot((1:50),std_list);
ylabel('Annualized Standard Deviation(%)');
xlabel('Number of stocks');
box off; grid on;
print(f1,'-dpng','-r200','figures/1A');
close(f1);

f1 = figure;
set(f1,'units','normalized','outerposition',[0 0 1 1]);

std_list_sample = [std_list(5),std_list(10),std_list(25),std_list(50)];
plot([5,10,25,50],std_list_sample);
ylabel('Annualized Standard Deviation(%)');
xlabel('Number of stocks');
box off; grid on;
print(f1,'-dpng','-r200','figures/1A_sample');
close(f1);