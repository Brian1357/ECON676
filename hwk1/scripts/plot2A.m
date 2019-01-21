f1 = figure;
set(f1,'units','normalized','outerposition',[0 0 1 1]);
plot(time,Vol_TXN1*sqrt(12));
hold on
plot(time,Vol_TXN2*sqrt(12));
hold off
ylabel('Annualized Standard Deviation(%)');
xlabel('Time(YYYY)');
box off; grid on;
legend('Method1:TXN','Method2:TXN');
print(f1,'-dpng','-r200','figures/2A_TXN');
close(f1);

f1 = figure;
set(f1,'units','normalized','outerposition',[0 0 1 1]);
plot(time,Vol_mkt1*sqrt(12));
hold on
plot(time,Vol_mkt2*sqrt(12));
hold off
ylabel('Annualized Standard Deviation(%)');
xlabel('Time(YYYY)');
box off; grid on;
legend('Method1:market','Method2:market');
print(f1,'-dpng','-r200','figures/2A_mkt');
close(f1);
