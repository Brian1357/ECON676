f1 = figure;
set(f1,'units','normalized','outerposition',[0 0 1 1]);
scatter(h.TP.ret_std(2)*100,h.TP.ret_std(1)*100,'filled');
hold on
scatter(a.mean(2,:)*100,a.mean(1,:)*100,'filled');
x = [e.sum_US.mean,e.sum_UK.mean,e.sum_EU.mean,e.sum_JP.mean,e.sum_EQ.mean,...
    e.sum_FX.mean,e.sum_FI.mean,e.sum_CM.mean];
scatter(x(2,:)*100,x(1,:)*100,'filled');
scatter(i.TP_evenodd.ret_std(2)*100,i.TP_evenodd.ret_std(1)*100,'filled');
plot(h.frontier(:,1)*100,h.frontier(:,2)*100);
hold off
legend('Tangency Portfolio','Individual value and momentum factors','50-50 portfoilos',...
    'even-odd tangency portfolio');
ylabel('Expected returns(%)');
xlabel('Standard Deviation(%)');
ylim([0 1.6])
box off; grid on;
print(f1,'-dpng','-r200','figures/1i');
close(f1);
clear x