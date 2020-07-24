function [Output] = HH(t,in,I)
E = in(1);
m = in(2);
h = in(3);
n = in(4);
Output = zeros(4,1);

G_Na = 120;
G_K = 36;
G_L = 0.3;
E_Na = 55;
E_K = -72;
E_L = -50;

Output(1) = -G_Na.*m^3.*h.*(E-E_Na)-G_K.*n^4.*(E-E_K)-G_L.*(E-E_L)+I(t);

am = @(x) -0.1*(40+x)/(exp(-(40+x)/10)-1);
bm = @(x) 4*exp(-(65+x)/18);

ah = @(x) 0.07*exp(-(x+65)/20);
bh = @(x) 1/(exp(-(35+x)/10)+1);

an = @(x) -0.01*(55+x)/(exp(-(55+x)/10)-1);
bn = @(x) 0.125*exp(-(x+65)/80);

Output(2) = am(E)*(1-m)-bm(E)*m;
Output(3) = ah(E)*(1-h)-bh(E)*h;
Output(4) = an(E)*(1-n)-bn(E)*n;

tm = 1/(am(E)+bm(E));
minf=am(E)/(am(E)+bm(E));
th = 1/(ah(E)+bh(E));
hinf = ah(E)/(ah(E)+bh(E));
tn = 1/(an(E)+bn(E));
ninf = an(E)/(an(E)+bn(E));