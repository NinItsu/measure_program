function retv=play1(buf,ch_num,fs,id_device)
%
% plays(sound_buffer,number_of_channel,sampling freq, device_id)
%
playDevice=id_device;
[buf_length, buf_ch]=size(buf);
% 出力信号が1ch出なかった場合、1chめだけを出力する
buf2=buf;
if buf_ch ~= 1
    buf2=zeros(buf_length,1);
        buf2(:,1)=buf(:,1);
    disp('Change!')
end
ch_out=[ch_num:ch_num];
%
%Reset if already initialized
if playrec('isInitialised')  
    playrec('reset');
end
playMaxChannel=max(ch_out);  %Highest channel number for playback
recMaxChannel=playMaxChannel;    %Highest channel number for recording
recDevice=playDevice;
%
playrec('init',fs,playDevice,recDevice,playMaxChannel,recMaxChannel);
%
%Press rec and play
pageNumber=playrec('play',buf2,ch_out);
% '-1' means recording same size of output signal
%
while(playrec('isFinished', pageNumber) == 0)
end
% playrec('block',pageNumber)と同じだが、レスポンスの速さが違う
%
playrec('delPage',pageNumber);
%Add recorded data block to recData
retv=ch_out;
end


