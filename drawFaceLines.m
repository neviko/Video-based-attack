function [ image ] = drawFaceLines(image,bbox)
if (isempty(image) || isempty(bbox))
    warndlg('image or face features are not exist');
    return;
end

%{
if (size(bbox,1 ~= 21))
    warndlg('face features are not find well');
    return;
end
%}

% bbox: bbox(:, 1: 4) is bounding box for face
%       bbox(:, 5: 8) is bounding box for left eye
%       bbox(:, 9:12) is bounding box for right eye
%       bbox(:,13:16) is bounding box for mouth
%       bbox(:,17:20) is bounding box for nose





% left eye
xLE=bbox(5)-0.5*bbox(7); % x position of the left eye
yLE= bbox(6)-0.5*bbox(8);% y position of the left eye


%right eye
xRE=bbox(9)-0.5*bbox(11); % x position of the left eye
yRE= bbox(10)-0.5*bbox(12);% y position of the left eye

hold on;

image = insertShape(image,'Line',[xLE xRE yLE yRE],'LineWidth',5,'Color','white');




