function [ changedImage ] = drawAllFaceLines( pointsMatrix, originalImage )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if(isempty(pointsMatrix))
    errordlg('The user face is not recognized well - can not draw the face','File Error');
end

if(isempty(originalImage))
    errordlg('The user face is not recognized well - can not draw the face','File Error');
end

if(size(pointsMatrix)~= 74)
        errordlg('The user face is not recognized well','File Error');
end

%% selected points matrix
selectedPoints = [1,5,6,9,12,13,17,37,40,43,46,18,20,22,23,25,27,28,31,32,36,49,55];
selectedPointsSize = size(selectedPoints);
newPointsMatrix=zeros(2,selectedPointsSize(1,2));

for i=1:selectedPointsSize(1,2)
    
    newPointsMatrix(i,1) = pointsMatrix(selectedPoints(i),1);
    newPointsMatrix(i,2) = pointsMatrix(selectedPoints(i),2);
    
end




changedImage = originalImage;
figure;
imshow(changedImage);

for i=1:size(newPointsMatrix)
    for j=i+1:size(newPointsMatrix)
        
        %YDist = abs(pointsMatrix(i,2)- pointsMatrix(j,2));
        %XDist = abs(pointsMatrix(i,1)- pointsMatrix(j,1));
        hold on
        plot([newPointsMatrix(i,1) newPointsMatrix(j,1)],[newPointsMatrix(i,2) newPointsMatrix(j,2)],'Color','w','LineWidth',2)
        pause on
        pause(0.5);
        
        %rightEyeDist = sqrt((rEye_YDist)^2+(rEye_XDist)^2);
    end
    
end


end

