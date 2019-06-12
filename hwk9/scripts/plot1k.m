f1 = figure;
set(f1,'units','normalized','outerposition',[0 0 1 1]);
plot([1:16],k.plotx(:,1)*100);
hold on
plot([1:16],k.plotx(:,2)*100);
hold off
legend('Predicted expected returns','Average actual returns');
ylabel('Expected returns(%)');
xlabel('Markets');
box off; grid on;
print(f1,'-dpng','-r200','figures/1k');
close(f1);
