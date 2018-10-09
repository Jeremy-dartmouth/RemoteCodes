function varargout = Preview(varargin)
% PREVIEW MATLAB code for Preview.fig
%      PREVIEW, by itself, creates a new PREVIEW or raises the existing
%      singleton*.
%
%      H = PREVIEW returns the handle to a new PREVIEW or the handle to
%      the existing singleton*.
%
%      PREVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREVIEW.M with the given input arguments.
%
%      PREVIEW('Property','Value',...) creates a new PREVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Preview_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Preview_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Preview

% Last Modified by GUIDE v2.5 08-Oct-2018 18:07:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Preview_OpeningFcn, ...
                   'gui_OutputFcn',  @Preview_OutputFcn, ...
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


% --- Executes just before Preview is made visible.
function Preview_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Preview (see VARARGIN)

% Choose default command line output for Preview
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Preview wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Preview_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
global OnOff_status;
OnOff_status = 'stop';

% --- Executes on button press in OnOff.
function OnOff_Callback(hObject, eventdata, handles)
% hObject    handle to OnOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid1 vid2; 
global OnOff_status;

if strcmp(OnOff_status, 'stop')
    src1 = getselectedsource(vid1);
    vid1.FramesPerTrigger = 1;
    src1.FrameRateMode = 'Manual';
    src1.FrameRate = 20;
    vidRes = get(vid1, 'VideoResolution');
    nBands = get(vid1, 'NumberOfBands');
    axes(handles.axes1);
    himage =  image( zeros(vidRes(1), vidRes(2), nBands));
    previewHandle1 = preview(vid1, himage);
    setappdata(previewHandle1,'UpdatePreviewWindowFcn',@Rot90); 
    
    src2 = getselectedsource(vid2);
    vid2.FramesPerTrigger = 1;
    % src1.FrameRateMode = 'Manual';
    % src1.FrameRate = 20;
    vidRes = get(vid2, 'VideoResolution');
    nBands = get(vid2, 'NumberOfBands');
    axes(handles.axes2);
    hImage = image( zeros(vidRes(1), vidRes(2), nBands));
    previewHandle2=preview(vid2, hImage);
    OnOff_status = 'start';
    set(handles.OnOff,'string','stop');
    setappdata(previewHandle2,'UpdatePreviewWindowFcn',@IRot90); 
else
    stoppreview(vid1);
    stoppreview(vid2);
    OnOff_status = 'stop';
    set(handles.OnOff,'string','start');
end

function Rot90(obj, event, himage)

    rotImg = rot90(event.Data,-1);
    set(himage, 'cdata', rotImg);
    
function IRot90(obj, event, himage)

    rotImg = rot90(event.Data);
    set(himage, 'cdata', rotImg);


% --- Executes on button press in Record.
function Record_Callback(hObject, eventdata, handles)
% hObject    handle to Record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

colormap('gray');

vid11 = videoinput('pointgrey', 1, 'F7_Mono16_1280x960_Mode0');
start(vid11);
stoppreview(vid11);
tmp = squeeze(getdata(vid11));
img1 = mean(tmp,3);
imagesc(handles.axes1,img1);  set(handles.axes1,'xtick',[]);set(handles.axes1,'ytick',[]);

vid22 = videoinput('pointgrey', 2, 'F7_Mono16_1280x960_Mode0');
start(vid22);
stoppreview(vid22);
tmp = squeeze(getdata(vid22));
img2 = mean(tmp,3);
imagesc(handles.axes2,img2);  set(handles.axes2,'xtick',[]);set(handles.axes2,'ytick',[]);
