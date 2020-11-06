# measure_program    
## MeasProg.m
測定用プログラム
#### 使用方法：  
すべてのファイルをPath内を入れ，インパルス応答の保存先のフォルダーで関数MeasProgを呼び出す。  
imp=MeasProg('default')  
初期設定で測定（スピーカ1個マイク1個）  
imp=MeasProg('manual')   
手入力設定で測定  
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
スぺクトログラムや周波数特性を確認し，適切なパラメータ（振幅など）を設定してください。  
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
