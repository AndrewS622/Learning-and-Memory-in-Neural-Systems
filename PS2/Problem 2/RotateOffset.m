function Offset = RotateOffset(loc,x,s)
    tangent = s*cos(s*loc);
    th = atan(tangent);
    
    x = x-[loc,sin(s*loc)];
    R = [cos(th) -sin(th);sin(th) cos(th)];
    Offset = R*x';
    Offset = Offset+[loc,sin(s*loc)]';
    %keyboard;
end