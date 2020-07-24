function ptrans = MazeProb(trans)
s = size(trans);
ptrans = zeros(s);
for i = 1:s(1)
    for j = 1:s(2)
        if sum(trans(i,j,:)) == 0
            continue;
        end
        ptrans(i,j,:) = trans(i,j,:)./sum(trans(i,j,:));
    end
end