function [ xCoord,yCoord,width,height,image] = faceDetectionArea(image)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


%face recognation
faceDetector = vision.CascadeObjectDetector; %Create a detector object.

I = image;%Read input image.
 bboxes = step(faceDetector, I);%Detect faces. [x, y, width, height], x and y placed in the up-left corner.
 
%Annotate detected faces.
 IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'face');
 %imshow(IFaces), title('Detected faces');
 

 
 if isempty(bboxes)
    warndlg('The system did not recognize any person in the image');
    xCoord= 0;
    yCoord=0;
    width = 0;
    height = 0;
    image = I;
    return;
 
 elseif size(bboxes)> 1
    warndlg('The system detected more then 1 person in the image');
    xCoord= 0;
    yCoord=0;
    width = 0;
    height = 0;
    image = I;
    return;
 end
 
 xCoord=bboxes(1);
 yCoord=bboxes(2);
 width = bboxes(3);
 height = bboxes(4);
 image = I;

end

