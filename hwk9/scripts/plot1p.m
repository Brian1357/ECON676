f1 = figure;
set(f1,'units','normalized','outerposition',[0 0 1 1]);
scatter(o.TP.ret_std(2)*100,o.TP.ret_std(1)*100,'filled');
hold on
scatter(p.TP_evenodd.ret_std(2)*100,p.TP_evenodd.ret_std(1)*100,'filled');
plot(o.frontier(:,1)*100,o.frontier(:,2)*100);
hold off
legend('Tangency Portfolio','even-odd tangency portfolio');
ylabel('Expected returns(%)');
xlabel('Standard Deviation(%)');
ylim([0 1.6])
box off; grid on;
print(f1,'-dpng','-r200','figures/1p');
close(f1);
clear x