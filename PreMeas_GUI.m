function varargout = PreMeas_GUI(varargin)
% PREMEAS_GUI MATLAB code for PreMeas_GUI.fig
%      PREMEAS_GUI, by itself, creates a new PREMEAS_GUI or raises the existing
%      singleton*.
%
%      H = PREMEAS_GUI returns the handle to a new PREMEAS_GUI or the handle to
%      the existing singleton*.
%
%      PREMEAS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREMEAS_GUI.M with the given input arguments.
%
%      PREMEAS_GUI('Property','Value',...) creates a new PREMEAS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PreMeas_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PreMeas_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PreMeas_GUI

% Last Modified by GUIDE v2.5 27-Dec-2021 19:40:53
global version;
version = { 'Pre-Measure Program';...
            'v 1.0';...
            '©2021 Hanelab. All rights reserved.'};
% Last edition by Y. Ren v 1.0 2021/12/27
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PreMeas_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @PreMeas_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before PreMeas_GUI is made visible.
function PreMeas_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PreMeas_GUI (see VARARGIN)

% Choose default command line output for PreMeas_GUI
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
movegui(gcf,'center');

% UIWAIT makes PreMeas_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = PreMeas_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function FS_Callback(hObject, eventdata, handles)
% hObject    handle to FS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FS as text
%        str2double(get(hObject,'String')) returns contents of FS as a double

    FS_STR=get(hObject,'String');
    set(hObject,'UserData',FS_STR);
    

% --- Executes during object creation, after setting all properties.
function FS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function DEVICE_ID_Callback(hObject, eventdata, handles)
    
    ID_STR=get(hObject,'String');
    set(hObject,'UserData',ID_STR);
% hObject    handle to DEVICE_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DEVICE_ID as text
%        str2double(get(hObject,'String')) returns contents of DEVICE_ID as a double


% --- Executes during object creation, after setting all properties.
function DEVICE_ID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DEVICE_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DLY_Callback(hObject, eventdata, handles)

    DLY_STR=get(hObject,'String');
    set(hObject,'UserData',DLY_STR);
% hObject    handle to DLY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DLY as text
%        str2double(get(hObject,'String')) returns contents of DLY as a double


% --- Executes during object creation, after setting all properties.
function DLY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DLY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NO_LSP_Callback(hObject, eventdata, handles)

    LSP_STR=get(hObject,'String');
    set(hObject,'UserData',LSP_STR);
% hObject    handle to NO_LSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NO_LSP as text
%        str2double(get(hObject,'String')) returns contents of NO_LSP as a double


% --- Executes during object creation, after setting all properties.
function NO_LSP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NO_LSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NO_MIC_Callback(hObject, eventdata, handles)

    MC_STR=get(hObject,'String');
    set(hObject,'UserData',MC_STR);
% hObject    handle to NO_MIC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NO_MIC as text
%        str2double(get(hObject,'String')) returns contents of NO_MIC as a double


% --- Executes during object creation, after setting all properties.
function NO_MIC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NO_MIC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function SigA_Callback(hObject, eventdata, handles)

    SA_STR=get(hObject,'String');
    set(hObject,'UserData',SA_STR);
% hObject    handle to SigA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SigA as text
%        str2double(get(hObject,'String')) returns contents of SigA as a double


% --- Executes during object creation, after setting all properties.
function SigA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SigA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Sigt_Callback(hObject, eventdata, handles)

    ST_STR=get(hObject,'String');
    set(hObject,'UserData',ST_STR);
% hObject    handle to Sigt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Sigt as text
%        str2double(get(hObject,'String')) returns contents of Sigt as a double


% --- Executes during object creation, after setting all properties.
function Sigt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sigt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in SigTYPE.
function SigType_Callback(hObject, eventdata, handles)

    
% hObject    handle to SigTYPE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SigTYPE contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SigTYPE
    items=get(hObject,'String');
    index_selected=get(hObject,'Value');
    item_selected=items{index_selected};
    set(hObject,'UserData',item_selected);
    if strcmp(item_selected,'BPLogSS')
        set(handles.text21,'Visible','on');
        set(handles.text23,'Visible','on');
        set(handles.fmin,'Visible','on');
        set(handles.fmax,'Visible','on');
    else
        set(handles.text21,'Visible','off');
        set(handles.text23,'Visible','off');
        set(handles.fmin,'Visible','off');
        set(handles.fmax,'Visible','off');
    end

% --- Executes during object creation, after setting all properties.
function SigType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SigTYPE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function impL_Callback(hObject, eventdata, handles)

    IRL_STR=get(hObject,'String');
    set(hObject,'UserData',IRL_STR);
% hObject    handle to impL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of impL as text
%        str2double(get(hObject,'String')) returns contents of impL as a double


% --- Executes during object creation, after setting all properties.
function impL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to impL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fmin_Callback(hObject, eventdata, handles)
% hObject    handle to fmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fmin as text
%        str2double(get(hObject,'String')) returns contents of fmin as a double
    FMIN=get(hObject,'String');
    set(hObject,'UserData',FMIN);


% --- Executes during object creation, after setting all properties.
function fmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fmax_Callback(hObject, eventdata, handles)
% hObject    handle to fmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fmax as text
%        str2double(get(hObject,'String')) returns contents of fmax as a double
    FMAX=get(hObject,'String');
    set(hObject,'UserData',FMAX);

% --- Executes during object creation, after setting all properties.
function fmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    
% --- Executes on button press in START.
function START_Callback(hObject, eventdata, handles)
% hObject    handle to START (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


params=TEST_Callback(hObject, eventdata, handles);
if isstruct(params)
%%%%%引数を測定用の関数に渡す
 [imp] = PreMeas(params);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% --- Executes on button press in TEST.
function params=TEST_Callback(hObject, eventdata, handles)
% hObject    handle to TEST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%サンプリング周波数ｰ
FS_STR=get(handles.FS,'String');
% % FS_STR=get(FS,'String');
FS=str2double(FS_STR);

error=0;

if FS<=0 || FS/round(FS)~=1 %%正の整数でないとエラー
     error=1;
     set(handles.FS,'ForegroundColor','red');
else
     set(handles.FS,'ForegroundColor','black');
     params.FS=FS;
end

%%%%%

%%%%%デバイスID
ID_STR=get(handles.DEVICE_ID,'String');
% % FS_STR=get(FS,'String');
DEVICE_ID=str2double(ID_STR);

if DEVICE_ID<=0 || DEVICE_ID/round(DEVICE_ID)~=1 %%正の整数でないとエラー
     error=1;
     set(handles.DEVICE_ID,'ForegroundColor','red');
else
     set(handles.DEVICE_ID,'ForegroundColor','black');
     params.DEVICE_ID=DEVICE_ID;
end

%%%%%

%%%%%ディレイ
DLY_STR=get(handles.DLY,'String');
DLY=str2double(DLY_STR);

if DLY<0 || DLY/round(DLY)~=1  %%正の整数でないとエラー
     error=1;
     set(handles.DLY,'ForegroundColor','red');
else
     set(handles.DLY,'ForegroundColor','black');
     params.DLY=DLY;
end

%%%%%

%%%%%スピーカ数
SP_STR=get(handles.NO_LSP,'String');
% % FS_STR=get(FS,'String');
NO_LSP=str2double(SP_STR);

if NO_LSP<=0 || NO_LSP/round(NO_LSP)~=1 %%正の整数でないとエラー
     error=1;
     set(handles.NO_LSP,'ForegroundColor','red');
else
     set(handles.NO_LSP,'ForegroundColor','black');
     params.NO_LSP=NO_LSP;
end
%%%%%

%%%%%マイク数
MN_STR=get(handles.NO_MIC,'String');
% % FS_STR=get(FS,'String');
NO_MIC=str2double(MN_STR);

if NO_MIC<=0 || NO_MIC/round(NO_MIC)~=1  %%正の整数でないとエラー
      error=1;
      set(handles.NO_MIC,'ForegroundColor','red');
else
      set(handles.NO_MIC,'ForegroundColor','black');
      params.NO_MIC=NO_MIC;
end
%%%%%

%%%%%インパルス応答長
IR_STR=get(handles.impL,'String');
% % FS_STR=get(FS,'String');
imp.L=str2double(IR_STR);

if imp.L<=0 || imp.L/round(imp.L)~=1 %%正の整数でないとエラー
      error=1;
      set(handles.impL,'ForegroundColor','red');
else
      set(handles.impL,'ForegroundColor','black');
      params.imp.L=imp.L;
end

%%%%%

%%%%%再生信号の種類

value=get(handles.SigType,'Value');
type_name=get(handles.SigType,'String');
sig.TYPE=char(type_name(value));
params.sig.TYPE=sig.TYPE;
params.sig.TYPEidx=value;

if strcmp(type_name(value),'BPLogSS')
    FMIN_STR=get(handles.fmin,'String');
    sig.fmin=str2double(FMIN_STR);
    FMAX_STR=get(handles.fmax,'String');
    sig.fmax=str2double(FMAX_STR);
    params.sig.fmin=sig.fmin;
    params.sig.fmax=sig.fmax;
    if sig.fmin<0 || sig.fmin>FS/2 || isnan(sig.fmin) %%負の数だとエラー
      error=1;
      set(handles.fmin,'ForegroundColor','red');
    else
      set(handles.fmin,'ForegroundColor','black');
    end
    if sig.fmax<0 || sig.fmax>FS/2 || isnan(sig.fmax) %%負の数だとエラー
      error=1;
      set(handles.fmax,'ForegroundColor','red');
    else
      set(handles.fmax,'ForegroundColor','black');
    end
    if sig.fmax<sig.fmin %%最大周波数が最小周波数より小さいだとエラー
      error=1;
      set(handles.fmin,'ForegroundColor','red');
      set(handles.fmax,'ForegroundColor','red');
    end
end
%%%%%

%%%%%振幅

AMP_STR=get(handles.SigA,'String');
sig.A=str2double(AMP_STR);

if sig.A<=0 || isnan(sig.A) %%負の数だとエラー
      error=1;
      set(handles.SigA,'ForegroundColor','red');
else
      set(handles.SigA,'ForegroundColor','black');
      params.sig.A=sig.A;
end

%%%%%

%%%%%信号の時間

TIME_STR=get(handles.Sigt,'String');
sig.t=str2double(TIME_STR);

if sig.t<=0 || isnan(sig.t) %%負の数だとエラー
      error=1;
      set(handles.Sigt,'ForegroundColor','red');
else
      set(handles.Sigt,'ForegroundColor','black');
      params.sig.t=sig.t;
end

%%%%%

if error==1
    msgbox('Invalid Value', 'Error','error');%エラーが出たらメッセージ表示
    params=-1;
else
    set(handles.TEST,'String','OK!');
    t=timer;
    t.StartDelay = 2;
    t.TimerFcn = @(~,~) set(handles.TEST,'String','Test');
    start(t);
end

%%%% 引数をテスト用の関数に渡す%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
%  msgbox({'809南 : 104 ';'809北 : 112 ';'無響室 : 102 '});
check_device_ID;
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structur

% --- Executes on button press in Test.


% --- Executes on button press in RESET.
function RESET_Callback(hObject, eventdata, handles)%リセット
% hObject    handle to RESET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%数値のリセット
set(handles.FS,'String','48000');
set(handles.DEVICE_ID,'String','');
set(handles.DLY,'String','2150');
set(handles.NO_LSP,'String','');
set(handles.NO_MIC,'String','');
set(handles.impL,'String','');
set(handles.SigType,'Value',1);
set(handles.SigA,'String','');
set(handles.Sigt,'String','');
set(handles.fmin,'String','');
set(handles.fmax,'String','');

set(handles.text21,'Visible','off');
set(handles.text23,'Visible','off');
set(handles.fmin,'Visible','off');
set(handles.fmax,'Visible','off');
%%%%%色のリセット
set(handles.FS,'ForegroundColor','black');
set(handles.DEVICE_ID,'ForegroundColor','black');
set(handles.DLY,'ForegroundColor','black');
set(handles.NO_LSP,'ForegroundColor','black');
set(handles.NO_MIC,'ForegroundColor','black');
set(handles.impL,'ForegroundColor','black');
set(handles.SigA,'ForegroundColor','black');
set(handles.Sigt,'ForegroundColor','black');
set(handles.fmin,'ForegroundColor','black');
set(handles.fmax,'ForegroundColor','black');


% --- Executes on button press in MeasProg_GUI.
function MeasProg_GUI_Callback(hObject, eventdata, handles)
% hObject    handle to MeasProg_GUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closereq(); 
MeasProg_GUI


% --------------------------------------------------------------------
function Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
params=TEST_Callback(hObject, eventdata, handles);
if isstruct(params)
[filename,filepath]=uiputfile('*.mat');
if ~isequal(filename,0)
save(strcat(filepath,filename),'params');
end
end


% --------------------------------------------------------------------
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,filepath]=uigetfile('*.mat');
if ~isequal(filename,0)
load(strcat(filepath,filename),'params');
set(handles.FS,'String',num2str(params.FS));
set(handles.DEVICE_ID,'String',num2str(params.DEVICE_ID));
set(handles.DLY,'String',num2str(params.DLY));
set(handles.NO_LSP,'String',num2str(params.NO_LSP));
set(handles.NO_MIC,'String',num2str(params.NO_MIC));
set(handles.impL,'String',num2str(params.imp.L));
set(handles.SigType,'Value',params.sig.TYPEidx);
set(handles.SigA,'String',num2str(params.sig.A));
set(handles.Sigt,'String',num2str(params.sig.t));
if strcmp(params.sig.TYPE,'BPLogSS')
    set(handles.text21,'Visible','on');
    set(handles.text23,'Visible','on');
    set(handles.fmin,'Visible','on');
    set(handles.fmax,'Visible','on');
    set(handles.fmin,'String',num2str(params.sig.fmin));
    set(handles.fmax,'String',num2str(params.sig.fmax));
else
    set(handles.text21,'Visible','off');
    set(handles.text23,'Visible','off');
    set(handles.fmin,'Visible','off');
    set(handles.fmax,'Visible','off');
end

%%%%%色のリセット
set(handles.FS,'ForegroundColor','black');
set(handles.DEVICE_ID,'ForegroundColor','black');
set(handles.DLY,'ForegroundColor','black');
set(handles.NO_LSP,'ForegroundColor','black');
set(handles.NO_MIC,'ForegroundColor','black');
set(handles.impL,'ForegroundColor','black');
set(handles.SigA,'ForegroundColor','black');
set(handles.Sigt,'ForegroundColor','black');
set(handles.fmin,'ForegroundColor','black');
set(handles.fmax,'ForegroundColor','black');
end

% --------------------------------------------------------------------
function Back_Callback(hObject, eventdata, handles)
% hObject    handle to Back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closereq(); 


% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Test_Callback(hObject, eventdata, handles)
% hObject    handle to Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_10_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global version;
msgbox(version,'MeasProg','help');
