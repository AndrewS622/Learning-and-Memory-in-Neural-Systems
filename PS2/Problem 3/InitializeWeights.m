function [w,wfixed] = InitializeWeights()
%% Initialize weights
%weights initialized between 0.0 and 0.2
w = rand(20)/5;
% w(:,j) are all connections projecting from neuron j
% w(i,:) are all connections projecting to neuron i
wfixed = ones(20);                  %ones if neurons are connected, zeros if not

connect = cell(1,5); %which layers are connected to which neurons
connect{1} = reshape((4*([3,4,5]'-1)+[1:4])',1,12);
connect{2} = reshape((4*([3,4,5]'-1)+[1:4])',1,12);
connect{3} = reshape((4*([1,2,5]'-1)+[1:4])',1,12);
connect{4} = reshape((4*([1,2,5]'-1)+[1:4])',1,12);
connect{5} = reshape((4*([1,2,3,4]'-1)+[1:4])',1,16);
for j = 1:5
    connected_neurons = connect{j};
    all_neurons = 1:20;
    disconnected_neurons = setdiff(all_neurons,connected_neurons);
    w(disconnected_neurons,4*(j-1)+[1:4]) = 0;
    wfixed(disconnected_neurons,4*(j-1)+[1:4]) = 0;
end