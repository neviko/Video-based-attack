function varargout = Testing(varargin)
%TESTING MATLAB code file for Testing.fig
%      TESTING, by itself, creates a new TESTING or raises the existing
%      singleton*.
%
%      H = TESTING returns the handle to a new TESTING or the handle to
%      the existing singleton*.
%
%      TESTING('Property','Value',...) creates a new TESTING using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Testing_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      TESTING('CALLBACK') and TESTING('CALLBACK',hObject,...) call the
%      local function named CALLBACK in TESTING.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Testing

% Last Modified by GUIDE v2.5 13-Jun-2017 22:10:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Testing_OpeningFcn, ...
                   'gui_OutputFcn',  @Testing_OutputFcn, ...
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


% --- Executes just before Testing is made visible.
function Testing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for Testing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Testing wait for user response (see UIRESUME)
% uiwait(handles.figure1);
setImageBG('C:\V-B-A-Github\Images\GUI Backgruonds\alg.jpg');
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

set(handles.uitable1,'visible', 'off');
set(handles.axes1,'visible', 'off');
set(handles.axes2,'visible', 'off');
set(handles.axes4,'visible', 'off');



% --- Outputs from this function are returned to the command line.
function varargout = Testing_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadTwoConsFrames.
function loadTwoConsFrames_Callback(hObject, eventdata, handles)
cla(handles.axes1,'reset'); % clear the current image from the axis
cla(handles.axes2,'reset'); % clear the current image from the axis
set(handles.uitable1,'visible', 'off'); %table invisible
cla(handles.axes4,'reset'); % clear the current image from the axis
set(handles.axes1,'visible', 'off');
set(handles.axes2,'visible', 'off');
set(handles.axes4,'visible', 'off');


%clear Table data
t= uitable(handles.uitable1);
t.Data = [];

%load image 1
imageFullPath1 = 'C:\V-B-A-Github\Images\consecutive images\n1.jpg';
image1 = imread(imageFullPath1);
if(isempty(imageFullPath1))
    return;
end
axes(handles.axes1);
imshow(image1);

%load image 2
imageFullPath2 = 'C:\V-B-A-Github\Images\consecutive images\n2.jpg';
if(isempty(imageFullPath2))
    return;
end
image2 = imread(imageFullPath2);
axes(handles.axes2);
imshow(image2);

% run accurate detection
pointMatrixLeft = imageAccDetection(image1);
pointMatrixRight = imageAccDetection(image2);

axes(handles.axes1);
hold on;
disMatrixL = calculateDistances( pointMatrixLeft,[],false);

axes(handles.axes2);
hold on;
disMatrixR = calculateDistances( pointMatrixRight,[],false);


[isChanged,diffSpatioMatrix] = isPersonChanged( disMatrixL,disMatrixR,0.07 );

if(isempty(diffSpatioMatrix))%error message and exit
end

if(isChanged ==false)%error message and exit
end

set(handles.uitable1,'visible', 'on');
t= uitable(handles.uitable1);
t.Data = diffSpatioMatrix;
t.ColumnName = {'Name','Distance-L','Distance-R','Hash-L','Hash-R','Ratio','Is Big Change'};

axes(handles.axes4);
diffImage = imabsdiff(image1,image2);
imshow(diffImage);

% --- Executes on button press in loadNonConsFrames.
function loadNonConsFrames_Callback(hObject, eventdata, handles)
% hObject    handle to loadNonConsFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%cla(handles.uitable1,'reset'); % clear the current image from the axis
cla(handles.axes1,'reset'); % clear the current image from the axis
cla(handles.axes2,'reset');
cla(handles.axes4,'reset');
set(handles.uitable1,'visible', 'off'); %table invisible
set(handles.axes1,'visible', 'off');
set(handles.axes2,'visible', 'off');
set(handles.axes4,'visible', 'off');

%clear Table data
t= uitable(handles.uitable1);
t.Data = [];

%load image 1
imageFullPath1 = 'C:\V-B-A-Github\Images\consecutive images\n6.jpg';
image1 = imread(imageFullPath1);
if(isempty(imageFullPath1))
    return;
end
axes(handles.axes1);
imshow(image1);

%load image 2
imageFullPath2 = 'C:\V-B-A-Github\Images\consecutive images\n1.jpg';
if(isempty(imageFullPath2))
    return;
end
image2 = imread(imageFullPath2);
axes(handles.axes2);
imshow(image2);

% run accurate detection
pointMatrixLeft = imageAccDetection(image1);
pointMatrixRight = imageAccDetection(image2);

axes(handles.axes1);
hold on;
disMatrixL = calculateDistances( pointMatrixLeft,[],false);

axes(handles.axes2);
hold on;
disMatrixR = calculateDistances( pointMatrixRight,[],false);


[isChanged,diffSpatioMatrix] = isPersonChanged( disMatrixL,disMatrixR,0.07 );

if(isempty(diffSpatioMatrix))%error message and exit
end

if(isChanged ==true)%error message and exit
    msgbox('Tampering detected!\nThe distances ratio between the last two frames was very high','Error message','error');
end

set(handles.uitable1,'visible', 'on');
t= uitable(handles.uitable1);
t.Data = diffSpatioMatrix;
t.ColumnName = {'Name','Distance-L','Distance-R','Hash-L','Hash-R','Ratio','Is Big Change'};


axes(handles.axes4);
diffImage = imabsdiff(image1,image2);
imshow(diffImage);




function videoBtn_Callback(hObject, eventdata, handles)

cla(handles.axes1,'reset'); % clear the current image from the axis
cla(handles.axes2,'reset'); % clear the current image from the axis
cla(handles.axes4,'reset'); % clear the current image from the axis
cla(handles.uitable1,'reset'); % clear the current image from the axis

set(handles.axes1,'visible', 'off');
set(handles.axes2,'visible', 'off');
set(handles.uitable1,'visible', 'off');
set(handles.axes4,'visible', 'off');



lastDir = pwd;
newDir = strcat(pwd,'\matlab_version');
cd (newDir); %set new direction


%clear all
clc
addpath('PDM_helpers');
addpath('fitting');
addpath('models');
addpath('face_detection');
%% loading the patch experts
[clmParams, pdm] = Load_CLM_params_vid();
[patches] = Load_Patch_Experts( 'models/general/', 'svr_patches_*_general.mat', [], [], clmParams);
% [patches] = Load_Patch_Experts( 'models/general/', 'ccnf_patches_*_general.mat', [], [], clmParams);
clmParams.multi_modal_types  = patches(1).multi_modal_types;
% load the face validator and add its dependency
load('face_validation/trained/face_check_cnn_68.mat', 'face_check_cnns');
[file, path] = uigetfile({'*.avi';'*.mpg'},'Select video file');
if (isequal(file,0) || isequal(file,0))

    cd(lastDir); %come back to the last direction
    return;
end
 vr = VideoReader(fullfile(path, file));
 vr.CurrentTime = 2.5; 
 currAxes = axes; % create an axes
 currAxes.Position=[0.04 0.0005 0.80 0.7150]; % axes position
 addpath('mexopencv-master\')
 detector = cv.CascadeClassifier('haarcascade_frontalface_alt2.xml');
 
 frameNumber=0;
 notDetectedcounter=0; %how many times the system didn't recognized face
 lastFrame=[];
 currFrame = [];
 videoMatrix={};
 maxNumOfFrames =70;
 isPerChangedCounter=0;

 
 while hasFrame(vr) && frameNumber< maxNumOfFrames %while the video is running
    
    frameNumber = frameNumber+1; %increment the frame number
    
    frame = readFrame(vr); % read frame
    image(frame, 'Parent', currAxes); %display the image on axes
    currAxes.Visible = 'off';    
    currAxes.Visible = 'off';
    im = cv.cvtColor(frame, 'RGB2GRAY'); %pars the image to gray scale
    im = cv.equalizeHist(im);
    boxes = detector.detect(im, 'ScaleFactor',1.3,'MinNeighbors',2, 'MinSize', [30,30]);   
    if isempty(boxes)          
        drawnow;
        continue;
    end    
    % First attempt to use the Matlab one (fastest but not as accurate, if not present use yu et al.)   
    det_shapes = [];
    
    
    if(~isempty(boxes))
        boxes = cell2mat(boxes');
        % Convert to the right format
        bboxs = boxes';                
        % Correct the bounding box to be around face outline
        % horizontally and from brows to chin vertically
        % The scalings were learned using the Face Detections on LFPW, Helen, AFW and iBUG datasets
        % using ground truth and detections from openCV
        % Correct the widths
        bboxs(3,:) = bboxs(3,:) * 0.8534;
        bboxs(4,:) = bboxs(4,:) * 0.8972;                
        % Correct the location
        bboxs(1,:) = bboxs(1,:) + boxes(:,3)'*0.0266;
        bboxs(2,:) = bboxs(2,:) + boxes(:,4)'*0.1884;
        bboxs(3,:) = bboxs(1,:) + bboxs(3,:);
        bboxs(4,:) = bboxs(2,:) + bboxs(4,:);
    
    else
        notDetectedcounter = notDetectedcounter+1;
        frameNumber=0;
    
    end
    
    
    
    for i=1:size(bboxs,2)
        % Convert from the initial detected shape to CLM model parameters,
        % if shape is available
        bbox = bboxs(:,i);
        num_points = numel(pdm.M) / 3;
        M = reshape(pdm.M, num_points, 3);
        width_model = max(M(:,1)) - min(M(:,1));
        height_model = max(M(:,2)) - min(M(:,2));
        a = (((bbox(3) - bbox(1)) / width_model) + ((bbox(4) - bbox(2))/ height_model)) / 2;
        tx = (bbox(3) + bbox(1))/2;
        ty = (bbox(4) + bbox(2))/2;
        % correct it so that the bounding box is just around the minimum
        % and maximum point in the initialised face
        tx = tx - a*(min(M(:,1)) + max(M(:,1)))/2;
        ty = ty + a*(min(M(:,2)) + max(M(:,2)))/2;
        % visualisation
        g_param = [a, 0, 0, 0, tx, ty]';
        l_param = zeros(size(pdm.E));
        [shape,~,~,lhood,lmark_lhood,view_used] = Fitting_from_bb(im, [], bbox, pdm, patches, clmParams, 'gparam', g_param, 'lparam', l_param);    
        % shape correction for matlab format
        shape = shape + 1;
        
        %adding 6 more points on the user cheeks
   
        %low cheek right
        shape(69,1) =shape(37,1);
        shape(69,2) =shape(31,2);
        
        %low cheek left
        shape(70,1) = shape(46,1);
        shape(70,2) = shape(31,2);
        
        %up cheek right
        shape(71,1) =shape(41,1);
        shape(71,2) =shape(30,2);
        
        %up cheek left
        shape(72,1) = shape(48,1);
        shape(72,2) = shape(30,2);
        
        %right cheek-mouth points
        shape(73,1) = shape(42,1);
        shape(73,2) = shape(52,2);
        
        %left cheek-mouth points
        shape(74,1) = shape(47,1);
        shape(74,2) = shape(52,2);
        
        try    
            hold on;
            if(frameNumber==1)
                lastFrame= shape;
                disMatrixLast = calculateDistances( lastFrame,[],false);
            else
                currFrame= shape;
                disMatrixCurr = calculateDistances( currFrame,[],false);
                [isChanged,diffSpatioArr] = isPersonChanged( disMatrixLast,disMatrixCurr,0.6);
                
                if(isChanged==true)
                    isPerChangedCounter = isPerChangedCounter+1;
                    if(isPerChangedCounter >= floor(size(disMatrixLast,1) * 1))
                            msgbox('Tampering detected!\n The distances ratio between the last two frames was very high','Error message','error');
                            break;
                    end
                    
                end
                if(isempty(videoMatrix))
                    videoMatrix(:,end+1) = diffSpatioArr(:,1); % copy dis names
                end
                videoMatrix(:,end+1) = diffSpatioArr(:,2); %copy distances
                videoMatrix(:,end+1) = diffSpatioArr(:,3); %copy distances
                
                
            end
            drawnow expose;
            hold off;
            
        catch warn
            fprintf('%s', warn.message);
        end
        
        if(frameNumber > 1)
            lastFrame=currFrame;
            currFrame=[];
        end
        
        
        
        
    end    
 end
 
f = figure;
t = uitable;
t.Units='normalized';
t.Position =[0 0 1 1];
t.FontSize = 15;
t.Data = videoMatrix; %insert data to the table
 
 delete(vr); %delete video reader pointer
 delete(gca);% delete the axes
 cd(lastDir); %come back to the last direction
 
 
 



