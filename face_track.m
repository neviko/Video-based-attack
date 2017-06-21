function [ image_changed, shape_array ] = face_track( image_orig )
%TRACK_FACE Tracking face in a given image
% INPUT:
%   image_orig - the image to track the face
% OUTPUT:
%   image_changed - the inputed image with all the features points 
%   shape_array - matrix of face shape coordinate points

    % adding path to use the related functions
    addpath('/CCNF');
    addpath(genpath('/face_detection_yu'));
    addpath(genpath('/fitting'));
    addpath('/PDM_helpers');
    

    %% loading CLM(constrained local model) parameters
    [clmParams, pdm] = Load_CLM_params_wild();

    % An accurate CCNF (or CLNF)(continuous conditional neural fields)
    % model parameters
    [patches] = Load_Patch_Experts(clmParams);

    clmParams.multi_modal_types  = patches.multi_modal_types;

    % detecting faces using cascade method
    %   bboxes - a set of bounding boxes describing the detected faces 4 x
    %   num_faces, the format is [min_x; min_y; max_x; max_y];
    %   shapes - if the face detector detects landmarks as well, output them
    %   n_points x 2 x num_faces
    [bboxs, det_shapes] = detect_faces(image_orig, {'cascade', 'yu'});
   
    if(size(bboxs) ~= 1)
        msgbox('The system detected 12more then one face','Error message','error');
    end
                           
    if(size(image_orig,3) == 3) % if the image have 3 demesions make it to two demensions
        image = rgb2gray(image_orig);
    end
    
    
    %% draw original image
    %f = figure;    
    if(max(image(:)) > 1)
        imshow(double(image_orig)/255, 'Border', 'tight'); % devide by 255 for natural colors, devide by 0 is a white image
    else
        imshow(double(image_orig), 'Border', 'tight');
    end
    axis equal;
    hold on;
 
    
    % Convert from the initial detected shape to CLM model parameters,
    % if shape is available
    if(size(bboxs,2)>=1)
        
        % first bounding box
        bbox = bboxs(:,1);

        if(~isempty(det_shapes))
            %getting first face shape
            shape = det_shapes(:,:,1);
            inds = [1:60,62:64,66:68];
            % Getting MeanShape
            M = pdm.M([inds, inds+68, inds+68*2]);
            % eigen values
            E = pdm.E;
            % eigen vectors
            V = pdm.V([inds, inds+68, inds+68*2],:);
            % projecting PDM(point distribution model) points to 2D space
            [ a, R, T, ~, params, err, shapeOrtho] = fit_PDM_ortho_proj_to_2D(M, E, V, shape);
            % global parameters for clm fitting
            g_param = [a; Rot2Euler(R)'; T];
            % local parameters for clm fitting 
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
        
        %add to v_points the extra four points that i has been created
        for i=69:74
            v_points(i)=1;
        end
        
        %draw detecting landmarks and giving numbers.
        try
            plot(shape(v_points,1), shape(v_points',2),'.g','MarkerSize',10); 
        catch warn  
        end
        
        shape_array=shape;
        %getting image with detecting landmarks
        changed_frame=getframe; % get frame is a struct that contain the image with the points on it
        image_changed=changed_frame.cdata; % cdata is the image with the points
        %imwrite(image_changed,'ss.jpg','jpg');
        %close(f);
    end
    
end