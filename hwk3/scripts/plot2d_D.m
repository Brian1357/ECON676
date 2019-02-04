f1 = figure;
set(f1,'units','normalized','outerposition',[0 0 1 1]);

scatter(beta_25_tan_MY,avg_r_25,'filled');
ylabel('Average return(%)');
xlabel('$\beta_{iM}$');
box off; grid on;
print(f1,'-dpng','-r200','figures/2d_D');
close(f1);