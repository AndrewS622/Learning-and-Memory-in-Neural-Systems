E = -61.2;
figure;
m0=0.0820;
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
Vrange = [-70:0.01:55];
for i = 1:length(Vrange)
    am = -0.1*(40+Vrange(i))/(exp(-(40+Vrange(i))/10)-1);
    bm = 4*exp(-(65+Vrange(i))/18);

    ah = 0.07*exp(-(Vrange(i)+65)/20);
    bh = 1/(exp(-(35+Vrange(i))/10)+1);

    an = -0.01*(55+Vrange(i))/(exp(-(55+Vrange(i))/10)-1);
    bn = 0.125*exp(-(Vrange(i)+65)/80);

    tm = 1/(am+bm);
    minf(i)=am/(am+bm);
    th = 1/(ah+bh);
    hinf(i) = ah/(ah+bh);
    tn = 1/(an+bn);
    ninf(i) = an/(an+bn);
end

plot(Vrange,minf);
hold on;
plot(Vrange,hinf);
plot(Vrange,ninf,'k');
yl = ylim;
line([E E],yl,'Color','k');
xlabel('Voltage (mV)');
ylabel('Gating Variable Value');
legend('m_{inf}','h_{inf}','n_{inf}');
hold off;

%% Part 2

figure;
for k = 1:10
    I = @(t) k;
    y0 = [E m0 h0 n0];
    [T,Y] = ode45(@(t,in) HH(t,in,I), tspan, y0);
    subplot(5,2,k);
    plot(T,Y(:,1));
    xlabel('Time (ms)');
    ylabel('Voltage (mV)');
    plottitle = ['Input Current = ',num2str(k)];
    title(plottitle);
end

%% Part 3

figure;
I = @(t) (t>=5 && t<6)*10;
[T,Y] = ode45(@(t,in) HH(t,in,I), tspan, y0);

subplot(3,1,1);
plot(T,Y(:,1));
xlabel('Time (ms)');
ylabel('Membrane Voltage (mV)');

for i = 1:length(T)
    g_Na(i) = G_Na*Y(i,2)^3*(Y(i,3));
    g_K(i) = G_K*Y(i,4)^4;
    %g_Na(i) = Y(i,3);
    %g_K(i) = Y(i,4);
    IT(i)=I(T(i));
end

% subplot(3,1,1);
% plot(T,IT);
% xlabel('Time (ms)');
% ylabel('Input Current (\mu A/cm^2)');

subplot(3,1,2);
plot(T,g_Na);
xlabel('Time (ms)');
ylabel('Sodium Conductance (mS/cm^2)');

subplot(3,1,3);
plot(T,g_K);
xlabel('Time (ms)');
ylabel('Potassium Conductance (mS/cm^2)');
return;
%% Part 4
figure;

Irange = 0:0.1:10;
for k = 1:length(Irange)
    I = @(t) (t>=5 && t<6)*Irange(k);
    [T,Y] = ode45(@(t,in) HH(t,in,I), tspan, y0);
    Vmax(k) = max(Y(:,1));
end

plot(Irange,Vmax);
xlabel('Current Input (\mu A/cm^2)');
ylabel('Maximal Membrane Voltage (mV)');
title('HH Neuron Activation Function');

%% Part 5
figure;

Irange2 = 1:20;
trange = 1:30;
step = 0.001;
tspan2 = 0:step:40;
for k = 1:length(Irange2)
    for l = 1:length(trange)
        I = @(t) (t>=5 && t<6)*10 + (t>=6+trange(l) && t<6+trange(l)+1)*Irange2(k);
        [T,Y] = ode45(@(t,in) HH(t,in,I), tspan2, y0);
        Vmax2(k,l) = max(Y(((6+trange(l))/step):end,1));
%         if k == 2
%             plot(T,Y(:,1));
%             hold on;
%             disp(l);
%             pause;
%             
%         end
    end
    plot(Vmax2(k,:));
    xlabel('Time of Second Pulse Relative to End of First (ms)');
    ylabel('Peak Voltage (mV)');
    hold on;
end
%% Part 6

figure;
thresh = 0;
Irange3 = 1:1:45;
spikes = cell(1,length(Irange3));
ind = spikes;
ISI = spikes;
ISIavg = zeros(1,length(Irange3));
freq = ISIavg;
for k = 1:length(Irange3)
    I = @(t) (t>=1)*Irange3(k);
    [T,Y] = ode45(@(t,in) HH(t,in,I), tspan, y0);
    V = Y(:,1);
    plot(T,V);
    hold on;
    ind{k} = find(V>thresh);
    if isempty(ind{k})
        freq(k) = 0;
        continue;
    end
    inds = find(diff(ind{k}) ~= 1);
    spikes{k} = [ind{k}(1);ind{k}(inds+1)];
    line([T(spikes{k}(1)) T(spikes{k}(1))],[-60 60]);
    if length(spikes{k}) <= 1
        freq(k) = 0;
        print('empty')
    else
        for i = 1:length(spikes{k})-1
            ISI{k} = [ISI{k},(spikes{k}(i+1)-spikes{k}(i))];
        end
        ISIavg(k) = tinc*mean(ISI{k});
        freq(k) = 1000/ISIavg(k);
        line([T(spikes{k}(2)) T(spikes{k}(2))],[-60 60]);
    end
    xlabel('Time (ms)');
    ylabel('Voltage (mV)');
    hold off;
    if k>46
        pause;
    end
end

figure;
plot(Irange3,freq);
xlabel('Injected Current \mu A/cm^2');
ylabel('Firing Frequency (Hz)');
