% main.m
% This script when run should compute all values and make all plots
% required by the project.
% To do so, you must fill the functions in the functions/ folder,
% and create scripts in the scripts/ folder to make the required
% plots.

% Add folders to path
addpath('./functions/','./scripts/');

% Add plot defaults
plotDefaults;
%% read data
%read time
date = xlsread('Problem_Set5.xlsx','Date');

%read returns
r_FFF = xlsread('Problem_Set5.xlsx','FFF');
r_BEME_ext = xlsread('Problem_Set5.xlsx','BEME_extreme');
BEME25.ret = xlsread('Problem_Set5.xlsx','BEME_ret');
BEME25.size = xlsread('Problem_Set5.xlsx','BEME_size');
BEME25.BEME1 = xlsread('Problem_Set5.xlsx','BEME_BEME');
Mom25.ret = xlsread('Problem_Set5.xlsx','p_212_ret');
Mom25.size = xlsread('Problem_Set5.xlsx','p_212_size');
Mom25.pastret = xlsread('Problem_Set5.xlsx','p_212_pastret');
r_Mom_ext = xlsread('Problem_Set5.xlsx','p_212_extreme');

BEME25.BEME = zeros(1085,25);
BEME25.BEME(1:6,:) = nan;
BEME25.BEME(7,:) = BEME25.BEME1(1,:);
count = 1;
for i = 8:1085
    if date(i) ~= date(i-1)
        count = count + 1;
    end
    BEME25.BEME(i,:) = BEME25.BEME1(count,:);
end


Mom25.size(8:end,:) = Mom25.size(7:end-1,:);
Mom25.size(7,:) = nan;

BEME25.size(8:end,:) = BEME25.size(7:end-1,:);
BEME25.size(1:7,:) = nan;
  
%handle missing value
r_FFF(r_FFF <= -99) = nan;
r_BEME_ext(r_BEME_ext <= -99) = nan;
r_Mom_ext(r_Mom_ext <= -99) = nan;
BEME25.ret(BEME25.ret <= -99) = nan;
BEME25.size(BEME25.size <= -99) = nan;
BEME25.BEME(BEME25.BEME <= -99) = nan;
Mom25.ret(Mom25.ret <= -99) = nan;
Mom25.size(Mom25.size <= -99) = nan;
Mom25.pastret(Mom25.pastret <= -99) = nan;

%take the log
BEME25.size = log(BEME25.size);
BEME25.BEME = log(BEME25.BEME);
Mom25.size = log(Mom25.size);

clear count i 

%% Part 1
%part a
mean_FFF = zeros(5,5);
%run the regressions of returns on the the dummy variable
for i = 1:5
    result = fitlm(r_FFF(:,6),r_FFF(:,i));
    mean_FFF(1,i) = result.Coefficients.Estimate(1);
    mean_FFF(2,i) = result.Coefficients.tStat(1);
    mean_FFF(3,i) = result.Coefficients.Estimate(2);
    mean_FFF(4,i) = result.Coefficients.tStat(2);
    mean_FFF(5,i) = result.Coefficients.Estimate(1)+result.Coefficients.Estimate(2);
end

%part b
%run the regressions of returns on the the dummy variable
mean_BEME_ext = zeros(5,4);
r_BEME_ext = r_BEME_ext-r_FFF(:,4);
for i = 1:4
    result = fitlm(r_FFF(:,6),r_BEME_ext(:,i));
    mean_BEME_ext(1,i) = result.Coefficients.Estimate(1);
    mean_BEME_ext(2,i) = result.Coefficients.tStat(1);
    mean_BEME_ext(3,i) = result.Coefficients.Estimate(2);
    mean_BEME_ext(4,i) = result.Coefficients.tStat(2);
    mean_BEME_ext(5,i) = result.Coefficients.Estimate(1)+result.Coefficients.Estimate(2);
end

mean_Mom_ext = zeros(5,4);
r_Mom_ext = r_Mom_ext-r_FFF(:,4);
for i = 1:4
    result = fitlm(r_FFF(:,6),r_Mom_ext(:,i));
    mean_Mom_ext(1,i) = result.Coefficients.Estimate(1);
    mean_Mom_ext(2,i) = result.Coefficients.tStat(1);
    mean_Mom_ext(3,i) = result.Coefficients.Estimate(2);
    mean_Mom_ext(4,i) = result.Coefficients.tStat(2);
    mean_Mom_ext(5,i) = result.Coefficients.Estimate(1)+result.Coefficients.Estimate(2);
end

%% Part 2
%part c
   %part 1
   %obtain the betas by running the time-series regression
   betas_BEME = zeros(4,25);
   intercept = ones(1085,1);
   for i = 1:25
       betas_BEME(:,i) = regress(BEME25.ret(:,i)-r_FFF(:,4),[intercept,r_FFF(:,1:3)]);
   end
   betas_BEME = betas_BEME(2:4,:);
   

   
   %part 2
      %equation 1
      %obtain the gammas by running the cross-section regression
      %remember to transpose the results
      gamma_BEME.r1 = zeros(1085,4);
      intercept = ones(25,1);
      for i = 1:1085
          gamma_BEME.r1(i,:) = (regress((BEME25.ret(i,:)-r_FFF(i,4))',[intercept,betas_BEME(1,:)',BEME25.size(i,:)',BEME25.BEME(i,:)']))';
      end
      gamma_BEME.r1(gamma_BEME.r1 == 0) = nan;
      
      %equation 2
      gamma_BEME.r2 = zeros(1085,4);
      intercept = ones(25,1);
      for i = 1:1085
          gamma_BEME.r2(i,:) = (regress((BEME25.ret(i,:)-r_FFF(i,4))',[intercept,betas_BEME']))';
      end
      gamma_BEME.r2(gamma_BEME.r2 == 0) = nan;
      
      %equation 3
      gamma_BEME.r3 = zeros(1085,6);
      intercept = ones(25,1);
      for i = 1:1085
          gamma_BEME.r3(i,:) = (regress((BEME25.ret(i,:)-r_FFF(i,4))',[intercept,betas_BEME(1,:)',BEME25.size(i,:)',BEME25.BEME(i,:)',betas_BEME(2:3,:)']))';
      end
      gamma_BEME.r3(gamma_BEME.r3 == 0) = nan;
      
   %part 3
   gamma_BEME.avg1 = zeros(3,4);
   gamma_BEME.avg2 = zeros(3,4);
   gamma_BEME.avg3 = zeros(3,6);
   %mean
   gamma_BEME.avg1(1,:) = nanmean(gamma_BEME.r1);
   gamma_BEME.avg2(1,:) = nanmean(gamma_BEME.r2);
   gamma_BEME.avg3(1,:) = nanmean(gamma_BEME.r3);
   %standard deviation
   gamma_BEME.avg1(2,:) = nanstd(gamma_BEME.r1)/sqrt(1077);
   gamma_BEME.avg2(2,:) = nanstd(gamma_BEME.r2)/sqrt(1085);
   gamma_BEME.avg3(2,:) = nanstd(gamma_BEME.r3)/sqrt(1077);
   %t-stat
   gamma_BEME.avg1(3,:) = gamma_BEME.avg1(1,:)./gamma_BEME.avg1(2,:);
   gamma_BEME.avg2(3,:) = gamma_BEME.avg2(1,:)./gamma_BEME.avg2(2,:);
   gamma_BEME.avg3(3,:) = gamma_BEME.avg3(1,:)./gamma_BEME.avg3(2,:);
   
   
%part d

%part e
%locate the index of Jan 1963
index = find(date(:,1) == 1963 & date(:,2) == 1);

   %part 1
   %obtain the betas by running the time-series regression
   betas_BEME_e = zeros(4,25);
   intercept = ones(1085-index+1,1);
   for i = 1:25
       betas_BEME_e(:,i) = regress(BEME25.ret(index:end,i)-r_FFF(index:end,4),[intercept,r_FFF(index:end,1:3)]);
   end
   betas_BEME_e = betas_BEME_e(2:4,:);
   
   %part 2
      %equation 1
      %obtain the gammas by running the cross-section regression
      %remember to transpose the results
      gamma_BEME_e.r1 = zeros(1085-index+1,4);
      intercept = ones(25,1);
      for i = 1:1085-index+1
          gamma_BEME_e.r1(i,:) = (regress((BEME25.ret(index-1+i,:)-r_FFF(index-1+i,4))',[intercept,betas_BEME_e(1,:)',BEME25.size(index-1+i,:)',BEME25.BEME(index-1+i,:)']))';
      end
      
      %equation 2
      gamma_BEME_e.r2 = zeros(1085-index+1,4);
      intercept = ones(25,1);
      for i = 1:1085-index+1
          gamma_BEME_e.r2(i,:) = (regress((BEME25.ret(index-1+i,:)-r_FFF(index-1+i,4))',[intercept,betas_BEME_e']))';
      end
      
      %equation 3
      gamma_BEME_e.r3 = zeros(1085-index+1,6);
      intercept = ones(25,1);
      for i = 1:1085-index+1
          gamma_BEME_e.r3(i,:) = (regress((BEME25.ret(index-1+i,:)-r_FFF(index-1+i,4))',[intercept,betas_BEME_e(1,:)',BEME25.size(index-1+i,:)',BEME25.BEME(index-1+i,:)',betas_BEME_e(2:3,:)']))';
      end
      
   %part 3
   gamma_BEME_e.avg1 = zeros(3,4);
   gamma_BEME_e.avg2 = zeros(3,4);
   gamma_BEME_e.avg3 = zeros(3,6);
   %mean
   gamma_BEME_e.avg1(1,:) = nanmean(gamma_BEME_e.r1);
   gamma_BEME_e.avg2(1,:) = nanmean(gamma_BEME_e.r2);
   gamma_BEME_e.avg3(1,:) = nanmean(gamma_BEME_e.r3);
   %standard deviation
   gamma_BEME_e.avg1(2,:) = nanstd(gamma_BEME_e.r1)/sqrt(647);
   gamma_BEME_e.avg2(2,:) = nanstd(gamma_BEME_e.r2)/sqrt(647);
   gamma_BEME_e.avg3(2,:) = nanstd(gamma_BEME_e.r3)/sqrt(647);
   %t-stat
   gamma_BEME_e.avg1(3,:) = gamma_BEME_e.avg1(1,:)./gamma_BEME_e.avg1(2,:);
   gamma_BEME_e.avg2(3,:) = gamma_BEME_e.avg2(1,:)./gamma_BEME_e.avg2(2,:);
   gamma_BEME_e.avg3(3,:) = gamma_BEME_e.avg3(1,:)./gamma_BEME_e.avg3(2,:);

%% Part 3
%part f
   %part 1
   %obtain the betas by running the time-series regression
   betas_Mom = zeros(4,25);
   intercept = ones(1085,1);
   for i = 1:25
       betas_Mom(:,i) = regress(Mom25.ret(:,i)-r_FFF(:,4),[intercept,r_FFF(:,1:2),r_FFF(:,5)]);
   end
   betas_Mom = betas_Mom(2:4,:);
   
   %part 2
      %equation 1
      %obtain the gammas by running the cross-section regression
      %remember to transpose the results
      gamma_Mom.r1 = zeros(1085,4);
      intercept = ones(25,1);
      for i = 1:1085
          gamma_Mom.r1(i,:) = (regress((Mom25.ret(i,:)-r_FFF(i,4))',[intercept,betas_Mom(1,:)',Mom25.size(i,:)',Mom25.pastret(i,:)']))';
      end
  
      %equation 2
      gamma_Mom.r2 = zeros(1085,4);
      intercept = ones(25,1);
      for i = 1:1085
          gamma_Mom.r2(i,:) = (regress((Mom25.ret(i,:)-r_FFF(i,4))',[intercept,betas_Mom']))';
      end
      
      %equation 3
      gamma_Mom.r3 = zeros(1085,6);
      intercept = ones(25,1);
      for i = 1:1085
          gamma_Mom.r3(i,:) = (regress((Mom25.ret(i,:)-r_FFF(i,4))',[intercept,betas_Mom(1,:)',Mom25.size(i,:)',Mom25.pastret(i,:)',betas_Mom(2:3,:)']))';
      end
      
      %replace gamma = 0 with gamma = nan
      gamma_Mom.r1(gamma_Mom.r1 == 0) = nan;
      gamma_Mom.r2(gamma_Mom.r2 == 0) = nan;
      gamma_Mom.r3(gamma_Mom.r3 == 0) = nan;
   
   %part 3
   gamma_Mom.avg1 = zeros(3,4);
   gamma_Mom.avg2 = zeros(3,4);
   gamma_Mom.avg3 = zeros(3,6);
   %mean
   gamma_Mom.avg1(1,:) = nanmean(gamma_Mom.r1);
   gamma_Mom.avg2(1,:) = nanmean(gamma_Mom.r2);
   gamma_Mom.avg3(1,:) = nanmean(gamma_Mom.r3);
   %standard deviation
   gamma_Mom.avg1(2,:) = nanstd(gamma_Mom.r1)/sqrt(1078);
   gamma_Mom.avg2(2,:) = nanstd(gamma_Mom.r2)/sqrt(1079);
   gamma_Mom.avg3(2,:) = nanstd(gamma_Mom.r3)/sqrt(1078);
   %t-stat
   gamma_Mom.avg1(3,:) = gamma_Mom.avg1(1,:)./gamma_Mom.avg1(2,:);
   gamma_Mom.avg2(3,:) = gamma_Mom.avg2(1,:)./gamma_Mom.avg2(2,:);
   gamma_Mom.avg3(3,:) = gamma_Mom.avg3(1,:)./gamma_Mom.avg3(2,:);
   
   
%part g

%part h
%locate the index of Jan 1963
index = find(date(:,1) == 1963 & date(:,2) == 1);

   %part 1
   %obtain the betas by running the time-series regression
   betas_Mom_h = zeros(4,25);
   intercept = ones(1085-index+1,1);
   for i = 1:25
       betas_Mom_h(:,i) = regress(Mom25.ret(index:end,i)-r_FFF(index:end,4),[intercept,r_FFF(index:end,1:2),r_FFF(index:end,5)]);
   end
   betas_Mom_h = betas_Mom_h(2:4,:);
   
   %part 2
      %equation 1
      %obtain the gammas by running the cross-section regression
      %remember to transpose the results
      gamma_Mom_h.r1 = zeros(1085-index+1,4);
      intercept = ones(25,1);
      for i = 1:1085-index+1
          gamma_Mom_h.r1(i,:) = (regress((Mom25.ret(index-1+i,:)-r_FFF(index-1+i,4))',[intercept,betas_Mom_h(1,:)',Mom25.size(index-1+i,:)',Mom25.pastret(index-1+i,:)']))';
      end
      
      %equation 2
      gamma_Mom_h.r2 = zeros(1085-index+1,4);
      intercept = ones(25,1);
      for i = 1:1085-index+1
          gamma_Mom_h.r2(i,:) = (regress((Mom25.ret(index-1+i,:)-r_FFF(index-1+i,4))',[intercept,betas_Mom_h']))';
      end
      
      %equation 3
      gamma_Mom_h.r3 = zeros(1085-index+1,6);
      intercept = ones(25,1);
      for i = 1:1085-index+1
          gamma_Mom_h.r3(i,:) = (regress((Mom25.ret(index-1+i,:)-r_FFF(index-1+i,4))',[intercept,betas_Mom_h(1,:)',Mom25.size(index-1+i,:)',Mom25.pastret(index-1+i,:)',betas_Mom_h(2:3,:)']))';
      end
      
      %replace gamma = 0 with gamma = nan
      gamma_Mom_h.r1(gamma_Mom_h.r1 == 0) = nan;
      gamma_Mom_h.r2(gamma_Mom_h.r2 == 0) = nan;
      gamma_Mom_h.r3(gamma_Mom_h.r3 == 0) = nan;
       
   
   %part 3
   gamma_Mom_h.avg1 = zeros(3,4);
   gamma_Mom_h.avg2 = zeros(3,4);
   gamma_Mom_h.avg3 = zeros(3,6);
   %mean
   gamma_Mom_h.avg1(1,:) = nanmean(gamma_Mom_h.r1);
   gamma_Mom_h.avg2(1,:) = nanmean(gamma_Mom_h.r2);
   gamma_Mom_h.avg3(1,:) = nanmean(gamma_Mom_h.r3);
   %standard deviation
   gamma_Mom_h.avg1(2,:) = nanstd(gamma_Mom_h.r1)/sqrt(647);
   gamma_Mom_h.avg2(2,:) = nanstd(gamma_Mom_h.r2)/sqrt(647);
   gamma_Mom_h.avg3(2,:) = nanstd(gamma_Mom_h.r3)/sqrt(647);
   %t-stat
   gamma_Mom_h.avg1(3,:) = gamma_Mom_h.avg1(1,:)./gamma_Mom_h.avg1(2,:);
   gamma_Mom_h.avg2(3,:) = gamma_Mom_h.avg2(1,:)./gamma_Mom_h.avg2(2,:);
   gamma_Mom_h.avg3(3,:) = gamma_Mom_h.avg3(1,:)./gamma_Mom_h.avg3(2,:);



