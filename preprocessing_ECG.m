%% change directory, add path
cd D:\Dropbox\Projects\Emotional_Sharing_Physio
addpath(genpath('D:\Dropbox\Projects\Emotional_Sharing_Physio'))

%%
cd D:\Dropbox\Projects\Emotional_Sharing_Physio\Data\ECG 
list_of_files = dir('**/*.txt'); % find all ECG files and create a list
segments_info = readtable('segments_info.xlsx');



d = importdata('SNS_005_11061518_ECG.txt'); % load data
[b,a] = butter(5,[1 30]/250,'bandpass'); % create a filter 1-30 Hz, 500 Hz sampling rate, 5order
d=filter(b,a,d.data(:,2));


