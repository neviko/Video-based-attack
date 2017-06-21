function varargout = detectFaceTampering(varargin)

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


imageFullPath = getImagePath(); % private function to get the full path with UI file selector
if(isempty(imageFullPath))
    return;
end

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
if(isempty(imageFullPath))
    return;
end
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

%if isEmpty(image1) || isEmpty(image2)
 %    msgbox('something had wrong while the face detactiong,please try again','Error message','error');
 %   return;
%end
 
%croping the images to display only the detected faces and display them on the axes 
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
maxNumOfFrames = 100;

while runLoop && frameCount < maxNumOfFrames

    % Get the next frame.
    videoFrame = snapshot(cam); %take a video snapshot
    videoFrameGray = rgb2gray(videoFrame); % convert the frame to gray scale image frame 
    frameCount = frameCount + 1;
    


    if numPts < 10 %if numPts smaller then 10 so we didn't recognize the face well and we want to detect it again or for the first time
        

        %if i doesn't recognize a face i will reset the twoConsecutiveFrames array and reset the counter. 
        twoConsecutiveFrames{1,1}=0;
        twoConsecutiveFrames{1,2}=0;
        recognizedFrameCount=0;
        
        % Detection mode.
        bbox = faceDetector.step(videoFrameGray); %detect faces
        hold on
        eyesDetect = vision.CascadeObjectDetector('EyePairBig'); %detect eyes area 
        step(eyesDetect,videoFrameGray); %set the eye detection on the videoFrameGray
        

        if ~isempty(bbox) % if we recognized at least one face
            
            
            
            % Find corner points inside the detected face region.
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
            
            hold on
            eyesDetect = vision.CascadeObjectDetector('EyePairBig');
            step(eyesDetect,videoFrameGray);

            % Display detected corners on the original snapshot.
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
            hold on
            eyesDetect = vision.CascadeObjectDetector('EyePairBig');
            step(eyesDetect,videoFrameGray);
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
    hold on
    EyeDetect = vision.CascadeObjectDetector('EyePairBig');
    step(EyeDetect,videoFrame);
    

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

%get the loaded images from the txes
image1=getimage(handles.axes1); 
image2=getimage(handles.axes2);

%change the focus to axes3 and show the differences.
axes(handles.axes3);
imshowpair(image1,image2,'diff');

diffImage=getimage(handles.axes3);


% get the pixels rows and cols length
[rows1, columns1, numberOfColorChannels1] = size(image1);
[rows2, columns2, numberOfColorChannels2] = size(image2);

if rows1 ~= rows2 || columns1~= columns2
    msgbox('images are not at the same resolution','Error message','error');
    return;
    
end


% --- Executes on button press in detectEyesBtn.
function detectEyesBtn_Callback(hObject, eventdata, handles)

image1FullPath = evalin('base','imageFullPath1'); %get the file path from base workspace.
image2FullPath = evalin('base','imageFullPath2'); %get the file path from base workspace.

[xCoord1,yCoord1,width1,height1,image1]=eyesDetectionArea(image1FullPath);
[xCoord2,yCoord2,width2,height2,image2]=eyesDetectionArea(image2FullPath);

%if isEmpty(image1) || isEmpty(image2)
 %    msgbox('something had wrong while the face detactiong,please try again','Error message','error');
 %   return;
%end
 
 faceImage1 = imcrop(image1,[xCoord1 yCoord1 width1 height1]);
 axes(handles.axes1);
 imshow(faceImage1);
 
 faceImage2 = imcrop(image2,[xCoord2 yCoord2 width2 height2]);
 axes(handles.axes2);
 imshow(faceImage2);


% --- Executes on button press in DetectFeatures.
function DetectFeatures_Callback(hObject, eventdata, handles)

reqToolboxes = {'Computer Vision System Toolbox', 'Image Processing Toolbox'};
if( ~checkToolboxes(reqToolboxes) )%If the software don't have the Image Processing Toolbox return error message
 error('detectFaceParts requires: Computer Vision System Toolbox and Image Processing Toolbox. Please install these toolboxes.');
end

img = getimage(handles.axes1); % load image from axes1

detector = buildDetector(); %call to buildDetector function that initialize the detector object by several criteria %because it's the first time that the function called there are no arguments.
[bbox bbimg faces bbfaces] = detectFaceParts(detector,img,2);

%bbox 1-5 - left eye
%bbox 6-10 - right eye
%bbox 11-15 - mouth
%bbox 16-20 - left eye


%figure;imshow(bbimg);
for i=1:size(bbfaces,1)
     %hold on;
     img= drawFaceLines(img,bbox);
     bbfaces{i} = insertShape(bbfaces{i},'Line',[2145 1111 2000 2000],'LineWidth',2,'Color','blue');
     figure;imshow(bbfaces{i});
     
 
end

% Please uncoment to run demonstration of detectRotFaceParts
%{
 img = imrotate(img,180);
 detector = buildDetector(2,2);
 [fp bbimg faces bbfaces] = detectRotFaceParts(detector,img,2,15);
 
 %bbFaces - contain the face with the detected features

 
 %figure;imshow(bbimg);
 for i=1:size(bbfaces,1)
  figure;imshow(bbfaces{i});
 end
%}



















% --- Executes on button press in accurateTrackingBtn.
function accurateTrackingBtn_Callback(hObject, eventdata, handles)
% hObject    handle to accurateTrackingBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    img = getimage(handles.axes1); %load image from axe1
     

    [imageChanged,pointsMatrix]=face_track(img);%call to face recognize method
    
    img = getimage(handles.axes1);
    %imageFaceLines = drawAllFaceLines(pointsMatrix,img);
    [newImage]=drawFaceFeatures(pointsMatrix,img); %call to draw face lines method
    disMatrix = calculateDistances(pointsMatrix,newImage); 
    
    img2 = getimage(handles.axes2);
    [imageChanged,pointsMatrix]=face_track(img2);
    %imageFaceLines = drawAllFaceLines(pointsMatrix,img);
    [newImage2]=drawFaceFeatures(pointsMatrix,img2);
    disMatrix2 = calculateDistances(pointsMatrix,newImage);
    
    [isSamePerson,diffSpatioArr]=isPersonChanged(disMatrix,disMatrix2,0.01);
    %function [ isChanged,diffSpatioArr ] = isPersonChanged( disMatrix1,disMatrix2,tracehold )

    
    %axes(handles.axes2);
    imshow(imageChanged);
    % Check whether the video player window has been closed.
    %runLoop = isOpen(videoPlayer);



% Clean up.


% --- Executes when onLoadImage is resized.
function onLoadImage_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to onLoadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
