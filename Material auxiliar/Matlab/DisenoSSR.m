%% Ubicación de polos
sys1 = zpk(-5,[0,-1,-4],20);
OS = 9.5;
ts = .74;
zeta = round(-log(OS/100)/sqrt(pi^2+log(OS/100)^2),2)
wn = round(4/zeta/ts,1)
pd = -zeta*wn + 1j*wn*sqrt(1-zeta^2)
conv([1 10],poly([pd,conj(pd)]))

%%
A = [0 1 0;0 0 1;0 -4 -5];
B = [0;0;1];
C = [100 20 0];
D = 0;

syms s a b c
K = [a b c];

collect(det(s*eye(3)-(A - B*K)),'s')

%%

K = place(A,B,[-10,pd,conj(pd)])
Acl = A-B*K;
syscl = ss(Acl,B,C,D);
Pcl = pole(syscl)
step(syscl)

%%
kr = -1/(C*((A-B*K)\B))
step(kr*syscl)

%% Observador de estado de orden completo más controlador con realimentación de estado

format shortG
A = [-1 0 0;0 -10 5;0 -5 -10];
B = [0.7;0.7;0.3];
C = [1 0 2];
D = 0;

sys = ss(A,B,C,D)

if rank(ctrb(A,B)) == size(A,1)
    disp('El sistema es controlable')
else
    disp('El sistema NO es controlable')
end

if rank(obsv(A,C)) == size(A,1)
    disp('El sistema es observable')
else
    disp('El sistema NO es observable')
end


step(sys)
%%

OS = 10.5;
ts = 2;
zeta = round(-log(OS/100)/sqrt(pi^2+log(OS/100)^2),2)
wn = round(4/zeta/ts,1)
pd = round(-zeta*wn + 1j*wn*sqrt(1-zeta^2),2)

%% controlador

K = acker(A,B,[pd,conj(pd),4*real(pd)])
Acl = A-B*K;
syscl = ss(Acl,B,C,D);
Pcl = pole(syscl)
Kr = -1/(C*((A-B*K)\B))
step(Kr*syscl)
%% observador

po = [-15 -20 -25];
L = acker(A.',C.',po)'

%% dinámica combinada

At = [ A-B*K             B*K
       zeros(size(A))    A-L*C ];

Bt = [    B*Kr
       zeros(size(B)) ];

Ct = [ C    zeros(size(C)) ];

sysFull = ss(At,Bt,Ct,D);
figure(1)
step(sysFull)



t = 0:1E-6:2;
x0 = [0.1 0.1 0.1];
[y,t,x] = lsim(sysFull,ones(size(t)),t,[x0 x0]);

n = 3;
e = x(:,n+1:end);
x = x(:,1:n);
x_est = x - e;

% Save state variables explicitly to aid in plotting
x1 = x(:,1); x2 = x(:,2); x3 = x(:,3);
x1_est = x_est(:,1); x2_est = x_est(:,2); x3_est = x_est(:,3);

figure(2)
hold on
plot(t,x1,'color',[234, 56, 41]/255)
plot(t,x1_est,'color',[234, 56, 41]/255,'LineStyle',':')
plot(t,x2,'color',[2, 101, 220]/255)
plot(t,x2_est,'color',[2, 101, 220]/255,'LineStyle',':')
plot(t,x3,'color',[0, 143, 93]/255)
plot(t,x3_est,'color',[0, 143, 93]/255,'LineStyle',':')
legend('$x_1$','$\hat{x}_1$','$x_2$','$\hat{x}_1$','$x_3$','$\hat{x}_3$','interpreter','latex')
xlabel('Time (sec)')
hold off