function ret_rec_v=play1_rec(buf,output_ch,rec_ch_num,fs,id_device)
% output buffer, output_channel_position, number of recording channel
% sampling frequency, device id number
% if you don't know device ID,  >> select_play_device
%
 [buf_length, buf_ch]=size(buf);
%
% 出力信号が1ch出なかった場合、1chめだけを出力する
buf2=buf;
if buf_ch ~= 1
    buf2=zeros(buf_length,1);
        buf2(:,1)=buf(:,1);
    disp('Change!')
end
ch_out=[output_ch:output_ch];
ch_in=1:rec_ch_num;
%
%Reset if already initialized
if playrec('isInitialised')  
    playrec('reset');
end
playMaxChannel=max(ch_out);  %Highest channel number for playback
recMaxChannel=max(ch_in);    %Highest channel number for recording
%
playrec('init',fs,id_device,id_device,playMaxChannel,recMaxChannel);
%
%Press rec and play
pageNumber=playrec('playrec',buf2,ch_out,-1,ch_in);
% '-1' means recording same size of output signal
%
playrec('block',pageNumber);
%Get recorded data
[recBuffer,recChanList]=playrec('getRec',pageNumber);
%
%
playrec('delPage',pageNumber);
%Add recorded data block to recData
ret_rec_v=recBuffer;


