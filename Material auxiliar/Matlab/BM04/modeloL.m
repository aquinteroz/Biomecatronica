function dv = modeloL(t,v)

u = -140*sin(2*t);
dv = 4.8e-4*u - 0.008*v;