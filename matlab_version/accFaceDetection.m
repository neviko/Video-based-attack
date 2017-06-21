function [recognizedImage,pointsMatrix] = accFaceDetection()
clear all
clc
addpath('PDM_helpers');
addpath('fitting');
addpath('models');
addpath('face_detection');
%% loading the patch experts
[clmParams, pdm] = Load_CLM_params_vid();
[patches] = Load_Patch_Experts( 'models/general/', 'svr_patches_*_general.mat', [], [], clmParams);
% [patches] = Load_Patch_Experts( 'models/general/', 'ccnf_patches_*_general.mat', [], [], clmParams);
clmParams.multi_modal_types  = patches(1).multi_modal_types;
% load the face validator and add its dependency
load('face_validation/trained/face_check_cnn_68.mat', 'face_check_cnns');
[file, path] = uigetfile({'*.jpg';'*.png'},'Select image file');
image_orig = imread(fullfile(path, file));

% First attempt to use the Matlab one (fastest but not as accurate, if not present use yu et al.)
[bboxs, det_shapes] = detect_faces_(image_orig, {'cascade', 'yu'});

if(size(image_orig,3) == 3)
    image = rgb2gray(image_orig);
end              

%%
%f = figure;
axes(handles.axes1);

if(max(image(:)) > 1)
    imshow(double(image_orig)/255, 'Border', 'tight');
else
    imshow(double(image_orig), 'Border', 'tight');
end
axis equal;
hold on;

for i=1:size(bboxs,2)

    % Convert from the initial detected shape to CLM model parameters,
    % if shape is available

    bbox = bboxs(:,i);

    if(~isempty(det_shapes))
        shape = det_shapes(:,:,i);
        inds = [1:60,62:64,66:68];
        M = pdm.M([inds, inds+68, inds+68*2]);
        E = pdm.E;
        V = pdm.V([inds, inds+68, inds+68*2],:);
        [ a, R, T, ~, params, err, shapeOrtho] = fit_PDM_ortho_proj_to_2D(M, E, V, shape);
        g_param = [a; Rot2Euler(R)'; T];
        l_param = params;

        % Use the initial global and local params for clm fitting in the image
        [shape,~,~,lhood,lmark_lhood,view_used] = Fitting_from_bb(image, [], bbox, pdm, patches, clmParams, 'gparam', g_param, 'lparam', l_param);
    else
        [shape,~,~,lhood,lmark_lhood,view_used] = Fitting_from_bb(image, [], bbox, pdm, patches, clmParams);
    end

    %adding 6 more points on the user cheeks
   
    %low cheek right
    shape(69,1) =shape(37,1);
    shape(69,2) =shape(31,2);

    %low cheek left
    shape(70,1) = shape(46,1);
    shape(70,2) = shape(31,2);

    %up cheek right
    shape(71,1) =shape(41,1);
    shape(71,2) =shape(30,2);

    %up cheek left
    shape(72,1) = shape(48,1);
    shape(72,2) = shape(30,2);

    %right cheek-mouth points
    shape(73,1) = shape(42,1);
    shape(73,2) = shape(52,2);

    %left cheek-mouth points
    shape(74,1) = shape(47,1);
    shape(74,2) = shape(52,2);
    
    
    % shape correction for matlab format
    shape = shape + 1;   
    % valid points to draw (not to draw self-occluded ones)
    v_points = logical(patches(1).visibilities(view_used,:));
    plot(shape(v_points,1), shape(v_points',2),'.r','MarkerSize',10);
    changed_frame=getframe; % get frame is a struct that contain the image with the points on it
    recognizedImage=changed_frame.cdata; % cdata is the image with the points
    
end
