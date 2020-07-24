function transitions = TransitionScale(transitions, Valid, NVals)

        transitionsvalid = transitions(Valid);
        if nnz(transitionsvalid) == 1
            
        else
            for i = 1:length(transitionsvalid)
                transscale(i) = transitionsvalid(i)*sum(NVals(setdiff(1:length(transitionsvalid),i)));
            end
            transnorm = transscale/sum(transscale);
                    %keyboard;
            transint = ceil(transnorm./min(transnorm(find(transnorm > 0))));

            transitions(Valid) = transint;
        end
end