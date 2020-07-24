%% Parameters
Nsim = 50;                                  %number of simulations for averaging
lambdaMTL = 0.1;
lambdaCor = 0.002;
lambda = [lambdaMTL lambdaCor];             %learning rates
rhoMTL = 0.04;
rhoCor = 0.0008;
rho = [rhoMTL rhoCor];                      %forgetting rates
delta = 0.7;                                %activity decay rate
sCor1 = [2 4];
NCor1 = sCor1(1)*sCor1(2);
sCor2 = [2 4];
NCor2 = sCor2(1)*sCor2(2);
sMTL = [1 4];
NMTL = sMTL(1)*sMTL(2);
numsteps = 3;
Ntot = NMTL+NCor1+NCor2;                    %total number of cells

Nconsolidation = 0:10:500;                  %different consolidation times
Numconsol = length(Nconsolidation);
error = zeros(2,Numconsol,Nsim);            %Sum of squared errors

%% Initialize weights
[w,wfixed] = InitializeWeights;


%% Training Procedure
for sim = 1:Nsim
    dt = 3; %cycling time steps
    p1 = zeros(1,20);               
    p2 = zeros(1,20);

    %initialize two different random patterns with one active cell in
    %each cortical group of four
    rand1 = randperm(4,2);
    rand2 = 4+randperm(4,2);
    rand3 = 8+randperm(4,2);
    rand4 = 12+randperm(4,2);

    p1(rand1(1)) = 1;
    p1(rand2(1)) = 1;
    p1(rand3(1)) = 1;
    p1(rand4(1)) = 1;

    p2(rand1(2)) = 1;
    p2(rand2(2)) = 1;
    p2(rand3(2)) = 1;
    p2(rand4(2)) = 1;

    % Iterate over consolidation time
    for count = 1:Numconsol
        Nconsol = Nconsolidation(count);
        [w,wfixed] = InitializeWeights;

        order = mod(randperm(4),2)+1;               %present patterns in random order
        for i = 1:4
            if order(i) == 1                        %initialize activity for pattern
                a = p1;
            else
                a = p2;
            end
            %imagesc(reshape(a,4,5)');colormap(gray);drawnow;
            %keyboard;
            for n = 1:dt                            %cycle through activity and weight updates
                a = UpdateActivity(a,w,delta);
                w = UpdateWeights(a,w,wfixed,lambda,rho);
                %imagesc(reshape(a,4,5)');colormap(gray);drawnow;
                %keyboard;
            end
        end

        consolcount = 0;
        while consolcount < Nconsol             %cycle through consolidation steps
            consolcount = consolcount + 1;
            arand = randi(4);                   %choose one random MTL neuron to be active
            a = zeros(1,20);
            a(16+arand) = 1;
            for n = 1:dt
                a = UpdateActivity(a,w,delta);
                w = UpdateWeights(a,w,wfixed,lambda,rho);
            end
        end

        testperm = randperm(4);                     %choose random presentation order
        for testiter = 1:4
            testpat = testperm(testiter);
            astart = zeros(1,20);
            switch testpat                          %four different half-patterns for presentation
                case 1
                    astart(rand1(1)) = 1;
                    astart(rand2(1)) = 1;
                    patt = p1;
                case 2
                    astart(rand3(1)) = 1;
                    astart(rand4(1)) = 1;
                    patt = p1;
                case 3
                    astart(rand1(2)) = 1;
                    astart(rand2(2)) = 1;
                    patt = p2;
                case 4
                    astart(rand3(2)) = 1;
                    astart(rand4(2)) = 1;
                    patt = p2;
            end
            %imagesc(reshape(patt,4,5)');colormap(gray);drawnow;
            %keyboard;
            %imagesc(reshape(astart,4,5)');colormap(gray);drawnow;
            %keyboard;
            aoutnorm(testiter,:) = test(w,astart,delta,dt,0);           %evaluate with non-lesioned system
            %imagesc(reshape(aoutnorm(testiter,:),4,5)');colormap(gray);drawnow;
            %keyboard;
            aoutlesion(testiter,:) = test(w,astart,delta,dt,1);         %evaluate with lesioned system
            %imagesc(reshape(aoutlesion(testiter,:),4,5)');colormap(gray);drawnow;
            %keyboard;

            SSEnorm(testiter) = sum((aoutnorm(testiter,1:16)-patt(1:16)).^2);   %sum of squared errors for each trial
            SSElesion(testiter) = sum((aoutlesion(testiter,1:16)-patt(1:16)).^2);
        end
        %keyboard;
        error(1,count,sim) = sum(SSEnorm);                              %total SSE over all four presentations
        error(2,count,sim) = sum(SSElesion);
    end
end

figure;
hold on;
plot(Nconsolidation,11-mean(error(1,:,:),3),'k');
plot(Nconsolidation,11-mean(error(2,:,:),3),'--k');
xlabel('Number of Consolidation Cycles');
ylabel('Performance');
legend({'Normal','Lesioned'});
hold off;