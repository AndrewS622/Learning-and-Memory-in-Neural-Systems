%% Update activity
function a = UpdateActivity(a,w,d)
% update cortex
    neurons = 1:16;
    a(neurons) = d*a(neurons)+a*w(neurons,:)'+(rand(1,16)-0.5)/10;
    for i = 1:4:length(a)-4             %lateral inhibition in groups of 4
        neurons = i:i+3;
        act = a(neurons);               %activity of neurons in the layer
        m_ind = find(act==max(act))+i-1; %neuron with maximal activity
        a(setdiff(neurons,m_ind)) = 0;
    end
    
    a(find(a > 1)) = 1;
    a(find(a < 0)) = 0;
% update MTL  
    neurons_in_layer = 17:20;           %repeat for MTL
    a(neurons_in_layer) = d*a(neurons_in_layer)+a*w(neurons_in_layer,:)'+(rand(1,4)-0.5)/10;
    m_ind = 16+find(a(neurons_in_layer) == max(a(neurons_in_layer)));
    a(setdiff(neurons_in_layer,m_ind)) = 0;
    a(find(a > 1)) = 1;
    a(find(a < 0)) = 0;
end
