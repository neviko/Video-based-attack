function varargout = detectFaceTampering(varargin)
% DETECTFACETAMPERING MATLAB code for detectFaceTampering.fig
%      DETECTFACETAMPERING, by itself, creates a new DETECTFACETAMPERING or raises the existing
%      singleton*.
%
%      H = DETECTFACETAMPERING returns the handle to a new DETECTFACETAMPERING or the handle to
%      the existing singleton*.
%
%      DETECTFACETAMPERING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DETECTFACETAMPERING.M with the given input arguments.
%
%      DETECTFACETAMPERING('Property','Value',...) creates a new DETECTFACETAMPERING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before detectFaceTampering_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to detectFaceTampering_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help detectFaceTampering

% Last Modified by GUIDE v2.5 10-Feb-2017 11:57:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @detectFaceTampering_OpeningFcn, ...
                   'gui_OutputFcn',  @detectFaceTampering_OutputFcn, ...
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


% --- Executes just before detectFaceTampering is made visible.
function detectFaceTampering_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to detectFaceTampering (see VARARGIN)

% Choose default command line output for detectFaceTampering
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes detectFaceTampering wait for user response (see UIRESUME)
% uiwait(handles.onLoadImage);


% --- Outputs from this function are returned to the command line.
function varargout = detectFaceTampering_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in onLoadImage1.
function onLoadImage1_Callback(hObject, eventdata, handles)
% hObject    handle to onLoadImage1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%[fileName , pathName]= uigetfile({'*.jpg'; '*.jpeg'; '*.png';'*.bmp'},'File Selector'); %disply only mosix files.

%imageFullPath = strcat(pathName,fileName);

imageFullPath = getImagePath(); % private function to get the full path with UI file selector


axes(handles.axes1);
image = imread(imageFullPath);
imshow(image);


assignin('base','imageFullPath1',imageFullPath); %pass fullPathName to base workspace for data sharing between functions.


 
 


% --- Executes on button press in onLoadImage2.
function onLoadImage2_Callback(hObject, eventdata, handles)
% hObject    handle to onLoadImage2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


imageFullPath = getImagePath(); % private function to get the full path with UI file selector

image = imread(imageFullPath);
axes(handles.axes2);
imshow(image);

assignin('base','imageFullPath2',imageFullPath); %pass fullPathName to base workspace for data sharing between functions.



% --- Executes on button press in detectFacesBtn.
function detectFacesBtn_Callback(hObject, eventdata, handles)
% hObject    handle to detectFacesBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


image1FullPath = evalin('base','imageFullPath1'); %get the file path from base workspace.
image2FullPath = evalin('base','imageFullPath2'); %get the file path from base workspace.

[xCoord1,yCoord1,width1,height1,image1]=faceDetectionArea(image1FullPath);
[xCoord2,yCoord2,width2,height2,image2]=faceDetectionArea(image2FullPath);

if isEmpty(image1) || isEmpty(image2)
     msgbox('something had wrong while the face detactiong,please try again','Error message','error');
    return;
end
 
 faceImage1 = imcrop(image1,[xCoord1 yCoord1 width1 height1]);
 axes(handles.axes1);
 imshow(faceImage1);
 
 faceImage2 = imcrop(image2,[xCoord2 yCoord2 width2 height2]);
 axes(handles.axes2);
 imshow(faceImage2);


% --- Executes on button press in trackBtn.
function trackBtn_Callback(hObject, eventdata, handles)
% hObject    handle to trackBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Create the face detector object.
faceDetector = vision.CascadeObjectDetector();

% Create the point tracker object.
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

% Create the webcam object.
cam = webcam();

% Capture one frame to get its size.
videoFrame = snapshot(cam);
frameSize = size(videoFrame);

% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);








runLoop = true;
numPts = 0;
frameCount = 0;
recognizedFrameCount = 0;
twoConsecutiveFrames=[];
maxNumOfFrames = 2;

while runLoop && frameCount < maxNumOfFrames

    % Get the next frame.
    videoFrame = snapshot(cam);
    videoFrameGray = rgb2gray(videoFrame);
    frameCount = frameCount + 1;
    


    if numPts < 10 %if numPts smaller then 10 so we didn't recognize the face well and we want to detect it again or for the first time
        

        %if i doesn't recognize a face i will reset the twoConsecutiveFrames array and reset the counter. 
        twoConsecutiveFrames{1,1}=0;
        twoConsecutiveFrames{1,2}=0;
        recognizedFrameCount=0;
        
        % Detection mode.
        bbox = faceDetector.step(videoFrameGray);

        if ~isempty(bbox) % if we recognized a face
            
            
            
            % Find corner points inside the detected region.
            points = detectMinEigenFeatures(videoFrameGray, 'ROI', bbox(1, :));

            % Re-initialize the point tracker.
            xyPoints = points.Location; %get the x and y coords that build the face rectangle.
            numPts = size(xyPoints,1); % numPts get the num of points are located in the face
            release(pointTracker);
            initialize(pointTracker, xyPoints, videoFrameGray);

            % Save a copy of the points.
            oldPoints = xyPoints;

            % Convert the rectangle represented as [x, y, w, h] into an
            % M-by-2 matrix of [x,y] coordinates of the four corners. This
            % is needed to be able to transform the bounding box to display
            % the orientation of the face.
            bboxPoints = bbox2points(bbox(1, :)); %bboxPoints contain the four corners of the rectangle

            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bboxPolygon = reshape(bboxPoints', 1, []);

            % Display a bounding box around the detected face.
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);

            % Display detected corners.
            videoFrame = insertMarker(videoFrame, xyPoints, '+', 'Color', 'white');
        end

    else %numPts is bigger then 10 so we sure that we recognize the face and we want to start tracking on it. 
        % Tracking mode.
        

        
        [xyPoints, isFound] = step(pointTracker, videoFrameGray);
        visiblePoints = xyPoints(isFound, :);
        oldInliers = oldPoints(isFound, :);

        numPts = size(visiblePoints, 1);

        if numPts >= 10
            

            % Estimate the geometric transformation between the old points
            % and the new points.
            [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
                oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);

            % Apply the transformation to the bounding box.
            bboxPoints = transformPointsForward(xform, bboxPoints);

            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bboxPolygon = reshape(bboxPoints', 1, []);

            % Display a bounding box around the face being tracked.
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);

            % Display tracked points.
            videoFrame = insertMarker(videoFrame, visiblePoints, '+', 'Color', 'white');

            % Reset the points.
            oldPoints = visiblePoints;
            setPoints(pointTracker, oldPoints);
            
  
            %I always want to compare between two consecutive frames and i saved it
            %I always override the past frame to save memory space.  
            
            bboxes = step(faceDetector, videoFrameGray);
            modulo = mod(recognizedFrameCount,2); 
            if modulo ==0
                twoConsecutiveFrames{1,1}=videoFrameGray;
                twoConsecutiveFrames{2,1}=bboxes;
                %axes(handles.axes1);
                %imshow(faceImage);
            else
                twoConsecutiveFrames{1,2}=videoFrameGray;
                twoConsecutiveFrames{2,2}=bboxes;

                %axes(handles.axes2);
                %imshow(faceImage);
            end

            
            recognizedFrameCount =recognizedFrameCount+1;
        
 
        end

    end

    % Display the annotated video frame using the video player object.
    step(videoPlayer, videoFrame);

    % Check whether the video player window has been closed.
    runLoop = isOpen(videoPlayer);
end


% Clean up.

clear cam;
release(videoPlayer);
release(pointTracker);
release(faceDetector);


% --- Executes on button press in findDiffBtn.
function findDiffBtn_Callback(hObject, eventdata, handles)
% hObject    handle to findDiffBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the loaded images
image1=getimage(handles.axes1);
image2=getimage(handles.axes2);

%change the focus to axes3 and show the differences.
axes(handles.axes3);
imshowpair(image1,image2,'diff');

diffImage=getimage(handles.axes3);


% get the resolution rows and cola length
[rows1, columns1, numberOfColorChannels1] = size(image1);
[rows2, columns2, numberOfColorChannels2] = size(image2);

if rows1 ~= rows2 || columns1~= columns2
    msgbox('images are not at the same resolution','Error message','error');
    return;
    
end

%run all over the images pixels
for i=1:rows1
    
    
    
end

