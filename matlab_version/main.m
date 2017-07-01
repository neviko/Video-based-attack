%clear all
%close all
clc
addpath('PDM_helpers');
addpath('fitting');
addpath('models');
addpath('face_detection');
%% loading the patch experts
[clmParams, pdm] = Load_CLM_params_vid();
[patches] = Load_Patch_Experts( 'models/general/', 'svr_patches_*_general.mat', [], [], clmParams);
clmParams.multi_modal_types  = patches(1).multi_modal_types;
% load the face validator and add its dependency
load('face_validation/trained/face_check_cnn_68.mat', 'face_check_cnns');
addpath('face_validation');
addpath('mexopencv-master');
%mexopencv.make
cam = cv.VideoCapture(0);

frameCounter=0;
maxNumOfFrames = 80;

detector = cv.CascadeClassifier('haarcascade_frontalface_alt.xml');
while true && frameCounter < maxNumOfFrames
    % if this version throws a "Dot name reference on non-scalar structure"
    % error change obj.NumberOfFrames to obj(1).NumberOfFrames (in two
    % places in read function) or surround it with an empty try catch
    % statement
    
    frameCounter = frameCounter+1;
    
    image_orig = cam.read;  
    imshow(image_orig);
    im = cv.cvtColor(image_orig, 'RGB2GRAY');
    im = cv.equalizeHist(im);
    boxes = detector.detect(im, 'ScaleFactor',1.3,'MinNeighbors',2, 'MinSize', [30,30]);
    if isempty(boxes)
        continue;
    end    
    % First attempt to use the Matlab one (fastest but not as accurate, if not present use yu et al.)
    tic;
    [bboxs, det_shapes] = detect_faces(detector,im, {'cascade', 'yu'});              
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
            [shape,~,~,lhood,lmark_lhood,view_used] = Fitting_from_bb(im, [], bbox, pdm, patches, clmParams, 'gparam', g_param, 'lparam', l_param);
        else
            num_points = numel(pdm.M) / 3;
            M = reshape(pdm.M, num_points, 3);
            width_model = max(M(:,1)) - min(M(:,1));
            height_model = max(M(:,2)) - min(M(:,2));
            a = (((bbox(3) - bbox(1)) / width_model) + ((bbox(4) - bbox(2))/ height_model)) / 2;
            tx = (bbox(3) + bbox(1))/2;
            ty = (bbox(4) + bbox(2))/2;
            % correct it so that the bounding box is just around the minimum
            % and maximum point in the initialised face
            tx = tx - a*(min(M(:,1)) + max(M(:,1)))/2;
            ty = ty + a*(min(M(:,2)) + max(M(:,2)))/2;
            % visualisation
            g_param = [a, 0, 0, 0, tx, ty]';
            l_param = zeros(size(pdm.E));
            [shape,~,~,lhood,lmark_lhood,view_used] = Fitting_from_bb(im, [], bbox, pdm, patches, clmParams, 'gparam', g_param, 'lparam', l_param);
        end
        % shape correction for matlab format
        shape = shape + 1;
        try                   
            axis equal;
            hold on;                    
            %plot(shape(:,1), shape(:,2),'.r','MarkerSize',10);
            plot(shape(:,1), shape(:,2),'.b','MarkerSize',5);                    
            hold off;
            drawnow expose;
        catch warn
            fprintf('%s', warn.message);
        end
    end 
    a = toc;
    disp(num2str(a));
end

delete(cam); %delete video reader pointer
 delete(gca);% delete the axes
