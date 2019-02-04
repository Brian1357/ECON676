function timeseries = timeConv(list)
%timeConv: convert a string of time series to a datetime array
%list: YYYYMM list

yr = floor(list/100);
mon = list - yr*100;
timeseries = datetime(yr,mon,ones(length(list),1));
end