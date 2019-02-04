function [draws] = randSample(T,replacement)
% draw T random samples of length N
%
% sample use to take all returns from a set of randomly drawn months:
%     rets = randn(100,10);
%     rets(:,randSample(10))

if nargin<3, replacement = true; end
    
if replacement, draws = ceil(rand(T,1)*T);
else, draws = randperm(T);
end

end
