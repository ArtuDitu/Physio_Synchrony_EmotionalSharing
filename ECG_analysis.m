%% change directory, add path\
clear all
clc
cd D:\Dropbox\Projects\Emotional_Sharing_Physio
addpath(genpath('D:\Dropbox\Projects\Emotional_Sharing_Physio'))

%%
cd D:\Dropbox\Projects\Emotional_Sharing_Physio\Data\ECG
list_of_files = dir('**/*.txt'); % find all ECG files and create a list
segments_info = readtable('segments_info.xlsx');

%pairs x conditions x role
% conditions order: RS1, Emotional, Neutral, RS2, RS3
% role order: speaker, listener
Rpeaks = cell(27,5,2);
HR = zeros(27,5,2);

RS1_size = [];
RS2_size = [];
RS3_size = [];
emotional_size = [];
neutral_size = [];

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
    d_RS2 = d(table2array(segments_info(file,8)):table2array(segments_info(file,9)));
    d_RS3 = d(table2array(segments_info(file,12)):table2array(segments_info(file,13)));
    d_sharing1 = d(table2array(segments_info(file,6)):table2array(segments_info(file,7)));
    d_sharing2 = d(table2array(segments_info(file,10)):table2array(segments_info(file,11)));
    
% remove noisy parts of data
    if file == 3
        d_sharing2 = d_sharing2(d_sharing2<2 & d_sharing2>-2);
        d_RS3 = d_RS3(d_RS3<2 & d_RS3>-2);
    elseif file == 13
        d_sharing2 = d_sharing2(d_sharing2<1 & d_sharing2>-1);
        d_RS2 = d_RS2(d_RS2<1 & d_RS2>-1);
    elseif file == 29
        d_RS1 = d_RS1(d_RS1<2.2 & d_RS1>-2.2);
    elseif file == 33
        d_sharing2 = d_sharing2(d_sharing2<2 & d_sharing2>-2);
        d_RS3 = d_RS3(d_RS3<2 & d_RS3>-2);
    elseif file ==36
        d_RS1 = d_RS1(d_RS1<1 & d_RS1>-1.5);
    elseif file == 37
        d_sharing2 = d_sharing2(d_sharing2<1.8);
    elseif file == 40
        d_sharing2 = d_sharing2(d_sharing2<1.4 & d_sharing2>-1.4);
        d_RS3 = d_RS3(d_RS3<1.5 & d_RS3>-1.5);
    elseif file == 45
        d_sharing1 = d_sharing1(d_sharing1<1.5 & d_sharing1>-1.5);
        d_sharing2 = d_sharing2(d_sharing2<1.5 & d_sharing2>-1.5);
        d_RS3 = d_RS3(d_RS3<1.5 & d_RS3>-1.5);
    elseif file == 51
        d_RS1 = d_RS1(d_RS1<2 & d_RS1>-2);
        d_sharing2 = d_sharing2(d_sharing2<2 & d_sharing2>-2);
     elseif file == 53
             d_sharing1 = d_sharing1(d_sharing1<1.5 & d_sharing1>-1.5);
             d_sharing2 = d_sharing2(d_sharing2<1 & d_sharing2>-1.5);
    elseif file ==7
        d_RS3 = d_RS3(d_RS3<1 & d_RS3>-1.3);
    elseif file == 38
        d_sharing2 = d_sharing2(d_sharing2<1.5 & d_sharing2>-1.5);
    elseif file == 43
        d_sharing2 = d_sharing2(d_sharing2<1.5 & d_sharing2>-1.5);
         d_RS2 = d_RS2(d_RS2<1.5 & d_RS2>-1.5);
    elseif file == 49
        d_sharing1 = d_sharing1(d_sharing1<1 & d_sharing1>-1);
    elseif file == 54
        d_sharing1 = d_sharing1(d_sharing1<1 & d_sharing1>-1);
       d_sharing2 = d_sharing2(d_sharing2<1 & d_sharing2>-1);
    end

    % find peaks
    [pks_RS1, locs_RS1] = findpeaks(d_RS1,'MinPeakHeight',max(d_RS1)/2,'MinPeakDistance',125);
    [pks_RS2, locs_RS2] = findpeaks(d_RS2,'MinPeakHeight',max(d_RS2)/2,'MinPeakDistance',125);
    [pks_RS3, locs_RS3] = findpeaks(d_RS3,'MinPeakHeight',max(d_RS3)/2,'MinPeakDistance',125);
    [pks_sharing1, locs_sharing1] = findpeaks(d_sharing1,'MinPeakHeight',max(d_sharing1)/2,'MinPeakDistance',125);
    [pks_sharing2, locs_sharing2] = findpeaks(d_sharing2,'MinPeakHeight',max(d_sharing2)/2,'MinPeakDistance',125);
    
    %calc HR
    HR_RS1 = size(locs_RS1,1)/(size(d_RS1,1)/30000);
    HR_RS2 = size(locs_RS2,1)/(size(d_RS2,1)/30000);
    HR_RS3 = size(locs_RS3,1)/(size(d_RS3,1)/30000);
    HR_sharing1 = size(locs_sharing1,1)/(size( d_sharing1,1)/30000);
    HR_sharing2 = size(locs_sharing2,1)/(size( d_sharing2,1)/30000);
    
    % combine all data
    if char(table2array(segments_info(file, 3))) == 'S'
        RS1_size = [RS1_size size(d_RS1,1)];
        RS2_size = [RS2_size size(d_RS2,1)];
        RS3_size = [RS3_size size(d_RS3,1)];
        Rpeaks(pairCount, 1, 1) = {locs_RS1'/(size(d_RS1,1)/300)};
        Rpeaks(pairCount, 4, 1) = {locs_RS2'/(size(d_RS2,1)/300)};
        Rpeaks(pairCount, 5, 1) = {locs_RS3'/(size(d_RS3,1)/300)};
        HR(pairCount,1,1) = size(locs_RS1,1)/(size(d_RS1,1)/30000);
        HR(pairCount,4,1) = size(locs_RS2,1)/(size(d_RS2,1)/30000);
        HR(pairCount,5,1) = size(locs_RS3,1)/(size(d_RS3,1)/30000);
        if char(table2array(segments_info(file, 2))) == 'E'
            emotional_size = [emotional_size size(d_sharing1,1)];
            neutral_size =[neutral_size size(d_sharing2,1)];
            Rpeaks(pairCount, 2, 1) = {locs_sharing1'/(size(d_sharing1,1)/300)};
            Rpeaks(pairCount, 3, 1) = {locs_sharing2'/(size(d_sharing2,1)/300)};
            HR(pairCount,2,1) = size(locs_sharing1,1)/(size(d_sharing1,1)/30000);
            HR(pairCount,3,1) = size(locs_sharing2,1)/(size(d_sharing2,1)/30000);
        elseif char(table2array(segments_info(file, 2))) == 'N'
            emotional_size = [emotional_size size(d_sharing2,1)];
            neutral_size =[neutral_size size(d_sharing1,1)];
            Rpeaks(pairCount, 2, 1) = {locs_sharing2'/(size(d_sharing1,1)/300)};
            Rpeaks(pairCount, 3, 1) = {locs_sharing1'/(size(d_sharing2,1)/300)};
            HR(pairCount,2,1) = size(locs_sharing2,1)/(size(d_sharing2,1)/30000);
            HR(pairCount,3,1) = size(locs_sharing1,1)/(size(d_sharing1,1)/30000);
        end
        
    elseif char(table2array(segments_info(file, 3))) == 'L'
        RS1_size = [RS1_size size(d_RS1,1)];
        RS2_size = [RS2_size size(d_RS2,1)];
        RS3_size = [RS3_size size(d_RS3,1)];
        Rpeaks(pairCount, 1, 2) = {locs_RS1'/(size(d_RS1,1)/300)};
        Rpeaks(pairCount, 4, 2) = {locs_RS2'/(size(d_RS2,1)/300)};
        Rpeaks(pairCount, 5, 2) = {locs_RS3'/(size(d_RS3,1)/300)};
        HR(pairCount,1,2) = size(locs_RS1,1)/(size(d_RS1,1)/30000);
        HR(pairCount,4,2) = size(locs_RS2,1)/(size(d_RS2,1)/30000);
        HR(pairCount,5,2) = size(locs_RS3,1)/(size(d_RS3,1)/30000);
        if char(table2array(segments_info(file, 2))) == 'E'
            emotional_size = [emotional_size size(d_sharing1,1)];
            neutral_size =[neutral_size size(d_sharing2,1)];
            Rpeaks(pairCount, 2, 2) = {locs_sharing1'/(size(d_sharing1,1)/300)};
            Rpeaks(pairCount, 3, 2) = {locs_sharing2'/(size(d_sharing2,1)/300)};
            HR(pairCount,2,2) = size(locs_sharing1,1)/(size(d_sharing1,1)/30000);
            HR(pairCount,3,2) = size(locs_sharing2,1)/(size(d_sharing2,1)/30000);
        elseif char(table2array(segments_info(file, 2))) == 'N'
            emotional_size = [emotional_size size(d_sharing2,1)];
            neutral_size =[neutral_size size(d_sharing1,1)];
            Rpeaks(pairCount, 2, 2) = {locs_sharing2'/(size(d_sharing2,1)/300)};
            Rpeaks(pairCount, 3, 2) = {locs_sharing1'/(size(d_sharing1,1)/300)};
            HR(pairCount,2,2) = size(locs_sharing1,1)/(size(d_sharing2,1)/30000);
            HR(pairCount,3,2) = size(locs_sharing2,1)/(size(d_sharing1,1)/30000);
        end
        
    end
end

%%
% run synchro script
ECG_Synchro;

emotional = Coincidence(:,:,2);
emotional = emotional(EyeMat);

neutral = Coincidence(:,:,3);
neutral = neutral(EyeMat);

[h,p,ci,stats] = ttest(emotional, neutral);



