# measure_program    
# 測定中の常用関数
## MeasProg_static.m
測定用プログラム（通常測定）
#### 使用方法：  
すべてのファイルをPath内を入れ，インパルス応答の保存先のフォルダーで関数MeasProgを呼び出す。  
imp=MeasProg()   
設定は手入力（サンプリング周波数，再生/録音のDEVICE_ID，AD/DAモデリングディレイ，スピーカ数，マイクロホン数，測定回数，スピーカのウォーミングアップ，インパルス応答長，測定用信号の種類/振幅/長さ，保存ファイル名） 
測定完了後，測定データはファイルに保存され，さらに変数impに保存される:  
imp.sインパルス応答  
imp.Lインパルス応答長  
imp.raw生録音データ  
imp.fullフルレングスのインパルス応答  
## MeasProg_turntable.m
測定用プログラム（回転台を用いる場合）
#### 使用方法：  
すべてのファイルをPath内を入れ，インパルス応答の保存先のフォルダーで関数MeasProgを呼び出す。  
imp=MeasProg_turntable()   
設定は手入力（サンプリング周波数，再生/録音のDEVICE_ID，AD/DAモデリングディレイ，スピーカ数，マイクロホン数，測定回数，スピーカのウォーミングアップ，回転台の回転角度:起点/終点/間隔，インパルス応答長，測定用信号の種類/振幅/長さ，保存ファイル名） 
測定完了後，測定データはファイルに保存され，さらに変数impに保存される:  
imp.sインパルス応答  
imp.Lインパルス応答長  
imp.raw生録音データ  
imp.fullフルレングスのインパルス応答  
## MeasProg_actuator.m
測定用プログラム（音場測定装置を用いる場合）
#### 使用方法：  
すべてのファイルをPath内を入れ，インパルス応答の保存先のフォルダーで関数MeasProgを呼び出す。  
imp=MeasProg_actuator()   
設定は手入力（サンプリング周波数，再生/録音のDEVICE_ID，AD/DAモデリングディレイ，スピーカ数，マイクロホン数，測定回数，スピーカのウォーミングアップ，x軸の起点/終点/間隔，z軸の起点/終点/間隔，インパルス応答長，測定用信号の種類/振幅/長さ，保存ファイル名） 
測定完了後，測定データはファイルに保存され，さらに変数impに保存される:  
imp.sインパルス応答  
imp.Lインパルス応答長  
imp.raw生録音データ  
imp.fullフルレングスのインパルス応答  
## testLSP.m  
スピーカの音出し確認  
#### 使用方法：  
関数testLSPを呼び出す。  
testLSP('default')  
初期設定で再生（スピーカ1個）  
testLSP('manual')  
手入力設定で再生  
## PreMeas.m  
測定前の振幅・SNR確認  
#### 使用方法：  
関数PreMeasを呼び出す。  
imp=PreMeas('default')  
初期設定で測定（スピーカ1個マイク1個）  
imp=PreMeas('manual')  
手入力設定で測定  
測定完了後，測定データは変数impに保存される:  
imp.sインパルス応答  
imp.Lインパルス応答長  
imp.raw生録音データ  
imp.fullフルレングスのインパルス応答  
スぺクトログラムや周波数特性を確認し，適切なパラメータ（振幅など）で測定を行う  
## readIR.m  
ファイルからインパルス応答を読み込む  
#### 使用方法：  
インパルス応答の保存先のフォルダーで関数readIRを呼び出す。  
imp=readIR()  
インパルス応答は変数impに保存される:  
imp.sインパルス応答  
imp.Lインパルス応答長  
## readBGN.m  
ファイルから暗騒音を読み込む  
#### 使用方法：  
インパルス応答の保存先のフォルダーで関数readBGNを呼び出す。  
noise=readBGN()  
暗騒音は変数noiseに保存される。  
## checkIR.m  
データ確認用プログラム  
#### 使用方法：  
imp.s,imp.L,noiseにデータが入っている状態で各部分のプログラムを実行すれば，波形，周波数特性，スペクトログラム，指向特性などを確認できる。  
## readRAW.m  
ファイルから生データを読み込む  
#### 使用方法：  
インパルス応答の保存先のフォルダーで関数readRAWを呼び出す。  
imp.raw=readRAW()  
生データは変数imp.rawに保存される。  
## RAW2IR.m  
生データからインパルス応答を算出  
#### 使用方法：  
imp.raw,imp.L,sig.L,sig.inv,DLYにデータが入っている状態で関数RAW2IRを呼び出す。  
imp=readRAW(imp,sig,DLY)  
算出したインパルス応答は変数impに保存される:  
imp.sインパルス応答  
imp.fullフルレングスのインパルス応答
# 測定信号生成関数
## meas_sig_gen.m
測定用の信号を生成，対応可能な信号: up-TSP, down-TSP, log-SS  
#### 使用方法：  
sig.TYPE,sig.A,sig.L,FSにデータが入っている状態で関数meas_sig_genを呼び出す。  
[s inv] = meas_sig_gen(sig,FS)
生成した測定用信号と逆信号はそれぞれ変数s,invに保存される:  
## up_TSP.m
up-TSPの生成, 時間波形振幅はsqrt(4/N)
#### 使用方法：  
[s] = up_TSP(N)  
N信号長
## down_TSP.m
down-TSPの生成, 時間波形振幅はsqrt(4/N)
#### 使用方法：  
[s] = down_TSP(N)  
N信号長
## log_SS.m
log-SSの生成
#### 使用方法：  
[s] = log_SS(N)  
N信号長
## ilog_SS.m
逆log-SSの生成
#### 使用方法：  
[s] = ilog_SS(N)  
N信号長
# 音場測定装置のマイクゲイン補正
## LMACalibration.m
音場測定装置の直線マイクロホンアレイとマイクアンプのゲインを補正　　
LMA_GAIN.floatは既定の補正ゲイン
#### 使用方法：  
imp.sにデータが入っている状態で関数RAW2IRを呼び出す。  
imp = LMACalibration(imp)  
補正されたインパルス応答は変数impに保存される:  
imp.sインパルス応答  
# ライブラリ関数
## CONV.m
周波数領域畳み込み関数，高速行列計算に対応可能
## play1.m
指定チャンネルのスピーカから信号を再生
## play1_rec.m
指定チャンネルのスピーカから信号を再生し，同時に録音する
## readbin.m
BINARYファイルの読み込み
## writebin.m
配列をBINARYファイルに出力
# 未使用関数
## BP_log_SS.m
Bandpass Log-SSを生成
## MeasProg.m
測定用関数beta版
## MeasProg_GUI.m
測定用関数GUI版（近いうちに完成する予定）