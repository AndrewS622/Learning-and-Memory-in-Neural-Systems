%% Initialization
maze = [1 0 1 1 1 1 1;1 1 1 0 0 1 0; 0 0 0 1 1 1 0; 1 1 1 1 0 0 1; 1 0 0 0 1 1 1; 1 0 1 1 1 1 1;1 1 1 0 1 1 1];
imagesc(maze);colormap(gray); pbaspect([1 1 1]);
set(gca,'XTick',[], 'YTick', []);
rewards = -1.*maze;
Vtrue = -1*[26 -1 22 21 20 19 20;25 24 23 -1 -1 18 -1;-1 -1 -1 15 16 17 -1; 11 12 13 14 -1 -1 3;10 -1 -1 -1 4 3 2;9 -1 5 4 3 2 1;8 7 6 -1 2 1 0];

N = 1000; %maximum number of training iterations
Ntrial = 100; %number of trials
Nmax = 1000; %max number of test iterations
V = zeros(size(maze)); %value
Vcontrol = -1*maze;

alpha = 0.2; %learning rate
gamma = 0.9; %discounting factor
start = [1 1]; %starting position
goal = 'end';

%% Train Random Search RL
k = zeros(1,Ntrial);
Learning = k;
for i = 1:Ntrial
    Vold = V;
    [V, k(i)] = TD(maze,rewards,V,N,alpha,gamma,start,goal);
    Learning(i) = mean(mean(V-Vold));
end
%V = V/sqrt(Ntrial);
imagesc(V);colormap(gray);
RunMaze(maze, V, start, goal, Nmax);
pause;
%% Train Controlled RL
kctrl = zeros(1,Ntrial);
Learningcontrol = kctrl;

for i = 1:Ntrial
    %keyboard;
    Vcontrolold = Vcontrol;
    [Vcontrol,kctrl(i)] = TDControl(maze,rewards,Vcontrol,N,alpha,gamma,start,goal);
    Learningcontrol(i) = mean(mean(Vcontrol-Vcontrolold));
end
imagesc(Vcontrol);colormap(gray);
RunMaze(maze, Vcontrol, start, goal, Nmax);
pause;
subplot(2,1,1);
plot(Learning);
xlabel('Training Trial Number');
ylabel('Average Change in Value');
title('Random');
subplot(2,1,2);
plot(Learningcontrol);
xlabel('Training Trial Number');
ylabel('Average Change in Value');
title('Controlled');


%% Test influence of Trial Number Parameters
Ns = 10:100:1010;
Ntrials = 1:10:101;
kconverge = zeros(length(Ns),length(Ntrials));
kconvergecontrol = kconverge;
Ntest = 100;
for i = 1:length(Ns) %maximum number of training iterations
    for j = 1:length(Ntrials) %number of trials
        V = zeros(size(maze)); %value
        Vcontrol = -1*maze;
        NumSuccess = 0;
        NumSuccessControl = 0;
        Ntrial = Ntrials(j);
        N = Ns(i);
        
        for k = 1:Ntest
            for l = 1:Ntrial
                [V, ~] = TD(maze,rewards,V,N,alpha,gamma,start,goal);
            end
            Succeed = RunMaze(maze, V, start, goal, Nmax);
            kconverge(i,j) = kconverge(i,j)+Succeed;
        end
        
        for k = 1:Ntest
            for l = 1:Ntrial
                [Vcontrol,~] = TDControl(maze,rewards,Vcontrol,N,alpha,gamma,start,goal);
            end
            Succeed = RunMaze(maze, Vcontrol, start, goal, Nmax);
            kconvergecontrol(i,j) = kconvergecontrol(i,j)+Succeed;
        end
        disp(N);
        disp(Ntrial);
    end
end

figure;
surf(Ns, Ntrials, kconverge);
xlabel('Maximum Number of Training Iterations');
ylabel('Number of Training Episodes');
zlabel('Completed Maze Runs (%)');
figure;
surf(Ns, Ntrials, kconvergecontrol);
xlabel('Maximum Number of Training Iterations');
ylabel('Number of Training Episodes');
zlabel('Completed Maze Runs (%)');


%% Test influence of Learning Parameters
Ntrial = 50;
N = 300;
alphas = 0.1:0.1:1.0;
gammas = 0.1:0.1:1.0;
hyperparams = zeros(length(alphas),length(gammas),2);
hyperparamscontrol = hyperparams;

for i = 1:length(alphas)
    for j = 1:length(gammas)
        alpha = alphas(i);
        gamma = gammas(j);
        trials = 0;
        trialscontrol = 0;
        for k = 1:Ntest
            for l = 1:Ntrial
                [V, t] = TD(maze,rewards,V,N,alpha,gamma,start,goal);
                trials = trials + t;
            end
            hyperparams(i,j,2) = trials/Ntrial;
            Succeed = RunMaze(maze, V, start, goal, Nmax);
            hyperparams(i,j,1) = hyperparams(i,j,1)+Succeed;
        end
        
        for k = 1:Ntest
            for l = 1:Ntrial
                [Vcontrol,tc] = TDControl(maze,rewards,Vcontrol,N,alpha,gamma,start,goal);
                trialscontrol = trialscontrol + tc;
            end
            hyperparamscontrol(i,j,2) = trialscontrol/Ntrial;
        
            Succeed = RunMaze(maze, Vcontrol, start, goal, Nmax);
            hyperparamscontrol(i,j,1) = hyperparamscontrol(i,j,1)+Succeed;
        end
        disp(alpha);
        disp(gamma);
    end
end

figure;
surf(alphas, gammas, hyperparams(:,:,1));
xlabel('Learning Rate');
ylabel('Discounting Factor');
zlabel('Completed Maze Runs (%)');
figure;
surf(alphas, gammas, hyperparamscontrol(:,:,1));
xlabel('Learning Rate');
ylabel('Discounting Factor');
zlabel('Completed Maze Runs (%)');

figure;
surf(alphas, gammas, hyperparams(:,:,2)/N);
xlabel('Learning Rate');
ylabel('Discounting Factor');
zlabel('Average Number of Iterations to Completion');
figure;
surf(alphas, gammas, hyperparamscontrol(:,:,2)/N);
xlabel('Learning Rate');
ylabel('Discounting Factor');
zlabel('Average Number of Iterations to Completion');