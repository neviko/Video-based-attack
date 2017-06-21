function [ distancesMatrix ] = calculateDistances( pointsMatrix,image,isDeley)
%it's almost always found 70 points, i need to check the length from some arbitary points(todo) 

%if the array is empty or it length is different then 68 (not accurate recognize the face)
if(isempty(pointsMatrix))
    errordlg('The user face is not recognized well','File Error');
end
if(size(pointsMatrix)~= 74)
        errordlg('The user face is not recognized well','File Error');

end

deleyInSec = 0.35;
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
    69 - 70 : cheecks
    71 - 72 : upeer cheeks
%}
%The distances has been calculated with pitagoras formula : sqrt((y2-y1)^2+(x2-x1)^2) Where (x1,y1) and (x2,y2) are coordinates of two pixels
if( ~isempty(image))
    figure('Name','Grid Demo');%create a new figure
    set(gcf,'units','normalized','outerposition',[0 0 1 1])% maximize 
    imshow(image);
    hold on
end


distancesMatrix=cell(0,2); %create a new array of distances

%right eye distance
rightEyeDist = calculateDistancesHelper(pointsMatrix,37,40,false,isDeley);
distancesMatrix{end+1,1} = 'rightEyeDist';
distancesMatrix{end,2} = rightEyeDist;
%distancesMatrix(end+1,2) = 'rightEyeDist';

%left eye distance
leftEyeDist = calculateDistancesHelper(pointsMatrix,43,46,false,isDeley);
distancesMatrix{end+1,1} ='leftEyeDist';
distancesMatrix{end,2} = leftEyeDist;


%right eye-brow distance
rightEyeBrowDist = calculateDistancesHelper(pointsMatrix,18,22,true,isDeley);
distancesMatrix{end+1,1} ='rightEyeBrowDist';
distancesMatrix{end,2} =rightEyeBrowDist;

%left eye-brow distance
leftEyeBrowDist = calculateDistancesHelper(pointsMatrix,23,27,true,isDeley);
distancesMatrix{end+1,1} ='leftEyeBrowDist';
distancesMatrix{end,2} =leftEyeBrowDist;

%nose vertical distance
verticalNoseDist = calculateDistancesHelper(pointsMatrix,28,34,true,isDeley);
distancesMatrix{end+1,1} = 'verticalNoseDist';
distancesMatrix{end,2} = verticalNoseDist;


%nose Horizontal distance
HorizontalNoseDist = calculateDistancesHelper(pointsMatrix,32,36,true,isDeley);
distancesMatrix{end+1,1} = 'HorizontalNoseDist';
distancesMatrix{end,2} = HorizontalNoseDist;

%mouth edges distance
mouthDist = calculateDistancesHelper(pointsMatrix,49,55,true,isDeley);
distancesMatrix{end+1,1} = 'mouthDist';
distancesMatrix{end,2} = mouthDist;

%distance between the outside points of eyes( right eye - right point to left eye- left point)
eyesLongDist = calculateDistancesHelper(pointsMatrix,37,46,false,isDeley);
distancesMatrix{end+1,1} = 'eyesLongDist';
distancesMatrix{end,2} = eyesLongDist;


%distance between the inside points of eyes( right eye - right point to left eye- left point)
eyesShortDist = calculateDistancesHelper(pointsMatrix,40,43,false,isDeley);
distancesMatrix{end+1,1} = 'eyesShortDist';
distancesMatrix{end,2} = eyesShortDist;


%Upper lip thickness
upperLipDist = calculateDistancesHelper(pointsMatrix,52,63,true,isDeley);
distancesMatrix{end+1,1} = 'upperLipDist';
distancesMatrix{end,2} = upperLipDist;

%Lower lip thickness
lowerLipDist = calculateDistancesHelper(pointsMatrix,58,67,true,isDeley);
distancesMatrix{end+1,1} = 'lowerLipDist';
distancesMatrix{end,2} = lowerLipDist;

%inside right eye to start of the nose
insRightEyeToStartNose = calculateDistancesHelper(pointsMatrix,40,28,true,isDeley);
distancesMatrix{end+1,1} = 'insRightEyeToStartNose';
distancesMatrix{end,2} = insRightEyeToStartNose;

%inside left eye to start of the nose
insLeftEyeToStartNose = calculateDistancesHelper(pointsMatrix,43,28,true,isDeley);
distancesMatrix{end+1,1} = 'insLeftEyeToStartNose';
distancesMatrix{end,2} = insLeftEyeToStartNose;

%outside right eye to the middle of the nose
outRightEyeToMidNose = calculateDistancesHelper(pointsMatrix,37,30,false,isDeley);
distancesMatrix{end+1,1} = 'outRightEyeToMidNose';
distancesMatrix{end,2} = outRightEyeToMidNose;

%outside left eye to the middle of the nose
outLeftEyeToMidNose = calculateDistancesHelper(pointsMatrix,46,30,false,isDeley);
distancesMatrix{end+1,1} = 'outLeftEyeToMidNose';
distancesMatrix{end,2} = outLeftEyeToMidNose;

%outside right eye to the right up chick
out_R_EyeTo_RP_Nose = calculateDistancesHelper(pointsMatrix,37,71,true,isDeley);
distancesMatrix{end+1,1} = 'out_R_EyeTo_RP_Nose';
distancesMatrix{end,2} = out_R_EyeTo_RP_Nose;


%right cheek to right point nose
R_cheek_to_R_nose = calculateDistancesHelper(pointsMatrix,71,32,true,isDeley);
distancesMatrix{end+1,1} = 'R_cheek_to_R_nose';
distancesMatrix{end,2} = R_cheek_to_R_nose;


%outside left eye to the left up chick
out_L_EyeTo_LP_Nose = calculateDistancesHelper(pointsMatrix,46,72,true,isDeley);
distancesMatrix{end+1,1} = 'out_L_EyeTo_LP_Nose';
distancesMatrix{end,2} = out_L_EyeTo_LP_Nose;

%left cheek to left point nose
L_cheek_to_L_nose = calculateDistancesHelper(pointsMatrix,72,36,true,isDeley);
distancesMatrix{end+1,1} = 'L_cheek_to_L_nose';
distancesMatrix{end,2} = L_cheek_to_L_nose;

% start of the nose to up right cheek
nose_28_to_R_upCheek = calculateDistancesHelper(pointsMatrix,28,71,true,isDeley);
distancesMatrix{end+1,1} = 'nose_28_to_R_upCheek';
distancesMatrix{end,2} = nose_28_to_R_upCheek;

% start of the nose to up left cheek
nose_28_to_L_upCheek = calculateDistancesHelper(pointsMatrix,28,72,true,isDeley);
distancesMatrix{end+1,1} = 'nose_28_to_L_upCheek';
distancesMatrix{end,2} = nose_28_to_L_upCheek;

%right ear to outside right eye
rightEarToOutRightEye = calculateDistancesHelper(pointsMatrix,2,37,true,isDeley);
distancesMatrix{end+1,1} = 'rightEarToOutRightEye';
distancesMatrix{end,2} = rightEarToOutRightEye;


%left ear to outside left eye
leftEarToOutLeftEye = calculateDistancesHelper(pointsMatrix,16,46,true,isDeley);
distancesMatrix{end+1,1} = 'leftEarToOutLeftEye';
distancesMatrix{end,2} = leftEarToOutLeftEye;


%right ear to right cheek
rightEarToRightCheek = calculateDistancesHelper(pointsMatrix,2,69,true,isDeley);
distancesMatrix{end+1,1} = 'rightEarToRightCheek';
distancesMatrix{end,2} = rightEarToRightCheek;

%left ear to left cheek
leftEarToLeftCheek = calculateDistancesHelper(pointsMatrix,16,70,true,isDeley);
distancesMatrix{end+1,1} = 'leftEarToLeftCheek';
distancesMatrix{end,2} = leftEarToLeftCheek;


%right cheek to the right point of the nose
R_cheek2_to_R_nose = calculateDistancesHelper(pointsMatrix,32,69,true,isDeley);
distancesMatrix{end+1,1} = 'R_cheek2_to_R_nose';
distancesMatrix{end,2} = R_cheek2_to_R_nose;

%left cheek to the left point of the nose
L_cheek2_to_L_nose = calculateDistancesHelper(pointsMatrix,36,70,true,isDeley);
distancesMatrix{end+1,1} = 'L_cheek2_to_L_nose';
distancesMatrix{end,2} = L_cheek2_to_L_nose;

%right down cheek to the right up cheek
R_downCheek_to_R_upcheek = calculateDistancesHelper(pointsMatrix,69,71,true,isDeley);
distancesMatrix{end+1,1} = 'R_downCheek_to_R_upcheek';
distancesMatrix{end,2} = R_downCheek_to_R_upcheek;

%left down cheek to the left up cheek
L_downCheek_to_L_upcheek = calculateDistancesHelper(pointsMatrix,70,72,true,isDeley);
distancesMatrix{end+1,1} = 'L_downCheek_to_L_upcheek';
distancesMatrix{end,2} = L_downCheek_to_L_upcheek;

%right face point 3 to right lower cheek
Face_3__to_R_lowcheek = calculateDistancesHelper(pointsMatrix,3,69,true,isDeley);
distancesMatrix{end+1,1} = 'Face_3__to_R_lowcheek';
distancesMatrix{end,2} = Face_3__to_R_lowcheek;


%left face point 15 to left lower cheek
Face_15__to_L_lowcheek = calculateDistancesHelper(pointsMatrix,15,70,true,isDeley);
distancesMatrix{end+1,1} = 'Face_15__to_L_lowcheek';
distancesMatrix{end,2} = Face_15__to_L_lowcheek;


% inside right eye-brow to start of nose
R_EB_to_nose_28 = calculateDistancesHelper(pointsMatrix,22,28,true,isDeley);
distancesMatrix{end+1,1} = 'R_EB_to_nose_28';
distancesMatrix{end,2} = R_EB_to_nose_28;

% inside left eye-brow to start of nose
L_EB_to_nose_28 = calculateDistancesHelper(pointsMatrix,23,28,true,isDeley);
distancesMatrix{end+1,1} = 'L_EB_to_nose_28';
distancesMatrix{end,2} = L_EB_to_nose_28;


%right face point 5 to right cheek-mouth
Face_5__to_R_cheek_mouth = calculateDistancesHelper(pointsMatrix,5,73,true,isDeley);
distancesMatrix{end+1,1} = 'Face_5__to_R_cheek_mouth';
distancesMatrix{end,2} = Face_5__to_R_cheek_mouth;


%right face point 5 to right lower cheek
Face_5__to_R_lowcheek = calculateDistancesHelper(pointsMatrix,5,69,true,isDeley);
distancesMatrix{end+1,1} = 'Face_5__to_R_lowcheek';
distancesMatrix{end,2} = Face_5__to_R_lowcheek;

%left face point 13 to left lower cheek
Face_13__to_L_lowcheek = calculateDistancesHelper(pointsMatrix,13,70,true,isDeley);
distancesMatrix{end+1,1} = 'Face_13__to_L_lowcheek';
distancesMatrix{end,2} = Face_13__to_L_lowcheek;

%left face point 13 to left cheek-mouth
Face_13__to_L_cheek_mouth = calculateDistancesHelper(pointsMatrix,13,74,true,isDeley);
distancesMatrix{end+1,1} = 'Face_13__to_L_cheek_mouth';
distancesMatrix{end,2} = Face_13__to_L_cheek_mouth;

% right cheek-mouth to the mid point of horizontal nose
MidHorizontal_nose__to_R_cheek_mouth = calculateDistancesHelper(pointsMatrix,34,73,true,isDeley);
distancesMatrix{end+1,1} = 'MidHorizontal_nose__to_R_cheek_mouth';
distancesMatrix{end,2} = MidHorizontal_nose__to_R_cheek_mouth;


% left cheek-mouth to the mid point of horizontal nose
midHorizontal_nose__to_L_cheek_mouth = calculateDistancesHelper(pointsMatrix,34,74,true,isDeley);
distancesMatrix{end+1,1} = 'midHorizontal_nose__to_L_cheek_mouth';
distancesMatrix{end,2} = midHorizontal_nose__to_L_cheek_mouth;

%mid horizontal nose to upper lip- right
midHorizontal_nose__to_R_upperLip = calculateDistancesHelper(pointsMatrix,34,51,true,isDeley);
distancesMatrix{end+1,1} = 'midHorizontal_nose__to_R_upperLip';
distancesMatrix{end,2} = midHorizontal_nose__to_R_upperLip;

%mid horizontal nose to upper lip- left
midHorizontal_nose__to_L_upperLip = calculateDistancesHelper(pointsMatrix,34,53,true,isDeley);
distancesMatrix{end+1,1} = 'midHorizontal_nose__to_L_upperLip';
distancesMatrix{end,2} = midHorizontal_nose__to_L_upperLip;

% center lower lip to the center of the face shape
centerLowLip_to_centerFace = calculateDistancesHelper(pointsMatrix,9,58,true,isDeley);
distancesMatrix{end+1,1} = 'centerLowLip_to_centerFace';
distancesMatrix{end,2} = centerLowLip_to_centerFace;


%right eye-brow to top right ear
R_eyeBrow_to_R_ear = calculateDistancesHelper(pointsMatrix,1,18,true,isDeley);
distancesMatrix{end+1,1} = 'R_eyeBrow_to_R_ear';
distancesMatrix{end,2} = R_eyeBrow_to_R_ear;

%left eye-brow to top left ear
L_eyeBrow_to_L_ear = calculateDistancesHelper(pointsMatrix,17,27,true,isDeley);
distancesMatrix{end+1,1} = 'L_eyeBrow_to_L_ear';
distancesMatrix{end,2} = L_eyeBrow_to_L_ear;



%draw the face shape
for i=1:16
    hold on
    plot([pointsMatrix(i,1) pointsMatrix(i+1,1)],[pointsMatrix(i,2) pointsMatrix(i+1,2)],'Color','w','LineWidth',2)
    if(isDeley)
        pause(deleyInSec);
    end
end

%draw the right eye brow
for i=18:21
    hold on
    plot([pointsMatrix(i,1) pointsMatrix(i+1,1)],[pointsMatrix(i,2) pointsMatrix(i+1,2)],'Color','w','LineWidth',2)
    if(isDeley)
        pause(deleyInSec);
    end
end

%draw the left eye brow
for i=23:26
    hold on
    plot([pointsMatrix(i,1) pointsMatrix(i+1,1)],[pointsMatrix(i,2) pointsMatrix(i+1,2)],'Color','w','LineWidth',2)
    if(isDeley)
        pause(deleyInSec);
    end
end

%draw right eye
for i=37:41
    plot([pointsMatrix(i,1) pointsMatrix(i+1,1)],[pointsMatrix(i,2) pointsMatrix(i+1,2)],'Color','w','LineWidth',2)
    if(isDeley)
        pause(deleyInSec);
    end
end
plot([pointsMatrix(37,1) pointsMatrix(42,1)],[pointsMatrix(37,2) pointsMatrix(42,2)],'Color','w','LineWidth',2)

if(isDeley)
        pause(deleyInSec);
end
%draw left eye
for i=43:47
    plot([pointsMatrix(i,1) pointsMatrix(i+1,1)],[pointsMatrix(i,2) pointsMatrix(i+1,2)],'Color','w','LineWidth',2)
    if(isDeley)
        pause(deleyInSec);
    end
end

plot([pointsMatrix(43,1) pointsMatrix(48,1)],[pointsMatrix(43,2) pointsMatrix(48,2)],'Color','w','LineWidth',2)

if(isDeley)
        pause(deleyInSec);
end
%draw outside lips
for i=49:59
    plot([pointsMatrix(i,1) pointsMatrix(i+1,1)],[pointsMatrix(i,2) pointsMatrix(i+1,2)],'Color','w','LineWidth',2)
    if(isDeley)
        pause(deleyInSec);
    end
end
plot([pointsMatrix(49,1) pointsMatrix(60,1)],[pointsMatrix(49,2) pointsMatrix(60,2)],'Color','w','LineWidth',2)
if(isDeley)
        pause(deleyInSec);
end
%draw inside lips
for i=61:67
    plot([pointsMatrix(i,1) pointsMatrix(i+1,1)],[pointsMatrix(i,2) pointsMatrix(i+1,2)],'Color','w','LineWidth',2)
    if(isDeley)
        pause(deleyInSec);
    end
end
plot([pointsMatrix(61,1) pointsMatrix(68,1)],[pointsMatrix(61,2) pointsMatrix(68,2)],'Color','w','LineWidth',2)

end


