% buildDetector: build face parts detector object
% 
% detector = buildDetector( thresholdFace, thresholdParts, stdsize )
%
%Output parameter:
% detector: built detector object
%
%
%Input parameters:
% thresholdFace (optional): MergeThreshold for face detector (Default: 1)
% thresholdParts (optional): MergeThreshold for face parts detector (Default: 1)
% stdsize (optional): size of normalized face (Default: 176)
%
%
%Example:
% detector = buildDetector();
% img = imread('img.jpg');
% [bbbox bbimg] = detectFaceParts(detector,img);
%
%
%Version: 20120529

function detector = buildDetector(thresholdFace, thresholdParts, stdsize)

% nargin is the number of input arguments
%define the data if no arguments are inserted.
if( nargin < 1 )
 thresholdFace = 1; %MergeThreshold for face detector
end

if( nargin < 2 )
 thresholdParts = 1; %MergeThreshold for face parts detector
end

if( nargin < 3 )
 stdsize = 176; %size of normalized face 
end

%%initilize the detector object
nameDetector = {'LeftEye'; 'RightEye'; 'Mouth'; 'Nose'; }; %Detector names array
mins = [[12 18]; [12 18]; [15 25]; [15 18]; ]; %sizes of each detector



detector.stdsize = stdsize; %set the stdSize value in detector object
detector.detector = cell(5,1);
for k=1:4
 minSize = int32([stdsize/5 stdsize/5]); %detected object new min size
 minSize = [max(minSize(1),mins(k,1)), max(minSize(2),mins(k,2))]; %minSize have the max size between the stdSize/5 and mins array cell data
 detector.detector{k} = vision.CascadeObjectDetector(char(nameDetector(k)), 'MergeThreshold', thresholdParts, 'MinSize', minSize);% detect the k item from namedetector array considering the minSize, we set all the data to the detector object
end

detector.detector{5} = vision.CascadeObjectDetector('FrontalFaceCART', 'MergeThreshold', thresholdFace);
