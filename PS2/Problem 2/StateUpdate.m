function [xtnew,vtnew] = StateUpdate(xt,vt,a,s,x,v,aconst,vconst)
    vtnew = max(min(vt+aconst*a+vconst*cos(s*xt),v(end)),v(1));
    xtnew = max(min(xt + vt,x(end)),x(1));
    if xtnew <= x(1)
        vtnew = 0.01;
    end
    %keyboard;
end