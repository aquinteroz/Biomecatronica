% El punto de operación es (20.7,400)

tfin = 5000;
vbar = 20.7;
v0 = 19.7;
[tNL,vNL] = ode45(@modeloNL,linspace(0,tfin,20000),v0);
[tL,vL] = ode45(@modeloL,linspace(0,tfin,20000),v0-vbar);
plot(tNL,vNL,'LineWidth',4,'Color','#D6D2C4')
hold on
plot(tL,vL+vbar,'LineWidth',2,'Color','#007A78','LineStyle','--')
legend('Non linear','Linear')
axis([0 5000 0 max(vNL)])