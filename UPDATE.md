# アップデート履歴
#### Nov. 16, 2020
##### 任
非線形歪みの計算を追加  
SNR, SDRの確認（ノイズは暗騒音に測定信号を畳み込んで計算）  
PreMeas.m:  
LogSS信号を使った場合：　2,3,4次高調波歪みの表示  
  
測定所要時間/容量の予測を追加  
MeasProg_actuator.m / MeasProg_static.m
測定時間推定  
ACT_MOVE時間+ ACT_RETURN時間+playrec時間+CONV時間  
（予測精度: ±5 min程度）  
ファイル容量推定  
所要メモリ推定