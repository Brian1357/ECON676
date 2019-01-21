f1 = figure;
set(f1,'units','normalized','outerposition',[0 0 1 1]);
plot(time,beta_1);
hold on
plot(time,bind_1(:,1),'--');
plot(time,bind_1(:,2),'--');
plot(time,beta_2);
plot(time,bind_2(:,1),'--');
plot(time,bind_2(:,2),'--');
hold off
ylabel('OLS beta');
xlabel('Time(YYYY)');
box off; grid on;
legend('Method1(full-sample method)','Method1:lower bound','Method1:upper bound','Method2(one-year method)',...
    'Method2:lower bound','Method2:upper bound');
print(f1,'-dpng','-r200','figures/2B');
close(f1);
