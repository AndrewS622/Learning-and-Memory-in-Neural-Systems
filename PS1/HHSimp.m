function [Output] = HHSimp(t,in,I)
C = 0.8;
E = in(1);
n = in(2);
h = C-n;
Output = zeros(2,1);

G_Na = 120;
G_K = 36;
G_L = 0.3;
E_Na = 55;
E_K = -72;
E_L = -50;

am = @(x) -0.1*(40+x)/(exp(-(40+x)/10)-1);
bm = @(x) 4*exp(-(65+x)/18);

an = @(x) -0.01*(55+x)/(exp(-(55+x)/10)-1);
bn = @(x) 0.125*exp(-(x+65)/80);

Output(2) = an(E)*(1-n)-bn(E)*n;

minf=am(E)/(am(E)+bm(E));
tn = 1/(an(E)+bn(E));
ninf = an(E)/(an(E)+bn(E));

Output(1) = -G_Na.*minf^3.*h.*(E-E_Na)-G_K.*n^4.*(E-E_K)-G_L.*(E-E_L)+I(t);