f1 = figure;
set(f1,'units','normalized','outerposition',[0 0 1 1]);
plot(EffFront(:,2),EffFront(:,1));
hold on
scatter(std_stk,R_stk,'k');
scatter(MVP(2),MVP(1),70,'r','filled');
scatter(TP(2),TP(1),50,'r','filled');
hold off
legend('Efficient Frontier','10 industries');
labelpoints(MVP(2),MVP(1),{'MVP'});
labelpoints(TP(2),TP(1),{'Tangency Portfolio'});
ylabel('Expected Return(%)');
xlabel('Standard Deviation(%)');
box off; grid on;
print(f1,'-dpng','-r200','figures/1A');
close(f1);
