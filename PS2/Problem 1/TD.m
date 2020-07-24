function [Vend,k] = TD(maze,rewards,V,N,alpha,gamma,start,goal)
St = start;
if strcmp(goal, 'end')
    goal = size(V);
end

trans = MazeTransitions(maze);
ptrans = MazeProb(trans);
%figure;
for k = 1:N
    transitions = ptrans(St(1),St(2),:);
    transitions = transitions./min(transitions(find(transitions > 0)));
    mazecurrent = maze;
    mazecurrent(St(1),St(2)) = 0.5;
    %imagesc(mazecurrent); colormap(gray);drawnow;
    transset = [repelem(1,transitions(1)),repelem(2,transitions(2)), repelem(3,transitions(3)), repelem(4,transitions(4))];
    newstate = transset(randi(length(transset)));
    %keyboard;
    switch newstate
        case 1
            St1 = [St(1)-1 St(2)];
        case 2
            St1 = [St(1) St(2)+1];
        case 3
            St1 = [St(1)+1 St(2)];
        case 4
            St1 = [St(1) St(2)-1];
    end
    V(St(1),St(2)) = V(St(1),St(2)) + alpha*(rewards(St(1),St(2))+gamma*V(St1(1),St1(2))-V(St(1),St(2)));
    if all(St1 == goal)
        break;
    end
    St = St1;
end
% disp('Finished');
% disp('N =')
% disp(k);
Vend = V;
Vend(find(maze == 0)) = min(min(Vend))-1;

end