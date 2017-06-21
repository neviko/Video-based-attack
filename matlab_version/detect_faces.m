function [ bboxes, shapes ] = detect_faces(detector, image, types )
%DETECT_FACES Detecting faces in a given image using one of the three detectors
% INPUT:
%   image - the image to detect the faces on
%   type  - cell array of the face detectors to use: 'zhu', 'yu', 'cascade'
% OUTPUT:
%   bboxes - a set of bounding boxes describing the detected faces 4 x
%   num_faces, the format is [min_x; min_y; max_x; max_y];
%   shapes - if the face detector detects landmarks as well, output them
%   n_points x 2 x num_faces

    use_zhu = any(strcmp('zhu', types));
    use_yu = any(strcmp('yu', types));
    use_cascade = any(strcmp('cascade', types));
    
    % Start with fastest one
    shapes = [];
    bboxes = [];
    if(use_cascade)
        % Check if vision toolbox is available
        if(~isempty(ver('vision')))
            bboxes_det = detector.detect(image, 'ScaleFactor',1.3,'MinNeighbors',2, 'MinSize', [30,30]);
            
            if(~isempty(bboxes_det))
                bboxes_det = cell2mat(bboxes_det');
                % Convert to the right format
                bboxes = bboxes_det';
                
                % Correct the bounding box to be around face outline
                % horizontally and from brows to chin vertically
                % The scalings were learned using the Face Detections on LFPW, Helen, AFW and iBUG datasets
                % using ground truth and detections from openCV
                % Correct the widths
                bboxes(3,:) = bboxes(3,:) * 0.8534;
                bboxes(4,:) = bboxes(4,:) * 0.8972;                
                % Correct the location
                bboxes(1,:) = bboxes(1,:) + bboxes_det(:,3)'*0.0266;
                bboxes(2,:) = bboxes(2,:) + bboxes_det(:,4)'*0.1884;
                
                bboxes(3,:) = bboxes(1,:) + bboxes(3,:);
                bboxes(4,:) = bboxes(2,:) + bboxes(4,:);
            end
        else
            fprintf('Vision toolbox not present in Matlab, it is necessary for Cascade face detection\n');
        end
    end
    
    if(use_yu && isempty(bboxes))
        od = cd('face_detection/face_detection_yu/');
        tic;
        [bboxes, shapes] = Detect_tree_based_yu_multi(image);
        aa = toc;
        disp(num2str(aa));
        cd(od);        
    end    
end

