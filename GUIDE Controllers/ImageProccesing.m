function varargout = ImageProccesing(varargin)
% IMAGEPROCCESING MATLAB code for ImageProccesing.fig
%      IMAGEPROCCESING, by itself, creates a new IMAGEPROCCESING or raises the existing
%      singleton*.
%
%      H = IMAGEPROCCESING returns the handle to a new IMAGEPROCCESING or the handle to
%      the existing singleton*.
%
%      IMAGEPROCCESING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEPROCCESING.M with the given input arguments.
%
%      IMAGEPROCCESING('Property','Value',...) creates a new IMAGEPROCCESING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageProccesing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageProccesing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageProccesing

% Last Modified by GUIDE v2.5 10-Jun-2017 12:01:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageProccesing_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageProccesing_OutputFcn, ...
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


% --- Executes just before ImageProccesing is made visible.
function ImageProccesing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageProccesing (see VARARGIN)

% Choose default command line output for ImageProccesing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Load BG Image
setImageBG('C:\V-B-A-Github\Images\GUI Backgruonds\ip.jpg');
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

%load buttons images
h1=imread('C:\V-B-A-Github\Images\Buttons\folder.png');
h=imresize(h1, [90 150]);
set(handles.onLoadImage1,'CData',h);

hr=imread('C:\V-B-A-Github\Images\Buttons\camera.png');
hs=imresize(hr, [90 150]);
set(handles.CaptureImageBtn,'CData',hs);

hrev=imread('C:\V-B-A-Github\Images\Buttons\revert.png');
hr=imresize(hrev, [90 150]);
set(handles.revertBtn,'CData',hr);

%setImageBG('C:\V-B-A-Github\Images\GUI Backgruonds\tetisng.jpg');
%set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

set(handles.axes1IP,'visible', 'off');
set(handles.axes2IP,'visible', 'off');
set(handles.uitable2,'visible', 'off');



% --- Outputs from this function are returned to the command line.
function varargout = ImageProccesing_OutputFcn(hObject, eventdata, handles) 
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

image1=getimage(handles.axes1IP); 
image2=getimage(handles.axes2IP);
currImage=[];
set(handles.uitable2,'visible', 'off');

if (isempty(image1))
    axes(handles.axes1IP); %set focus by tag name
    currImage = 'left';
    
elseif(isempty(image2))
    axes(handles.axes2IP); %set focus by tag name)
    currImage = 'right';
    
else % two images loaded
    % Construct a questdlg with three options
    choice = questdlg('Two images are already loaded, Do you want to override one of them?', ...
        'Override image', ...
        'Override left image','Override right image','No thank you','No thank you');
    % Handle response
    switch choice
        case 'Override left image'
            axes(handles.axes1IP);
            cla(handles.axes1IP,'reset'); % clear the current image from the axis
            currImage = 'left';
            
        case 'Override right image'
            axes(handles.axes2IP);
            cla(handles.axes2IP,'reset'); % clear the current image from the axis
            currImage = 'right';
            
        case 'No thank you'
            return;
    end
end

% private function to get the full path with UI file selector
imageFullPath = getImagePath(); 
if(isempty(imageFullPath))
    return;
end

image = imread(imageFullPath); %read image
imshow(image); % dispaly the image in the axes
set(handles.axes1IP,'visible', 'off');

if(strcmp(currImage,'left') == 1)
    assignin('base','leftImage',image); %pass image to base workspace for data sharing between functions.

elseif(strcmp(currImage,'right') == 1)
    assignin('base','rightImage',image); %pass image to base workspace for data sharing between functions.
    
end



% --- Executes on button press in findDiffBtn.
function findDiffBtn_Callback(hObject, eventdata, handles)
% hObject    handle to findDiffBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%get the loaded images from the txes
image1=getimage(handles.axes1IP); 
image2=getimage(handles.axes2IP);

if(isempty(image1) || isempty(image2))
    msgbox('For using Find differences feature you must load two images','Error message','error');
    return;
end

set(handles.uitable2,'visible', 'off');


% get the pixels rows and cols length
[rows1, columns1, numberOfColorChannels1] = size(image1);
[rows2, columns2, numberOfColorChannels2] = size(image2);

if rows1 ~= rows2 || columns1~= columns2
    msgbox('images are not at the same size (Probably croped)','Error message','error');
    return;
    
end

%change the focus to axes3 and show the differences.
%axes(handles.axes3);
diffImage = imabsdiff(image1,image2);

%% Collage
newImageSize = [720,1280]; %change the image size
% get the new sizes 
newSizeA = newImageSize./[2,1];
newSizeB = newImageSize./[2,2];
newSizeC = newImageSize./[2,2];

% resize the images and stick together
% place a in the top half
% place b in the bottom left
% place c in the bottom right 
collImg = [imresize(diffImage,newSizeA);imresize(image2,newSizeB),imresize(image1,newSizeC)];

% display the image
figure('Name','Image Differences'),imshow(collImg);
set(gcf,'units','normalized','outerposition',[0 0 1 1]) % maximize current figure


% --- Executes on button press in CaptureImageBtn.
function CaptureImageBtn_Callback(hObject, eventdata, handles)
% hObject    handle to CaptureImageBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.uitable2,'visible', 'off');


image1=getimage(handles.axes1IP); 
image2=getimage(handles.axes2IP);
currImage=[];

if (isempty(image1))
    axes(handles.axes1IP); %set focus by tag name
    currImage= 'left';
    
elseif(isempty(image2))
    axes(handles.axes2IP); %set focus by tag name)
    currImage= 'right';
    
    
else % two images loaded
    % Construct a questdlg with three options
    choice = questdlg('Two images are already loaded, Do you want to override one of them?', ...
        'Override image', ...
        'Override left image','Override right image','No thank you','No thank you');
    % Handle response
    switch choice
        case 'Override left image'
            axes(handles.axes1IP);
            cla(handles.axes1IP,'reset'); % clear the current image from the axis
            currImage= 'left';
            
        case 'Override right image'
            axes(handles.axes2IP);
            cla(handles.axes2IP,'reset'); % clear the current image from the axis
            currImage= 'right';
            
        case 'No thank you'
            return;
    end
end

% taking a snapshot
cam1 = webcam; %open webcam
preview(cam1); %display webcam
pause(5);
img = snapshot(cam1);
closePreview(cam1);
imshow(img);
delete(cam1);

if(strcmp(currImage,'left') == 1)
    assignin('base','leftImage',img); %pass fullPathName to base workspace for data sharing between functions.

elseif(strcmp(currImage,'right') == 1)
    assignin('base','rightImage',img); %pass fullPathName to base workspace for data sharing between functions.
    
end

function detectFacesBtn_Callback(hObject, eventdata, handles)

set(handles.uitable2,'visible', 'off');

%get images from axes
image1=getimage(handles.axes1IP); 
image2=getimage(handles.axes2IP);

if (isempty(image1) && isempty(image2))
     msgbox('For using "Detect faces" feature you must load at least one image','Error message','error');
    return;
end

if ( ~isempty(image1))
    %croping the images to display only the detected faces and display them on the axes
    axes(handles.axes1IP); %left axis focus
    

    [xCoord1,yCoord1,width1,height1,image1]=faceDetectionArea(image1);
    if(width1 ~= 0 && height1~=0)
        faceImage1 = imcrop(image1,[xCoord1 yCoord1 width1 height1]);
        imshow(faceImage1), title('Detected faces'); 
    end
      
end


if ( ~isempty(image2))   
    %croping the images to display only the detected faces and display them on the axes 
    axes(handles.axes2IP);%right axis focus
    [xCoord2,yCoord2,width2,height2,image2]=faceDetectionArea(image2);
    if(width1 ~= 0 && height1~=0)
        faceImage2 = imcrop(image2,[xCoord2 yCoord2 width2 height2]);  
        imshow(faceImage2), title('Detected faces');  
    end   
end



function detectFaceFeaturesBtn_Callback(hObject, eventdata, handles)

set(handles.uitable2,'visible', 'off');

%get images from axes
image1=getimage(handles.axes1IP); 
image2=getimage(handles.axes2IP);

if (isempty(image1) && isempty(image2))
     msgbox('For using "Detect face features" feature you must load at least one image','Error message','error');
    return;
end

reqToolboxes = {'Computer Vision System Toolbox', 'Image Processing Toolbox'};
if( ~checkToolboxes(reqToolboxes) )%If the software don't have the Image Processing Toolbox return error message
 error('detectFaceParts requires: Computer Vision System Toolbox and Image Processing Toolbox. Please install these toolboxes.');
end
x=0;%choice flag

if(~isempty(image1) && ~isempty(image2))
    % Construct a questdlg with three options
    choice = questdlg('The system detected two loaded images, On which image do you want to run this feature?', ...
        'Choose image', ...
        'Only left image','Only right image','Both images','No thank you');
    % Handle response
    switch choice
        case 'Only left image'
            axes(handles.axes1IP);
            x=1;
        case 'Only right image'
            axes(handles.axes2IP);
            x=2;
        case 'Both images'
            x=3;
    end
end


if(~isempty(image1) && (x==1 || x==3 || x==0))
    detector = buildDetector(); %call to buildDetector function that initialize the detector object by several criteria %because it's the first time that the function called there are no arguments.
    [bbox bbimg faces bbfaces] = detectFaceParts(detector,image1,2);

    %bbox 1-5 - left eye
    %bbox 6-10 - right eye
    %bbox 11-15 - mouth
    %bbox 16-20 - left eye


    %figure;imshow(bbimg);
    for i=1:size(bbfaces,1)
         %hold on;
         img= drawFaceLines(image1,bbox);
         bbfaces{i} = insertShape(bbfaces{i},'Line',[2145 1111 2000 2000],'LineWidth',2,'Color','blue');
         axes(handles.axes1IP);%left axis focus
         cla(handles.axes1IP,'reset');
         imshow(bbfaces{i});
    end
end


if(~isempty(image2) && (x==2 || x==3 || x==0))
    detector = buildDetector(); %call to buildDetector function that initialize the detector object by several criteria %because it's the first time that the function called there are no arguments.
    [bbox bbimg faces bbfaces] = detectFaceParts(detector,image2,2);

    %bbox 1-5 - left eye
    %bbox 6-10 - right eye
    %bbox 11-15 - mouth
    %bbox 16-20 - left eye

    %figure;imshow(bbimg);
    for i=1:size(bbfaces,1)
         %hold on;
         img= drawFaceLines(image2,bbox);
         bbfaces{i} = insertShape(bbfaces{i},'Line',[2145 1111 2000 2000],'LineWidth',2,'Color','blue');
         axes(handles.axes2IP);%right axis focus
         cla(handles.axes2IP,'reset');
         imshow(bbfaces{i});
    end    
end


function accfacefeaturesDetectionBtn_Callback(hObject, eventdata, handles)

set(handles.uitable2,'visible', 'off');

%get images from axes
image1=getimage(handles.axes1IP); 
image2=getimage(handles.axes2IP);

if (isempty(image1) && isempty(image2))
     msgbox('For using "Accurate face features detection" feature you must load at least one image','Error message','error');
    return;
end

x=0;
if(~isempty(image1) && ~isempty(image2))
    % Construct a questdlg with three options
    choice = questdlg('The system detected two loaded images, On which image do you want to run this feature?', ...
        'Choose image', ...
        'Only left image','Only right image','Both images','No thank you');
    % Handle response
    switch choice
        case 'Only left image'
            axes(handles.axes1IP);
            x=1;
        case 'Only right image'
            axes(handles.axes2IP);
            x=2;
        case 'Both images'
            x=3;
    end
end


if(~isempty(image1) && (x==1 || x==3 || x==0))
    
    axes(handles.axes1IP);
    [shape,v_points] = imageAccDetection(image1);
     %cla(handles.axes1IP,'reset');
     axes(handles.axes1IP);
     plot(shape(v_points,1), shape(v_points',2),'.r','MarkerSize',8);
     %imshow(editedImage);


end


if(~isempty(image2) && (x==2 || x==3 || x==0))
    axes(handles.axes2IP); 
    [shape,v_points] = imageAccDetection(image2);
     axes(handles.axes2IP);
     plot(shape(v_points,1), shape(v_points',2),'.r','MarkerSize',8);
    
end





function gridBtn_Callback(hObject, eventdata, handles)

set(handles.uitable2,'visible', 'off');

%get images from axes
image1=getimage(handles.axes1IP); 
image2=getimage(handles.axes2IP);

if (isempty(image1) && isempty(image2))
     msgbox('For using "build Grid" feature you must load at least one image','Error message','error');
    return;
end

x=0;
if(~isempty(image1) && ~isempty(image2))
    % Construct a questdlg with three options
    choice = questdlg('The system detected two loaded images, On which image do you want to run this feature?', ...
        'Choose image', ...
        'Only left image','Only right image','Both images','No thank you');
    % Handle response
    switch choice
        case 'Only left image'
            axes(handles.axes1IP);
            x=1;
        case 'Only right image'
            axes(handles.axes2IP);
            x=2;
        case 'Both images'
            x=3;
    end
end


if(~isempty(image1) && (x==1 || x==3 || x==0))
    
    axes(handles.axes1IP);
    [pointsMatrix,v_points] = imageAccDetection(image1);
     %cla(handles.axes1IP,'reset');
     axes(handles.axes1IP);
     disMatrix = calculateDistances(pointsMatrix,[],false);
    
    % Construct a questdlg with three options
    choice = questdlg('Dear user, do you want to watch the distances plot of the left image?', ...
        'Choose image', ...
        'Yes','No','No thank you');
    
    % Handle response
    switch choice
        case 'Yes'                     
            set(handles.uitable2,'visible', 'on');
            t= uitable(handles.uitable2);
            t.Data = disMatrix;
            t.ColumnName = {'Name','Distance-L'};           
        case 'No'
                   
    end

end


if(~isempty(image2) && (x==2 || x==3 || x==0))
    axes(handles.axes2IP);
    [pointsMatrix,v_points] = imageAccDetection(image2);
     %cla(handles.axes1IP,'reset');
     axes(handles.axes2IP);
     %[newImage]=drawFaceFeatures(pointsMatrix,image1);
     disMatrix2 = calculateDistances(pointsMatrix,[],false);
     %plot(shape(v_points,1), shape(v_points',2),'.r','MarkerSize',10);
     %imshow(editedImage);
    
     
     % Construct a questdlg with three options
    choice = questdlg('Dear user, do you want to watch the distances plot of the right image?', ...
        'Choose image', ...
        'Yes','No','No thank you');
    % Handle response
    switch choice
        case 'Yes' 
            set(handles.uitable2,'visible', 'on'); %table visible
            %table = cell2table(disMatrix2);            
            t= uitable(handles.uitable2);
            
            if (x==3) % both images
                t.ColumnName = {'Name','Distance-L','Distance-R'};
                newMatrix =disMatrix; %new matrix with the first data
                newMatrix(:,3) = disMatrix2(:,2);% adding all disMatrix2 dis column to the new matrix
                t.Data = newMatrix;
                
            else
                t.ColumnName = {'Name','Distance-R'};
                t.Data = disMatrix2;
                
            end
            
            
        case 'No'
            
        
    end
     
     
end



function revertBtn_Callback(hObject, eventdata, handles)
    
    set(handles.uitable2,'visible', 'off');


   leftImage = evalin('base','leftImage'); %pass fullPathName to base workspace for data sharing between functions.
   rightImage = evalin('base','rightImage');
   
   
  if(~isempty(leftImage))
      axes(handles.axes1IP);
      imshow(leftImage);
  end
   
   
    
  if(~isempty(rightImage))
      axes(handles.axes2IP);
      imshow(rightImage);
  end
    

function gridDemoBtn_Callback(hObject, eventdata, handles)

figure;
imagePath = 'C:\V-B-A-Github\Images\girl.jpg';
if(isempty(imagePath))
    return;
end
image = imread(imagePath);
imshow(image);
[pointsMatrix,v_points] = imageAccDetection(image);    
disMatrix = calculateDistances(pointsMatrix,[],true);





