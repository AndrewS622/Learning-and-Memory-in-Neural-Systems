E = -61.2;
m0=0.0820;
h0=0.4603;
n0=0.3772;
tinc=0.001;
tspan=0:tinc:30;
c = 0.8;

G_Na = 120;
G_K = 36;
G_L = 0.3;
E_Na = 55;
E_K = -72;
E_L = -50;

%% Part 1

figure;
y0 = [E n0];
I = @(t) (t>=5 && t<6)*10;
[T,Y2] = ode45(@(t,in) HHSimp(t,in,I), tspan, y0);

subplot(3,1,1);
plot(T,Y2(:,1));
xlabel('Time (ms)');
ylabel('Membrane Voltage (mV)');

am = @(x) -0.1*(40+x)/(exp(-(40+x)/10)-1);
bm = @(x) 4*exp(-(65+x)/18);

for i = 1:length(T)
    Ei = Y2(i,1);
    minf=am(Ei)/(am(Ei)+bm(Ei));
    g_Na(i) = G_Na*minf^3*(c-Y2(i,2));
    g_K2(i) = G_K*Y2(i,2)^4;
    IT(i)=I(T(i));
end

subplot(3,1,2);
plot(T,g_Na);
xlabel('Time (ms)');
ylabel('Sodium Conductance (mS/cm^2)');

subplot(3,1,3);
plot(T,g_K2);
xlabel('Time (ms)');
ylabel('Potassium Conductance (mS/cm^2)');

if exist('comp') && comp == 1
    figure;
    subplot(1,2,1);
    plot(Y(:,1),g_K);
    title('Full Model');
    xlabel('Voltage (mV)');
    ylabel('Potassium Conductance (mS/cm^2)');
    subplot(1,2,2);
    plot(Y2(:,1),g_K2);
    title('Simplified Model');
    xlabel('Voltage (mV)');
    ylabel('Potassium Conductance (mS/cm^2)');
end

%% Part 2
Vrange = -70:2:60;
Vrange = Vrange-1.5;
nrange = 0:0.05:1;
dVrange = zeros(length(Vrange),length(nrange));
dnrange = dVrange;
ninf = zeros(length(Vrange),1);
minf = zeros(length(Vrange),1);
n0 = minf;

an = @(x) -0.01*(55+x)/(exp(-(55+x)/10)-1);
bn = @(x) 0.125*exp(-(x+65)/80);
am = @(x) -0.1*(40+x)/(exp(-(40+x)/10)-1);
bm = @(x) 4*exp(-(65+x)/18);

for i = 1:length(Vrange)
    for j = 1:length(nrange)
        Out = HHSimp(1,[Vrange(i) nrange(j)],0);
        dVrange(i,j) = Out(1);
        dnrange(i,j) = Out(2);
    end
    Ei = Vrange(i);
    ninf(i) = an(Ei)/(an(Ei)+bn(Ei));
    minf(i) = am(Ei)/(am(Ei)+bm(Ei));
    A = G_K*(Ei-E_K);
    B = G_Na*minf(i)^3*(Ei-E_Na);
    C = G_L*(Ei-E_L)+c*G_Na*minf(i)^3*(Ei-E_Na);
    nroot = roots([A 0 0 -B C]);
    %keyboard;
    re = find(imag(nroot)==0);
    if ~isempty(re)
        n0(i) = nroot(re(end));
    end
    
end

figure;
%quiver(Vrange,nrange,dVrange',dnrange','AutoScaleFactor',2,'MaxHeadSize',0.0005);
q=quiver(Vrange,nrange,-1*dVrange',-1000.*dnrange');
q.ShowArrowHead = 'off';
q.Marker = '^';
q.MarkerSize = 2;
q.MarkerFaceColor = 'b';
title('2D Phase Plot for Simplified HH Model');
xlabel('Voltage (mV)');
ylabel('Fraction of K Gates Open, n');
hold on;

plot(Vrange,ninf,'r');
plot(Vrange,n0,'b');

%% Part 3
Iin = [0 4 8];
color = ['y','g','k'];
for i = 1:length(Iin)
    I = @(t) (t>=5 && t<6)*Iin(i);
    [T,Y] = ode45(@(t,in) HHSimp(t,in,I), tspan, y0);
    plot(Y(:,1),Y(:,2),color(i));
end
xlim([-75 60]);
ylim([0 1]);