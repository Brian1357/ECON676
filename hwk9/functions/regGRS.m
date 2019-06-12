function model = regGRS(X,Y)
%regGRS: run the regression and GRS test
% X: independent variable(s). Should include a column of ones as the intercept
% Y: dependent variable(s)
% GRS_stat: [F-stat p-value]

model.GRS = GRS(X,Y);

M = length(Y(1,:));
N = length(X(1,:));

model.alpha = zeros(3,M);
model.squares = zeros(2,M);
model.betas = zeros(N-1,M);
model.betas_tStat = zeros(N-1,M);
for i = 1:M
    result = fitlm(X(:,2:end),Y(:,i));
    
    model.alpha(1,i) = result.Coefficients.Estimate(1);
    model.alpha(2,i) = result.Coefficients.SE(1);
    model.alpha(3,i) = result.Coefficients.tStat(1);
    
    model.squares(1,i) = result.Rsquared.Ordinary;
    model.squares(2,i) = result.Rsquared.Adjusted;
    
    model.betas(:,i) = result.Coefficients.Estimate(2:end);
    model.betas_tStat(:,i) = result.Coefficients.tStat(2:end);
end
end