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
Rpeaks = zeros(28,3,2);

% filter, epoch,, calculate peaks, and combine all data
pairCount = 0;
for file = 1:size(list_of_files,1)
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
    
    if char(table2array(segments_info(1, 3))) == 'S'
        Rpeaks(pairCount, 1, 1) = locs_RS1;
        if char(table2array(segments_info(1, 2))) == 'E'
            Rpeaks(pairCount, 2, 1) = locs_sharing1;
            Rpeaks(pairCount, 3, 1) = locs_sharing2;
        elseif char(table2array(segments_info(1, 2))) == 'N'
            Rpeaks(pairCount, 2, 1) = locs_sharing2;
            Rpeaks(pairCount, 3, 1) = locs_sharing1;
        end
        
    elseif char(table2array(segments_info(1, 3))) == 'S'
        Rpeaks(pairCount, 1, 2) = locs_RS1;
        if char(table2array(segments_info(1, 2))) == 'E'
            Rpeaks(pairCount, 2, 2) = locs_sharing1;
            Rpeaks(pairCount, 3, 2) = locs_sharing2;
        elseif char(table2array(segments_info(1, 2))) == 'N'
            Rpeaks(pairCount, 2, 2) = locs_sharing2;
            Rpeaks(pairCount, 3, 2) = locs_sharing1;
        end
        
    end
end


