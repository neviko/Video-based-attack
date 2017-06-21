



%clear all
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
[file, path] = uigetfile({'*.avi';'*.mpg'},'Select video file');
 vr = VideoReader(fullfile(path, file));
 vr.CurrentTime = 2.5; 
 currAxes = axes; % an axes
 currAxes.Position=[0 0.06 0.7750 0.8150]; % axes position
 currAxes.ButtonDownFcn=onBtnDown();
 addpath('mexopencv-master\')
 detector = cv.CascadeClassifier('haarcascade_frontalface_alt2.xml');
 while hasFrame(vr) %while the video is running
    frame = readFrame(vr); % read frame
    image(frame, 'Parent', currAxes); %display the image on axes
    currAxes.Visible = 'off';    
    currAxes.Visible = 'off';
    im = cv.cvtColor(frame, 'RGB2GRAY'); %pars the image to gray scale
    im = cv.equalizeHist(im);
    boxes = detector.detect(im, 'ScaleFactor',1.3,'MinNeighbors',2, 'MinSize', [30,30]);   
    if isempty(boxes)          
        drawnow;
        continue;
    end    
    % First attempt to use the Matlab one (fastest but not as accurate, if not present use yu et al.)   
    det_shapes = [];
    if(~isempty(boxes))
        boxes = cell2mat(boxes');
        % Convert to the right format
        bboxs = boxes';                
        % Correct the bounding box to be around face outline
        % horizontally and from brows to chin vertically
        % The scalings were learned using the Face Detections on LFPW, Helen, AFW and iBUG datasets
        % using ground truth and detections from openCV
        % Correct the widths
        bboxs(3,:) = bboxs(3,:) * 0.8534;
        bboxs(4,:) = bboxs(4,:) * 0.8972;                
        % Correct the location
        bboxs(1,:) = bboxs(1,:) + boxes(:,3)'*0.0266;
        bboxs(2,:) = bboxs(2,:) + boxes(:,4)'*0.1884;
        bboxs(3,:) = bboxs(1,:) + bboxs(3,:);
        bboxs(4,:) = bboxs(2,:) + bboxs(4,:);
    end
    for i=1:size(bboxs,2)
        % Convert from the initial detected shape to CLM model parameters,
        % if shape is available
        bbox = bboxs(:,i);
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
        % shape correction for matlab format
        shape = shape + 1;
        try    
            hold on;                  
            plot(shape(:,1), shape(:,2),'.m','MarkerSize',5);
            plot(shape(:,1), shape(:,2),'+g','MarkerSize',3);   
            drawnow expose;
            hold off;
        catch warn
            fprintf('%s', warn.message);
        end
    end    
 end
 
 
 
 