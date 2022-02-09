%% change directory, add path
cd D:\Dropbox\Projects\Emotional_Sharing_Physio
addpath(genpath('D:\Dropbox\Projects\Emotional_Sharing_Physio'))

%%
cd D:\Dropbox\Projects\Emotional_Sharing_Physio\Data\ECG
list_of_files = dir('**/*.txt'); % find all ECG files and create a list
segments_info = readtable('segments_info.xlsx');

%pairs x conditions x role
% conditions order: RS1, Emotional, Neutral
% role order: speaker, listener
Rpeaks = cell(27,3,2);
HR = zeros(27,3,2);

% filter, epoch,, calculate peaks, and combine all data
pairCount = 0;
for file = 1:size(list_of_files,1)
    disp(sprintf('%d',file))
    % create indices for pairs
    if rem(file,2) == 1
        pairCount= pairCount +1;
    end
    
    d = importdata(list_of_files(file).name); % load data
    [b,a] = butter(5,[1 30]/250,'bandpass'); % create a filter 1-30 Hz, 500 Hz sampling rate, 5order
    d=filter(b,a,d.data(:,2)); % apply filter
    % epoch data
    d_RS1 = d(table2array(segments_info(file,4)):table2array(segments_info(file,5)));
    d_sharing1 = d(table2array(segments_info(file,6)):table2array(segments_info(file,7)));
    d_sharing2 = d(table2array(segments_info(file,11)):table2array(segments_info(file,12)));
    
    % find peaks 
    [pks_RS1, locs_RS1] = findpeaks(d_RS1,'MinPeakHeight',max(d_RS1)/2,'MinPeakDistance',125);
    [pks_sharing1, locs_sharing1] = findpeaks(d_sharing1,'MinPeakHeight',max(d_sharing1)/2,'MinPeakDistance',125);
    [pks_sharing2, locs_sharing2] = findpeaks(d_sharing2,'MinPeakHeight',max(d_sharing2)/2,'MinPeakDistance',125);
    
    %calc HR
   
    
    
    % combine all data
    if char(table2array(segments_info(file, 3))) == 'S'
        Rpeaks(pairCount, 1, 1) = {locs_RS1'/500};
        if char(table2array(segments_info(file, 2))) == 'E'
            Rpeaks(pairCount, 2, 1) = {locs_sharing1'/500};
            Rpeaks(pairCount, 3, 1) = {locs_sharing2'/500};
        elseif char(table2array(segments_info(file, 2))) == 'N'
            Rpeaks(pairCount, 2, 1) = {locs_sharing2'/500};
            Rpeaks(pairCount, 3, 1) = {locs_sharing1'/500};
        end
        
    elseif char(table2array(segments_info(file, 3))) == 'L'
        Rpeaks(pairCount, 1, 2) = {locs_RS1'/500};
        if char(table2array(segments_info(file, 2))) == 'E'
            Rpeaks(pairCount, 2, 2) = {locs_sharing1'/500};
            Rpeaks(pairCount, 3, 2) = {locs_sharing2'/500};
        elseif char(table2array(segments_info(file, 2))) == 'N'
            Rpeaks(pairCount, 2, 2) = {locs_sharing2'/500};
            Rpeaks(pairCount, 3, 2) = {locs_sharing1'/500};
        end
        
    end
end

%% manual cleaning of noisy parts

%file 3
d_sharing2 = [d_sharing2(1:51050); d_sharing2(51890:end)];
%file 13
d_sharing2 = [d_sharing2(1:96988); d_sharing2(100900:128700); d_sharing2(129600:end)];
% file 29
d_RS1 = [d_RS1(1:121000); d_RS1(134500:end)];
%file 33
d_sharing2 = d_sharing2(d_sharing2<2 & d_sharing2>-2);
%file 36
d_RS1 = d_RS1(d_RS1<1 & d_RS1>-1.5);
%file 37
d_sharing2 = d_sharing2(d_sharing2<1.8);
%file 45
d_sharing1 = d_sharing1(d_sharing1<1.5 & d_sharing1>-1.5);
d_sharing2 = d_sharing2(d_sharing2<2 & d_sharing2>-2);
% file 51
d_RS1 = d_RS1(d_RS1<2 & d_RS1>-2);
%file 53
d_sharing1 = d_sharing1(d_sharing1<1.5 & d_sharing1>-1.5);
d_sharing2 = d_sharing2(d_sharing2<1 & d_sharing2>-1.5);
%file 38
d_sharing2 = d_sharing2(d_sharing2<1.5 & d_sharing2>-1.5);
% file 43
d_sharing2 = d_sharing2(d_sharing2<1.5 & d_sharing2>-1.5);
%file 49
d_sharing1 = d_sharing1(d_sharing1<1 & d_sharing1>-1);
%file 54
d_sharing1 = d_sharing1(d_sharing1<1 & d_sharing1>-1);
d_sharing2 = d_sharing2(d_sharing2<1 & d_sharing2>-1);
%%
% run synchro script 
ECG_Synchro;

emotional = Coincidence(:,:,2);
emotional = emotional(EyeMat);

neutral = Coincidence(:,:,3);
neutral = neutral(EyeMat);

[h,p,ci,stats] = ttest(emotional, neutral);




