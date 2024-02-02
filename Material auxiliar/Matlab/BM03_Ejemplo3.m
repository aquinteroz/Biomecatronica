syms k1 k2 k3 f1 f2 f3 m1 m2 s
syms A [2 2] matrix
A(1,1) = k1 + k2 +(f1 + f3)*s+m1*s^2;
A(1,2) = -(f3*s+k2);
A(2,1) = -(f3*s+k2);
A(2,2) = k2 + k3+(f2+f3)*s+m2*s^2;
S = symmatrix2sym(A);
delta = collect(det(S),s)