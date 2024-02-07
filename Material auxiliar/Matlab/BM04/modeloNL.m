function dv = modeloNL(t,v)

u = 400-140*sin(2*t);
dv = (1/2085)*(u-0.4*v.^2-228);