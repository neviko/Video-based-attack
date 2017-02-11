function [ xCoord,yCoord,width,height,image ] = faceDetectionArea(imageFullPath)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


%face recognation
faceDetector = vision.CascadeObjectDetector; %Create a detector object.

I = imread(imageFullPath);%Read input image.
 bboxes = step(faceDetector, I);%Detect faces. [x, y, width, height], x and y placed in the up-left corner.
 
%Annotate detected faces.
 IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
 imshow(IFaces), title('Detected faces');
 

 
 if size(bboxes)>1
    warndlg('more then one person in the image');
    return;
 end
 
 xCoord=bboxes(1);
 yCoord=bboxes(2);
 width = bboxes(3);
 height = bboxes(4);
 image = I;

end

