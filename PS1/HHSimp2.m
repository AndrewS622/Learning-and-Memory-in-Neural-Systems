function [Output] = HHSimp2(t,in,I)
E = in(1);
m = in(2);
h0 = 0.4603;
n0 = 0.3772;
Output = zeros(2,1);

G_Na = 120;
G_K = 36;
G_L = 0.3;
E_Na = 55;
E_K = -72;
E_L = -50;

am = @(x) -0.1*(40+x)/(exp(-(40+x)/10)-1);
bm = @(x) 4*exp(-(65+x)/18);

Output(2) = am(E)*(1-m)-bm(E)*m;

tm = 1/(am(E)+bm(E));
minf=am(E)/(am(E)+bm(E));

Output(1) = -G_Na.*m^3.*h0.*(E-E_Na)-G_K.*n0^4.*(E-E_K)-G_L.*(E-E_L)+I(t);