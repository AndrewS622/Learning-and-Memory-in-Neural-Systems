E = -61.2;
m0=0.0820;
%E = -65;
%m0 = 0.05;
h0=0.4603;
n0=0.3772;
tinc=0.001;
tspan=0:tinc:30;

G_Na = 120;
G_K = 36;
G_L = 0.3;
E_Na = 55;
E_K = -72;
E_L = -50;

%% Part 1
figure;
y0 = [E m0];
I = @(t) (t>=5 && t<6)*10;
[T,Y3] = ode45(@(t,in) HHSimp2(t,in,I), tspan, y0);

subplot(3,1,1);
plot(T,Y3(:,1));
xlabel('Time (ms)');
ylabel('Membrane Voltage (mV)');

am = @(x) -0.1*(40+x)/(exp(-(40+x)/10)-1);
bm = @(x) 4*exp(-(65+x)/18);

for i = 1:length(T)
    Ei = Y3(i,1);
    g_K3(i) = G_K*n0^4;
    g_Na3(i) = G_Na*h0*Y3(i,2);
    IT(i)=I(T(i));
end

subplot(3,1,2);
plot(T,g_Na3);
xlabel('Time (ms)');
ylabel('Sodium Conductance (mS/cm^2)');

subplot(3,1,3);
plot(T,g_K3);
xlabel('Time (ms)');
ylabel('Potassium Conductance (mS/cm^2)');

if exist('comp') && comp == 2
    figure;
    subplot(1,2,1);
    plot(Y(:,1),g_Na);
    title('Full Model');
    xlabel('Voltage (mV)');
    ylabel('Sodium Conductance (mS/cm^2)');
    subplot(1,2,2);
    plot(Y3(:,1),g_Na3);
    title('Simplified Model');
    xlabel('Voltage (mV)');
    ylabel('Sodium Conductance (mS/cm^2)');
end

%% Part 2
Vrange = -70:2:60;
Vrange = Vrange-1.5;
mrange = 0:0.05:1;
dVrange = zeros(length(Vrange),length(mrange));
dmrange = dVrange;
minf = zeros(length(Vrange),1);
m0 = minf;

am = @(x) -0.1*(40+x)/(exp(-(40+x)/10)-1);
bm = @(x) 4*exp(-(65+x)/18);

for i = 1:length(Vrange)
    for j = 1:length(mrange)
        Out = HHSimp2(1,[Vrange(i) mrange(j)],0);
        dVrange(i,j) = Out(1);
        dmrange(i,j) = Out(2);
    end
    Ei = Vrange(i);
    minf(i) = am(Ei)/(am(Ei)+bm(Ei));
    B = G_Na*(Ei-E_Na)*h0;
    C = G_L*(Ei-E_L)+G_K*(Ei-E_K)*n0^4;
    mroot = roots([B 0 0 C]);
    %keyboard;
    re = find(imag(mroot)==0);
    if ~isempty(re)
        m0(i) = mroot(re(end));
    end
    
end

figure;
%quiver(Vrange,mrange,dVrange',dmrange','AutoScaleFactor',2,'MaxHeadSize',0.0005);
q=quiver(Vrange,mrange,-1*dVrange',-25.*dmrange');
q.ShowArrowHead = 'off';
q.Marker = '^';
q.MarkerSize = 2;
q.MarkerFaceColor = 'b';
title('2D Phase Plot for Simplified HH Model');
xlabel('Voltage (mV)');
ylabel('Fraction of m Gates Open');
hold on;

plot(Vrange,minf,'r');
plot(Vrange,m0,'b');

%% Part 3
Iin = [0 4 8];
color = ['y','g','k'];
for i = 1:length(Iin)
    I = @(t) (t>=5 && t<6)*Iin(i);
    [T,Y] = ode45(@(t,in) HHSimp2(t,in,I), tspan, y0);
    plot(Y(:,1),Y(:,2),color(i));
end
xlim([-75 60]);
ylim([0 1]);