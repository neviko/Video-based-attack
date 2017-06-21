function [ xCoord,yCoord,width,height,i ] = faceDetectionFromImage(image)


%face recognation
faceDetector = vision.CascadeObjectDetector; %Create a detector object.

bboxes = step(faceDetector, image);%Detect faces. [x, y, width, height], x and y placed in the up-left corner.
 
%Annotate detected faces.
 if size(bboxex) ==1
 IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
 imshow(IFaces), title('Detected faces');
 

 else
    warndlg('must be only one person in the image');
    return;
 end
 
 xCoord=bboxes(1);
 yCoord=bboxes(2);
 width = bboxes(3);
 height = bboxes(4);
 i = image;

end