function A = eGreedy(Q,e)
    if rand(1) >= 1-e
        A = find(Q == max(Q));
        if length(A) > 1
            A = randi(length(A),1);
        end
    else
        A = randi(3);
    end
end