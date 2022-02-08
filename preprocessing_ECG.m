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

iterCount = 0;
for file = list_of_files.name
iterCount = iterCount + 1;
    
d = importdata(file); % load data
[b,a] = butter(5,[1 30]/250,'bandpass'); % create a filter 1-30 Hz, 500 Hz sampling rate, 5order
d=filter(b,a,d.data(:,2)); % apply filter
d_RS1 = d(table2array(segments_info(iterCount,4)):table2array(segments_info(iterCount,5)));
d_sharing1 = d(table2array(segments_info(iterCount,6)):table2array(segments_info(iterCount,7)));
d_sharing2 = d(table2array(segments_info(iterCount,11)):table2array(segments_info(iterCount,12)));

Rpeaks(

if char(table2array(segments_info(1, 2))) == 'E'
    

end
end


