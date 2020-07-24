function [val] = grad_desc(fcn, x0)
%This function takes in a user-defined function and a vector of initial conditions
%It returns a vector of the optimized points to minimize the L2 norm of
%acceleration

thresh = 10E-9;          %convergence threshold
count = 0;                %count variable to keep track of the consecutive number of below-threshold iterations
countthresh = 100000;          %number of required consecutive iterations below threshold
y1=fcn(x0);               %evaluate at the initial point
alph=0.05;                %learning rate
x=x0;

num = 0;

N=50;
Tf=0.5;
dt=Tf/(N+1);
figure;
for i = 3:length(x0)-2
   j=i-2;
   g(j) = 2*(y1(i-2)-2*y1(i-1)+y1(i));
end

for i = 1:length(g)
    x(i+2)=x0(i+2)-alph*g(i);
end

while count < countthresh
    y2=fcn(x);
    ss1 = sum(y1.^2);
    ss2 = sum(y2.^2)
    converge = abs(ss2-ss1);
    if (converge < thresh)
        count=count+1;
    else
        count = 0;
    end
    if count < countthresh
        y1 = y2;
        for i = 3:length(x0)-2
            j=i-2;
            g(j) = 2*(y1(i-2)-2*y1(i-1)+y1(i));
        end

        for i = 1:length(g)
            x(i+2)=x(i+2)-alph*g(i);
        end
    end
    if mod(num,10000) == 0 && num ~= 0
        subplot(3,1,1);
        plot(1:length(x),x);
        ylabel('Position');
        hold on;

        subplot(3,1,2);
        plot(1:length(x)-1,diff(x)/dt);
        ylabel('Velocity');
        hold on;

        subplot(3,1,3);
        plot(1:length(x)-2,diff(x,2)/dt^2);
        ylabel('Acceleration');
        xlabel('Time (sec)');
        hold on;
    end
    num=num+1;
end
val = x;
disp(ss2);
disp(num);
