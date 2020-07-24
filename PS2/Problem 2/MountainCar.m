%state is characterized by velcoity and position
%action is characterized by left, right, or nothing
alpha = 0.15;            %learning rate
gamma = 0.9;            %discounting factor
xmin = -1.2;            %bounds on position
xmax = 0.6;             
vmin = -0.07;           %bounds on velocity
vmax = 0.07;
Amin = -1;              %bounds on acceleration
Amax = 1;
x = round([xmin:0.1:xmax],1);
v = round([vmin:0.01:vmax],2);
A = [Amin,0,Amax];
R = -1*ones(length(x),1);
R(end-1) = 0;
R(end) = 0;
Q = zeros(length(x),length(v),length(A));
s = 3;                  %slope factor for sinusoid
N = 30000;                %number of training trials
aconst = 0.001;
vconst = -0.0025;
e = 0.1;
Ntrial = 6000;

trajectory = zeros(Ntrial,N,3);

for l = 1:Ntrial
vt = 0;
xt = -.1*(randi(3)+3);
At = 2;
    for n = 1:N
        trajectory(l,n,:) = [xt,vt,A(At)];

        Aold = At;
        At = eGreedy(Q(find(x == round(xt,1)),find(v == round(vt,2)),:),e);
        xold = round(xt,1);
        vold = round(vt,2);
        %keyboard;

        [xt,vt] = StateUpdate(xt,vt,A(At),s,x,v,aconst,vconst);
        Q(find(x == xold),find(v == vold),Aold) = SARSA(Q(find(x == xold),find(v == vold),Aold),Q(find(x == round(xt,1)),find(v == round(vt,2)),At),R(find(x == round(xt,1))),alpha,gamma);
        %keyboard;
        %DrawCar([x(1),x(end)],[-1.2 1.2],xt,s);drawnow;
        if xt >= x(end)-0.1
            count(l) = n;
            break;
        end
    end
end

vt = 0;
xt = -.1*(randi(3)+3);
At = 2;
for n = 1:3*N
    Qs = Q(find(x == round(xt,1)),find(v == round(vt,2)),:);
    At = find(Qs == max(Qs));
    if length(At) > 1
       At = randi(length(At),1);
    end
    [xt,vt] = StateUpdate(xt,vt,A(At),s,x,v,aconst,vconst);
    xtest(n) = xt;
    vtest(n) = vt;
    %saveas(gcf,join(['Fig',string(n)]));
    %DrawCar([x(1),x(end)],[-1.2 1.2],xt,s);drawnow;
    if xt >= x(end)-0.1
        disp('finished');
        disp(n);
        break;
    end
end