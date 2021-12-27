function varargout = MeasProg_GUI_actuator(varargin)
% MEASPROG_GUI_ACTUATOR MATLAB code for MeasProg_GUI_actuator.fig
%      MEASPROG_GUI_ACTUATOR, by itself, creates a new MEASPROG_GUI_ACTUATOR or raises the existing
%      singleton*.
%
%      H = MEASPROG_GUI_ACTUATOR returns the handle to a new MEASPROG_GUI_ACTUATOR or the handle to
%      the existing singleton*.
%
%      MEASPROG_GUI_ACTUATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MEASPROG_GUI_ACTUATOR.M with the given input arguments.
%
%      MEASPROG_GUI_ACTUATOR('Property','Value',...) creates a new MEASPROG_GUI_ACTUATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MeasProg_GUI_actuator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MeasProg_GUI_actuator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MeasProg_GUI_actuator

% Last Modified by GUIDE v2.5 27-Dec-2021 19:22:27
global version;
version = { 'Measure Program for Actuator';...
            'v 1.0';...
            '©2021 Hanelab. All rights reserved.'};
% Last edition by Y. Ren v 1.0 2021/12/27
global set_LSP;
global set_MIC;
global file_dir;
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MeasProg_GUI_actuator_OpeningFcn, ...
                   'gui_OutputFcn',  @MeasProg_GUI_actuator_OutputFcn, ...
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


% --- Executes just before MeasProg_GUI_actuator is made visible.
function MeasProg_GUI_actuator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MeasProg_GUI_actuator (see VARARGIN)

% Choose default command line output for MeasProg_GUI_actuator
handles.output = hObject;
global set_LSP;
set_LSP=[];
global set_MIC;
set_MIC=[];
global file_dir;
file_dir=[];
% Update handles structure
guidata(hObject, handles);
movegui(gcf,'center');

% UIWAIT makes MeasProg_GUI_actuator wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = MeasProg_GUI_actuator_OutputFcn(hObject, eventdata, handles) 
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

    
% hObject    handle to DLY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with hanDLY_STR=get(hObject,'String');
    set(hObject,'UserData',DLY_STR);
    
    %dles and user data (see GUIDATA)

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



function TRAIL_Callback(hObject, eventdata, handles)

    TRIAL_STR=get(hObject,'String');
    set(hObject,'UserData',TRIAL_STR);
% hObject    handle to TRAIL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TRAIL as text
%        str2double(get(hObject,'String')) returns contents of TRAIL as a double


% --- Executes during object creation, after setting all properties.
function TRAIL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TRAIL (see GCBO)
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


% --- Executes on button press in WARM_UP.
function WARM_UP_Callback(hObject, eventdata, handles)
% hObject    handle to WARM_UP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of WARM_UP
    checkbox=get(hObject,'Value');
    set(hObject,'UserData',checkbox);

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
        set(handles.text28,'Visible','on');
        set(handles.text29,'Visible','on');
        set(handles.fmin,'Visible','on');
        set(handles.fmax,'Visible','on');
    else
        set(handles.text28,'Visible','off');
        set(handles.text29,'Visible','off');
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


function meas_name_Callback(hObject, eventdata, handles)
% hObject    handle to meas_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meas_name as text
%        str2double(get(hObject,'String')) returns contents of meas_name as a double
    FILE_NAME=get(hObject,'String');
    set(hObject,'UserData',FILE_NAME);

% --- Executes during object creation, after setting all properties.
function meas_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meas_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in RecordRawData.
function RecordRawData_Callback(hObject, eventdata, handles)
% hObject    handle to RecordRawData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RecordRawData

    checkbox_r=get(hObject,'Value');
    set(hObject,'UserData',checkbox_r);
    
    
function Xmin_Callback(hObject, eventdata, handles)
% hObject    handle to Xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xmin as text
%        str2double(get(hObject,'String')) returns contents of Xmin as a double

     Xmin_STR=get(hObject,'String');
     set(hObject,'UserData',Xmin_STR);


% --- Executes during object creation, after setting all properties.
function Xmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Xmax_Callback(hObject, eventdata, handles)
% hObject    handle to Xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xmax as text
%        str2double(get(hObject,'String')) returns contents of Xmax as a double

     Xmax_STR=get(hObject,'String');
     set(hObject,'UserData',Xmax_STR);

% --- Executes during object creation, after setting all properties.
function Xmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Zmin_Callback(hObject, eventdata, handles)
% hObject    handle to Zmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Zmin as text
%        str2double(get(hObject,'String')) returns contents of Zmin as a double

     Zmin_STR=get(hObject,'String');
     set(hObject,'UserData',Zmin_STR);
     
     
% --- Executes during object creation, after setting all properties.
function Zmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Zmax_Callback(hObject, eventdata, handles)
% hObject    handle to Zmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Zmax as text
%        str2double(get(hObject,'String')) returns contents of Zmax as a double

     Zmax_STR=get(hObject,'String');
     set(hObject,'UserData',Zmax_STR);

% --- Executes during object creation, after setting all properties.
function Zmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Xint_Callback(hObject, eventdata, handles)
% hObject    handle to Xint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xint as text
%        str2double(get(hObject,'String')) returns contents of Xint as a double

     Xint_STR=get(hObject,'String');
     set(hObject,'UserData',Xint_STR);

% --- Executes during object creation, after setting all properties.
function Xint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Zint_Callback(hObject, eventdata, handles)
% hObject    handle to Zint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Zint as text
%        str2double(get(hObject,'String')) returns contents of Zint as a double
     Zint_STR=get(hObject,'String');
     set(hObject,'UserData',Zint_STR);

% --- Executes during object creation, after setting all properties.
function Zint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zint (see GCBO)
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
 [imp] = MeasProg_actuator(params);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
%  msgbox({'809南 : 104 ';'809北 : 112 ';'無響室 : 102 '});
check_device_ID;
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structur

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

global set_LSP;
if isempty(set_LSP)
    set_LSP=[1:NO_LSP];
end
params.set_LSP=set_LSP;
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

global set_MIC;
if isempty(set_MIC)
    set_MIC=[1:NO_MIC];
end
params.set_MIC=set_MIC;
%%%%%

%%%%測定回数
TR_STR=get(handles.TRAIL,'String');
% % FS_STR=get(FS,'String');
TRIAL=str2double(TR_STR);

if TRIAL<=0 || TRIAL/round(TRIAL)~=1  %%正の整数でないとエラー
      error=1;
      set(handles.TRAIL,'ForegroundColor','red');
else
      set(handles.TRAIL,'ForegroundColor','black');
      params.TRIAL=TRIAL;
end


%%%%%

%%%%%スピーカのウォームアップ
WARM_UP=get(handles.WARM_UP,'Value');
params.WARM_UPvalue=WARM_UP;
if WARM_UP==1
    WARM_UP='ON';
else
    WARM_UP='OFF';
end
params.WARM_UP=WARM_UP;
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

%%%%%ファイルネーム

meas_name=get(handles.meas_name,'String');
params.meas_name=meas_name;
global file_dir;
if isempty(file_dir)
    file_dir="";
end
params.file_dir=file_dir;

%%%%%生データの録音
check_value_rec=get(handles.RecordRawData,'Value');
params.SAVE_RAW=check_value_rec;

%%%%%% 測定範囲 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% x軸方向の最小値

Xmin_STR=get(handles.Xmin,'String');
act.MIN_X=str2double(Xmin_STR); %mに換算(もしmなら/100消す)
params.act.MIN_X=act.MIN_X;
%%%%% x軸方向の最大値

Xmax_STR=get(handles.Xmax,'String');
act.MAX_X=str2double(Xmax_STR);
params.act.MAX_X=act.MAX_X;
%%%%% 測定間隔 x軸

Xint_STR=get(handles.Xint,'String');
act.INR_X=str2double(Xint_STR);
params.act.INR_X=act.INR_X;
%%%%% z軸方向の最小値

Zmin_STR=get(handles.Zmin,'String');
act.MIN_Z=str2double(Zmin_STR);
params.act.MIN_Z=act.MIN_Z;
%%%%% z軸方向の最大値

Zmax_STR=get(handles.Zmax,'String');
act.MAX_Z=str2double(Zmax_STR);
params.act.MAX_Z=act.MAX_Z;
%%%%% 測定間隔 z軸

Zint_STR=get(handles.Zint,'String');
act.INR_Z=str2double(Zint_STR);
params.act.INR_Z=act.INR_Z;
%%%%% x軸方向　%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%最小値が負もしくは最大値より大きいときエラー
if act.MIN_X<0 || 100<act.MIN_X || isnan(act.MIN_X)
    error=1;
      set(handles.Xmin,'ForegroundColor','red');
else
      set(handles.Xmin,'ForegroundColor','black');
end

%%%%%最大値が負もしくは1mより大きいときエラー
if act.MAX_X<0 || 100<act.MAX_X || isnan(act.MAX_X)
    error=1;
      set(handles.Xmax,'ForegroundColor','red');
else
      set(handles.Xmax,'ForegroundColor','black');
end

%%%%%最大値と最小値の差が測定間隔で割り切れない時
%%%%% 間隔が0cm以下、間隔が最大値よりも大きくなる時エラー
if mod((act.MAX_X-act.MIN_X),act.INR_X) ~=0 || xor(act.INR_X<0,act.MIN_X>act.MAX_X)
    error=1;
      set(handles.Xint,'ForegroundColor','red');
else
      set(handles.Xint,'ForegroundColor','black');
end

%%%%% z軸方向　%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%最小値が負もしくは最大値より大きいときエラー
if act.MIN_Z<0 || 50<act.MIN_Z || isnan(act.MIN_Z)
    error=1;
      set(handles.Zmin,'ForegroundColor','red');
else
      set(handles.Zmin,'ForegroundColor','black');
end

%%%%%最大値が負もしくは1mより大きいときエラー
if act.MAX_Z<0 || 50<act.MAX_Z || isnan(act.MAX_Z)
    error=1;
      set(handles.Zmax,'ForegroundColor','red');
else
      set(handles.Zmax,'ForegroundColor','black');
end

%%%%%最大値と最小値の差が測定間隔で割り切れない時
%%%%% 間隔が0cm以下、間隔が最大値よりも大きくなる時エラー
if mod((act.MAX_Z-act.MIN_Z),act.INR_Z) ~=0 || xor(act.INR_Z<0,act.MIN_Z>act.MAX_Z)
    error=1;
      set(handles.Zint,'ForegroundColor','red');
else
      set(handles.Zint,'ForegroundColor','black');
end

%%%%% エラーが出たらメッセージ表示

if error==1
    msgbox('Invalid Value', 'Error','error');
    params=-1;
else
    set(handles.TEST,'String','OK!');
    t=timer;
    t.StartDelay = 2;
    t.TimerFcn = @(~,~) set(handles.TEST,'String','Test');
    start(t);
end

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
set(handles.TRAIL,'String','1');
set(handles.WARM_UP,'Value',0);
set(handles.impL,'String','');
set(handles.SigType,'Value',1);
set(handles.SigA,'String','');
set(handles.Sigt,'String','');
set(handles.fmin,'String','');
set(handles.fmax,'String','');
set(handles.meas_name,'String','');
set(handles.Xmin,'String','0');
set(handles.Xmax,'String','100');
set(handles.Xint,'String','');
set(handles.Zmin,'String','0');
set(handles.Zmax,'String','50');
set(handles.Zint,'String','');
set(handles.RecordRawData,'Value',0);
global set_LSP;
set_LSP=[];
global set_MIC;
set_MIC=[];
global file_dir;
file_dir=[];

set(handles.text28,'Visible','off');
set(handles.text29,'Visible','off');
set(handles.fmin,'Visible','off');
set(handles.fmax,'Visible','off');
%%%%%色のリセット
set(handles.FS,'ForegroundColor','black');
set(handles.DEVICE_ID,'ForegroundColor','black');
set(handles.DLY,'ForegroundColor','black');
set(handles.NO_LSP,'ForegroundColor','black');
set(handles.NO_MIC,'ForegroundColor','black');
set(handles.TRAIL,'ForegroundColor','black');
set(handles.impL,'ForegroundColor','black');
set(handles.SigA,'ForegroundColor','black');
set(handles.Sigt,'ForegroundColor','black');
set(handles.fmin,'ForegroundColor','black');
set(handles.fmax,'ForegroundColor','black');
set(handles.meas_name,'ForegroundColor','black');
set(handles.Xmin,'ForegroundColor','black');
set(handles.Xmax,'ForegroundColor','black');
set(handles.Xint,'ForegroundColor','black');
set(handles.Zmin,'ForegroundColor','black');
set(handles.Zmax,'ForegroundColor','black');
set(handles.Zint,'ForegroundColor','black');

% --- Executes on button press in MeasProg_GUI.
function MeasProg_GUI_Callback(hObject, eventdata, handles)
% hObject    handle to MeasProg_GUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closereq(); 
MeasProg_GUI

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global set_LSP
currentscreensize=get(0,'screensize');
figpcs = uifigure('Name','Loudspeaker Indices','Position',[currentscreensize(3)/2-400,currentscreensize(4)/2-50,800,100]);
label1 = uilabel(figpcs,...
    'Position',[20 70 800 20],...
    'Text','Please input the loudspeaker indices');
label1.WordWrap = 'on';
label1.HorizontalAlignment = 'left';
label1.VerticalAlignment = 'top';
edf1 = uieditfield(figpcs, 'text', 'Position',[20 50 740 20]);
if ~isempty(set_LSP)
    edf1.Value = num2str(set_LSP(1));
    for i = 2:length(set_LSP)
        edf1.Value = edf1.Value+", "+num2str(set_LSP(i));
    end
end
cfm1 = uibutton(figpcs, 'push',...
    'Text', 'OK',...
    'Position',[380 10 80 30],...
    'ButtonPushedFcn', @(cfm1,event) cfm1Pushed(cfm1,edf1,figpcs,handles));

function cfm1Pushed(cfm1,edf1,figpcs,handles)
    global set_LSP;
    STR=edf1.Value;
    [set_LSP, NO_LSP] = getIndices(STR);
    set(handles.NO_LSP,'String',num2str(NO_LSP));
    close(figpcs);


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global set_MIC
currentscreensize=get(0,'screensize');
figpcs = uifigure('Name','Microphone Indices','Position',[currentscreensize(3)/2-400,currentscreensize(4)/2-50,800,100]);
label1 = uilabel(figpcs,...
    'Position',[20 70 800 20],...
    'Text','Please input the microphone indices');
label1.WordWrap = 'on';
label1.HorizontalAlignment = 'left';
label1.VerticalAlignment = 'top';
edf2 = uieditfield(figpcs, 'text', 'Position',[20 50 740 20]);
if ~isempty(set_MIC)
    edf2.Value = num2str(set_MIC(1));
    for i = 2:length(set_MIC)
        edf2.Value = edf2.Value+", "+num2str(set_MIC(i));
    end
end
cfm2 = uibutton(figpcs, 'push',...
    'Text', 'OK',...
    'Position',[380 10 80 30],...
    'ButtonPushedFcn', @(cfm2,event) cfm2Pushed(cfm2,edf2,figpcs,handles));

function cfm2Pushed(cfm2,edf2,figpcs,handles)
    global set_MIC;
    STR=edf2.Value;
    [set_MIC, NO_MIC] = getIndices(STR);
    set(handles.NO_MIC,'String',num2str(NO_MIC));
    close(figpcs);


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
set(handles.TRAIL,'String',num2str(params.TRIAL));
set(handles.WARM_UP,'Value',params.WARM_UPvalue);
set(handles.impL,'String',num2str(params.imp.L));
set(handles.SigType,'Value',params.sig.TYPEidx);
set(handles.SigA,'String',num2str(params.sig.A));
set(handles.Sigt,'String',num2str(params.sig.t));
if strcmp(params.sig.TYPE,'BPLogSS')
    set(handles.text28,'Visible','on');
    set(handles.text29,'Visible','on');
    set(handles.fmin,'Visible','on');
    set(handles.fmax,'Visible','on');
    set(handles.fmin,'String',num2str(params.sig.fmin));
    set(handles.fmax,'String',num2str(params.sig.fmax));
else
    set(handles.text28,'Visible','off');
    set(handles.text29,'Visible','off');
    set(handles.fmin,'Visible','off');
    set(handles.fmax,'Visible','off');
end
set(handles.meas_name,'String',params.meas_name);
set(handles.Xmin,'String',num2str(params.act.MIN_X));
set(handles.Xmax,'String',num2str(params.act.MAX_X));
set(handles.Xint,'String',num2str(params.act.INR_X));
set(handles.Zmin,'String',num2str(params.act.MIN_Z));
set(handles.Zmax,'String',num2str(params.act.MAX_Z));
set(handles.Zint,'String',num2str(params.act.INR_Z));
set(handles.RecordRawData,'Value',params.SAVE_RAW);
global set_LSP;
set_LSP=params.set_LSP;
global set_MIC;
set_MIC=params.set_MIC;
global file_dir;
file_dir=params.file_dir;

%%%%%色のリセット
set(handles.FS,'ForegroundColor','black');
set(handles.DEVICE_ID,'ForegroundColor','black');
set(handles.DLY,'ForegroundColor','black');
set(handles.NO_LSP,'ForegroundColor','black');
set(handles.NO_MIC,'ForegroundColor','black');
set(handles.TRAIL,'ForegroundColor','black');
set(handles.impL,'ForegroundColor','black');
set(handles.SigA,'ForegroundColor','black');
set(handles.Sigt,'ForegroundColor','black');
set(handles.fmin,'ForegroundColor','black');
set(handles.fmax,'ForegroundColor','black');
set(handles.meas_name,'ForegroundColor','black');
set(handles.Xmin,'ForegroundColor','black');
set(handles.Xmax,'ForegroundColor','black');
set(handles.Xint,'ForegroundColor','black');
set(handles.Zmin,'ForegroundColor','black');
set(handles.Zmax,'ForegroundColor','black');
set(handles.Zint,'ForegroundColor','black');
end


% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% close MeasProg_GUI_actuator
closereq(); 


% --------------------------------------------------------------------
function MeasureMenu_Callback(hObject, eventdata, handles)
% hObject    handle to MeasureMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function HelpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to HelpMenu (see GCBO)
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


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global file_dir
currentscreensize=get(0,'screensize');
figpcs = uifigure('Name','File Directory','Position',[currentscreensize(3)/2-400,currentscreensize(4)/2-50,800,100]);
label1 = uilabel(figpcs,...
    'Position',[20 70 800 20],...
    'Text','Please select file directory');
label1.WordWrap = 'on';
label1.HorizontalAlignment = 'left';
label1.VerticalAlignment = 'top';
edf3 = uieditfield(figpcs, 'text', 'Position',[40 50 740 20]);
if ~isempty(file_dir)
    edf3.Value = file_dir;
end
cfm3 = uibutton(figpcs, 'push',...
    'Text', '',...
    'Icon', 'icon_folder.png',...
    'Position',[20 50 20 20],...
    'ButtonPushedFcn', @(cfm3,event) cfm3Pushed(cfm3,edf3,figpcs));
cfm4 = uibutton(figpcs, 'push',...
    'Text', 'OK',...
    'Position',[380 10 80 30],...
    'ButtonPushedFcn', @(cfm4,event) cfm4Pushed(cfm4,edf3,figpcs,handles));

function cfm3Pushed(cfm3,edf3,figpcs)
    figpcs.Visible='off';
    dir_tmp=uigetdir();
    edf3.Value = convertCharsToStrings(dir_tmp);
    edf3.Value = strcat(edf3.Value,'\');
    figpcs.Visible='on';
    
function cfm4Pushed(cfm4,edf3,figpcs,handles)
    global file_dir;
    file_dir=edf3.Value;
    close(figpcs);
