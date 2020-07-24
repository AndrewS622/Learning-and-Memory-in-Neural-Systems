function Q = SARSA(Q1,Q2,R,alpha,gamma)
    Q = Q1 + alpha*(R+gamma*Q2-Q1);
    %keyboard;
end