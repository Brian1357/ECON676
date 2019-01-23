f1 = figure;
set(f1,'units','normalized','outerposition',[0 0 1 1]);
plot(EffFront(85:100,2),EffFront(85:100,1));
hold on
scatter(MVP_list_bst(2,:),MVP_list_bst(1,:),'k');
scatter(MVP(2),MVP(1),'r','filled');
hold off
legend('Efficient Frontier','MVP(simulated)','MVP');
ylabel('Expected Return(%)');
xlabel('Standard Deviation(%)');
box off; grid on;
print(f1,'-dpng','-r200','figures/1E_MVP');
close(f1);

f2 = figure;
set(f2,'units','normalized','outerposition',[0 0 1 1]);
plot(EffFront(75:150,2),EffFront(75:150,1));
hold on
scatter(TP_list_bst(2,:),TP_list_bst(1,:),'k');
scatter(TP(2),TP(1),'r','filled');
hold off
legend('Efficient Frontier','TP(simulated)','TP');
ylabel('Expected Return(%)');
xlabel('Standard Deviation(%)');
box off; grid on;
print(f2,'-dpng','-r200','figures/1E_TP');
close(f2);