function a = test(w,pattern,d,dt,lesion)
    a = pattern;                                %half-pattern for testing
    if lesion                                   %lesion by setting all connections to and from MTL neurons to 0
        w(:,17:20) = 0;
        w(17:20,:) = 0;
    end
    %keyboard;
    for t = 1:dt                                %cycle through activity for three iterations
        a = UpdateActivity(a,w,d);
    end
    %keyboard;
end