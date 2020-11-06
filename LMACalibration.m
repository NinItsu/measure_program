function imp = LMACalibration(imp)
   gain = readbin('LMA_GAIN.float','float');
   for m = 1:48
       imp.s(:,:,m,:,:)=imp.s(:,:,m,:,:)./gain(m);
   end
end