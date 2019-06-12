f1 = figure;
set(f1,'units','normalized','outerposition',[0 0 1 1]);

plot(fac_mean*100);
hold on 
plot(result_FM.summary(1,2:end)*100);
hold off
legend('Mean excess returns','Predicted excess returns');
ylabel('Excess returns(%)');
xlabel('Factors');
box off; grid on;
print(f1,'-dpng','-r200','figures/7b');
close(f1);

f1 = figure;
set(f1,'units','normalized','outerposition',[0 0 1 1]);

plot(zeros(7,1));
hold on 
plot(result_FM_std.summary(1,2:end)*100);
hold off
legend('Mean excess returns','Predicted excess returns');
ylabel('Excess returns(%)');
xlabel('Factors');
box off; grid on;
print(f1,'-dpng','-r200','figures/7b_stdized');
close(f1);