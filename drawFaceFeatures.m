function [ changedImage ] = drawFaceFeatures( pointsMatrix,originalImage )
%UNTITLED4 Summary of this function goes here
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


changedImage = originalImage;
f = figure;
imshow(changedImage);
%% calculate distances area
%{
    1 - 17 : face shape
    18 - 22 : user right eye-brow 
    23 - 27 : user left eye-brow
    28 - 31 : vertical nose
    32 - 36 : horizontal nose
    37 - 42 : user right eye - top right 37 top left 40
    43 - 48 : user left eye - top right 43 top left 46
    49 - 68 : user mouth
%}

%draw the face shape
for i=1:16
    hold on
    plot([pointsMatrix(i,1) pointsMatrix(i+1,1)],[pointsMatrix(i,2) pointsMatrix(i+1,2)],'Color','w','LineWidth',2)
end

%draw the right eye brow
for i=18:21
    hold on
    plot([pointsMatrix(i,1) pointsMatrix(i+1,1)],[pointsMatrix(i,2) pointsMatrix(i+1,2)],'Color','w','LineWidth',2)
end

%draw the left eye brow
for i=23:26
    hold on
    plot([pointsMatrix(i,1) pointsMatrix(i+1,1)],[pointsMatrix(i,2) pointsMatrix(i+1,2)],'Color','w','LineWidth',2)
end

%draw vertical nose
for i=28:30
    plot([pointsMatrix(i,1) pointsMatrix(i+1,1)],[pointsMatrix(i,2) pointsMatrix(i+1,2)],'Color','w','LineWidth',2)
end

%draw horizontal nose
for i=32:35
    plot([pointsMatrix(i,1) pointsMatrix(i+1,1)],[pointsMatrix(i,2) pointsMatrix(i+1,2)],'Color','w','LineWidth',2)
end


%draw nose triangle shape
plot([pointsMatrix(28,1) pointsMatrix(32,1)],[pointsMatrix(28,2) pointsMatrix(32,2)],'Color','w','LineWidth',2)
plot([pointsMatrix(28,1) pointsMatrix(36,1)],[pointsMatrix(28,2) pointsMatrix(36,2)],'Color','w','LineWidth',2)


%draw right eye
for i=37:41
    plot([pointsMatrix(i,1) pointsMatrix(i+1,1)],[pointsMatrix(i,2) pointsMatrix(i+1,2)],'Color','w','LineWidth',2)
end
plot([pointsMatrix(37,1) pointsMatrix(42,1)],[pointsMatrix(37,2) pointsMatrix(42,2)],'Color','w','LineWidth',2)

%draw left eye
for i=43:47
    plot([pointsMatrix(i,1) pointsMatrix(i+1,1)],[pointsMatrix(i,2) pointsMatrix(i+1,2)],'Color','w','LineWidth',2)
end
plot([pointsMatrix(43,1) pointsMatrix(48,1)],[pointsMatrix(43,2) pointsMatrix(48,2)],'Color','w','LineWidth',2)

%draw outside lips
for i=49:59
    plot([pointsMatrix(i,1) pointsMatrix(i+1,1)],[pointsMatrix(i,2) pointsMatrix(i+1,2)],'Color','w','LineWidth',2)
end
plot([pointsMatrix(49,1) pointsMatrix(60,1)],[pointsMatrix(49,2) pointsMatrix(60,2)],'Color','w','LineWidth',2)

%draw inside lips
for i=61:67
    plot([pointsMatrix(i,1) pointsMatrix(i+1,1)],[pointsMatrix(i,2) pointsMatrix(i+1,2)],'Color','w','LineWidth',2)
end
plot([pointsMatrix(61,1) pointsMatrix(68,1)],[pointsMatrix(61,2) pointsMatrix(68,2)],'Color','w','LineWidth',2)




end

