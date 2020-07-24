function Success = RunMaze(maze, Value,start,goal,Nmax)
St = start;
sz = size(maze);
if strcmp(goal, 'end')
    goal = size(Value);
end
i = 0;
Success = 1;
mazecurrent = maze;
while any(St ~= goal)
    i = i+1;
    mazecurrent(St(1),St(2)) = (1-mazecurrent(St(1),St(2)))/2+0.25;
    %imagesc(mazecurrent); colormap(gray);drawnow;
    Neighbors = [St(1)-1 St(2);St(1) St(2)+1; St(1)+1 St(2); St(1) St(2)-1];
    Valid1 = intersect(find(Neighbors(:,1)~=0),find(Neighbors(:,2)~=0));
    Valid2 = intersect(find(Neighbors(:,1)<=sz(1)),find(Neighbors(:,2)<=sz(2)));
    Valid = intersect(Valid1,Valid2);
    row = Neighbors(Valid',1);
    col = Neighbors(Valid',2);
    NVals = Value(sub2ind(sz,row,col));
    St = Neighbors(Valid(find(NVals == max(NVals))),:);
    %keyboard;
    if i>Nmax
        Success = 0;
        break;
    end
end
mazecurrent(St(1),St(2)) = 0.5;
%imagesc(mazecurrent); colormap(gray);drawnow;
set(gca,'XTick',[], 'YTick', []);
%keyboard;
end