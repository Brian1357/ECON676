f1 = figure;
set(f1,'units','normalized','outerposition',[0 0 1 1]);
plot(EffFront(:,2),EffFront(:,1),EffFront_c1(:,2),EffFront_c1(:,1));
hold on
scatter(std_stk,R_stk,'k');
hold off
legend('Efficient Frontier','Efficient Frontier(new)','10 industries');
ylabel('Expected Return(%)');
xlabel('Standard Deviation(%)');
box off; grid on;
print(f1,'-dpng','-r200','figures/1C_diag');
close(f1);

f2 = figure;
set(f2,'units','normalized','outerposition',[0 0 1 1]);
plot(EffFront(:,2),EffFront(:,1),EffFront_c2(:,2),EffFront_c2(:,1));
hold on
scatter(std_stk,R_stk,'k');
hold off
legend('Efficient Frontier','Efficient Frontier(new)','10 industries');
ylabel('Expected Return(%)');
xlabel('Standard Deviation(%)');
box off; grid on;
print(f2,'-dpng','-r200','figures/1C_idtt');
close(f2);
