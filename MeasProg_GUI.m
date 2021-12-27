function varargout = MeasProg_GUI(varargin)
% SELECT_MEASURE_MODE MATLAB code for select_measure_mode.fig
%      SELECT_MEASURE_MODE, by itself, creates a new SELECT_MEASURE_MODE or raises the existing
%      singleton*.
%
%      H = SELECT_MEASURE_MODE returns the handle to a new SELECT_MEASURE_MODE or the handle to
%      the existing singleton*.
%
%      SELECT_MEASURE_MODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECT_MEASURE_MODE.M with the given input arguments.
%
%      SELECT_MEASURE_MODE('Property','Value',...) creates a new SELECT_MEASURE_MODE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before select_measure_mode_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to select_measure_mode_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help select_measure_mode

% Last Modified by GUIDE v2.5 27-Dec-2021 21:22:35
global version;
version = { 'Measure Program';...
            'v 1.0';...
            '©2021 Hanelab. All rights reserved.'};
% Last edition by Y. Ren v 1.0 2021/12/21
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MeasProg_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MeasProg_GUI_OutputFcn, ...
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


% --- Executes just before select_measure_mode is made visible.
function MeasProg_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to select_measure_mode (see VARARGIN)

% Choose default command line output for select_measure_mode
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
movegui(gcf,'center');

% UIWAIT makes select_measure_mode wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MeasProg_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in static.
function static_Callback(hObject, eventdata, handles)
% hObject    handle to static (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closereq();
   MeasProg_GUI_static
% --- Executes on button press in rotate.
function rotate_Callback(hObject, eventdata, handles)
% hObject    handle to rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closereq();
   MeasProg_GUI_turntable

% --- Executes on button press in actuator.
function actuator_Callback(hObject, eventdata, handles)
% hObject    handle to actuator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closereq();
   MeasProg_GUI_actuator


% --------------------------------------------------------------------
function Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Menu (see GCBO)
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


% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closereq(); 


% --- Executes on button press in Pre.
function Pre_Callback(hObject, eventdata, handles)
% hObject    handle to Pre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closereq();
   PreMeas_GUI
