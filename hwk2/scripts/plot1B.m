f1 = figure;
set(f1,'units','normalized','outerposition',[0 0 1 1]);
plot(EffFront_b(:,2),EffFront_b(:,1));
hold on
scatter(std_stk,R_stk_b);
scatter(MVP_b(2),MVP_b(1),70,'r','filled');
scatter(TP_b(2),TP_b(1),50,'r','filled');
hold off
legend('Efficient Frontier(new)','10 industries(new)');
labelpoints([MVP_b(2) TP_b(2)],[MVP_b(1) TP_b(1)],{'MVP(new)','Tangency Portfolio(new)'});
ylabel('Expected Return(%)');
xlabel('Standard Deviation(%)');
box off; grid on;
print(f1,'-dpng','-r200','figures/1B');
close(f1);

f2 = figure;
set(f2,'units','normalized','outerposition',[0 0 1 1]);
plot(EffFront(:,2),EffFront(:,1),EffFront_b(:,2),EffFront_b(:,1));
hold on
scatter(std_stk,R_stk,'k');
scatter(std_stk,R_stk_b);

scatter([TP(2) MVP(2)],[TP(1) MVP(1)],70,'r','filled');
scatter([TP_b(2) MVP_b(2)],[TP_b(1) MVP_b(1)],70,'b','filled');
hold off

legend('Efficient Frontier','Efficient Frontier(new)','10 industries',...
    '10 industries(new)');
labelpoints([MVP(2) TP(2)],[MVP(1) TP(1)],{'MVP','Tangency Portfolio'});
labelpoints([MVP_b(2) TP_b(2)],[MVP_b(1) TP_b(1)],{'MVP(new)','Tangency Portfolio(new)'});
ylabel('Expected Return(%)');
xlabel('Standard Deviation(%)');
box off; grid on;
print(f2,'-dpng','-r200','figures/1B_combine');
close(f2);
