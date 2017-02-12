function [ xCoord,yCoord,width,height,image] = eyesDetectionArea(imageFullPath)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

I = imread(imageFullPath);%Read input image.

eyesDetect = vision.CascadeObjectDetector('EyePairBig');
bboxes=step(eyesDetect,I);
%hold on
%rectangle('Position',bboxes,'LineWidth',4,'LineStyle','-','EdgeColor','b');



if size(bboxes)>1
    warndlg('the system were detect more then one person in the image');
    return;
 end
 
 xCoord=bboxes(1);
 yCoord=bboxes(2);
 width = bboxes(3);
 height = bboxes(4);
 image = I;


end

