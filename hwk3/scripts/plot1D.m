f1 = figure;
set(f1,'units','normalized','outerposition',[0 0 1 1]);

scatter(beta_49,avg_r_49,'filled');
ylabel('Average return(%)');
xlabel('$\beta_{iM}$');
box off; grid on;
print(f1,'-dpng','-r200','figures/1D');
close(f1);