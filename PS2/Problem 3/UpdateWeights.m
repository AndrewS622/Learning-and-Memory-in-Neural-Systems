%% Update weights
function w = UpdateWeights(a,w,wfixed,lam,rho)
    lamMTL = lam(1);
    lamCor = lam(2);
    rhoMTL = rho(1);
    rhoCor = rho(2);
    %update connections
    for i = 1:4:16  
        neurons = i:i+3;                                %neurons in the layer
        wf = wfixed(neurons,:);                         %connections
        acti = a(neurons);                              %activity of the neurons in the layer
        abar = mean(a(find(wf(1,:)==1)));               %average activity of all neurons connected to the layer
        ajminusabar = wf.*(a-abar);                     %difference of each projection neuron and the average
        l = [repelem(lamCor,16),repelem(lamMTL,4)];
        r = [repelem(rhoCor,16),repelem(rhoMTL,4)];
        w(neurons,:) = w(neurons,:)+l.*acti'.*ajminusabar-r.*w(neurons,:);  %update weights
        %keyboard;
    end
    
    neurons = 17:20;
    wf = wfixed(neurons,:);
    acti = a(neurons);
    abar = mean(a(find(wf(1,:)==1)));
    ajminusabar = wf.*(a-abar);
    l = [repelem(lamMTL,20)];
    r = [repelem(rhoMTL,20)];
    w(neurons,:) = w(neurons,:)+l.*acti'.*ajminusabar-r.*w(neurons,:);  %update weights
    
    w=w.*wfixed;                                        %make sure all neurons that were unconnected remain so
    w(find(w > 1)) = 1;
    w(find(w < 0)) = 0;
end