function varargout = LandingPage(varargin)
%LANDINGPAGE MATLAB code file for LandingPage.fig
%      LANDINGPAGE, by itself, creates a new LANDINGPAGE or raises the existing
%      singleton*.
%
%      H = LANDINGPAGE returns the handle to a new LANDINGPAGE or the handle to
%      the existing singleton*.
%
%      LANDINGPAGE('Property','Value',...) creates a new LANDINGPAGE using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to LandingPage_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      LANDINGPAGE('CALLBACK') and LANDINGPAGE('CALLBACK',hObject,...) call the
%      local function named CALLBACK in LANDINGPAGE.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LandingPage

% Last Modified by GUIDE v2.5 11-Jun-2017 17:59:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LandingPage_OpeningFcn, ...
                   'gui_OutputFcn',  @LandingPage_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before LandingPage is made visible.
function LandingPage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for LandingPage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
setImageBG('C:\V-B-A-Github\Images\GUI Backgruonds\lp.jpg');
set(gcf,'units','normalized','outerposition',[0 0 1 1]) % maximize current figure
cd 'C:\V-B-A-Github';

% UIWAIT makes LandingPage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LandingPage_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in enter.
function enter_Callback(hObject, eventdata, handles)
% hObject    handle to enter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Menu;

% --- Executes during object creation, after setting all properties.
function LP_BG_axe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LP_BG_axe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate LP_BG_axe
    


% --- Executes on mouse press over axes background.
function LP_BG_axe_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to LP_BG_axe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
