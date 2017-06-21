function varargout = LandingPage(varargin)
% LANDINGPAGE MATLAB code for LandingPage.fig
%      LANDINGPAGE, by itself, creates a new LANDINGPAGE or raises the existing
%      singleton*.
%
%      H = LANDINGPAGE returns the handle to a new LANDINGPAGE or the handle to
%      the existing singleton*.
%
%      LANDINGPAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LANDINGPAGE.M with the given input arguments.
%
%      LANDINGPAGE('Property','Value',...) creates a new LANDINGPAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LandingPage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LandingPage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LandingPage

% Last Modified by GUIDE v2.5 08-Jun-2017 23:33:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LandingPage_OpeningFcn, ...
                   'gui_OutputFcn',  @LandingPage_OutputFcn, ...
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
%set(gcf, 'units','normalized','outerposition',[0 0 1 1]);


% --- Executes just before LandingPage is made visible.
function LandingPage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LandingPage (see VARARGIN)

% Choose default command line output for LandingPage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LandingPage wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

setImageBG('C:\V-B-A-Github\Images\GUI Backgruonds\lp.jpg');


% --- Outputs from this function are returned to the command line.
function varargout = LandingPage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%axes(hObject);




% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

% --- Executes on button press in enter.
function enter_Callback(hObject, eventdata, handles)
% hObject    handle to enter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%detectFaceTampering;
Menu;



