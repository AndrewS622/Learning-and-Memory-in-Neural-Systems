function trans = MazeTransitions(maze)

s = size (maze);
s1 = s(1);
s2 = s(2);
trans = zeros(s1,s2,4); %NESW
for i = 2:s(1)-1
    for j = 2:s(2)-1
        if maze(i,j) == 0
            continue;
        end
        trans(i,j,1) = maze(i-1,j);
        trans(i,j,2) = maze(i,j+1);
        trans(i,j,3) = maze(i+1,j);
        trans(i,j,4) = maze(i,j-1);
    end
end
%% Edge cases
trans(1,2:s2-1,2) = maze(1,3:s2);
trans(1,2:s2-1,3) = maze(2,2:s2-1);
trans(1,2:s2-1,4) = maze(1,1:s2-2);

trans(s1,2:s2-1,1) = maze(s1-1,2:s2-1);
trans(s1,2:s2-1,2) = maze(s1,3:s2);
trans(s1,2:s2-1,4) = maze(s1,1:s2-2);

trans(2:s1-1,1,1) = maze(1:s1-2,1);
trans(2:s1-1,1,2) = maze(2:s1-1,2);
trans(2:s1-1,1,3) = maze(3:s1,1);

trans(2:s1-1,s2,1) = maze(1:s1-2,s2);
trans(2:s1-1,s2,3) = maze(3:s1,s2);
trans(2:s1-1,s2,4) = maze(2:s1-1,s2-1);

%% Corners
trans(1,1,2) = maze(1,2);
trans(1,1,3) = maze(2,1);

trans(1,s2,3) = maze(2,s2);
trans(1,s2,4) = maze(1,s2-1);

trans(s1,1,1) = maze(s1-1,1);
trans(s1,1,2) = maze(s1,2);

trans(s1,s2,1) = maze(s1-1,s2);
trans(s1,s2,4) = maze(s1,s2-1);

for i = 1:s1
    for j = 1:s2
        if maze(i,j) == 0
            trans(i,j,:) = 0;
        end
    end
end