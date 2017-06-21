function [patches] = Load_Patch_Experts(clmParams)
%LOAD_PATCH_EXPERTS Summary of this function goes here
%   Detailed explanation goes here
   

    load('ccnf_patches_0.25_general.mat');

    % determine patch type (slightly hacky but SVR patch experts don't
    % CCNF ratio variable)

    patch = struct;
    patch.centers = centers;
    patch.trainingScale = trainingScale;
    patch.visibilities = visiIndex; 
    patch.patch_experts = patch_experts.patch_experts;
    patch.correlations = patch_experts.correlations;
    patch.rms_errors = patch_experts.rms_errors;
    patch.modalities = patch_experts.types;
    patch.multi_modal_types = patch_experts.types;

    patch.type = 'CCNF';

    % Knowing what normalisation was performed during training is
    % important for fitting
    patch.normalisationOptionsCol = normalisationOptions;

    % As the similarity inverses will depend on the window size
    % and alphas and betas, but not actual data, precalculate
    % them here

    % create the similarity inverses
    window_sizes = unique(clmParams.window_size(:));

    for s=1:size(window_sizes,1)

        for view=1:size(patch.patch_experts,1)
            for lmk=1:size(patch.patch_experts,2)
                if(visiIndex(view, lmk))
                    num_modalities = size(patch.patch_experts{view,lmk}.thetas,3);

                    num_hls = size(patch.patch_experts{view,lmk}.thetas,1);

                    patchSize = sqrt(size( patch.patch_experts{view,lmk}.thetas,2)-1);
                    patchSize = [patchSize, patchSize];

                    % normalisation so that patch expert can be
                    % applied using convolution
                    w = cell(num_hls, num_modalities);
                    norm_w = cell(num_hls, num_modalities);

                    for hl=1:num_hls
                        for p=1:num_modalities

                            w_c = patch.patch_experts{view,lmk}.thetas(hl, 2:end, p);
                            norm_w_c = norm(w_c);
                            w_c = w_c/norm(w_c);
                            w_c = reshape(w_c, patchSize);
                            w{hl,p} = w_c;
                            norm_w{hl,p} = norm_w_c;
                        end
                    end

                    patch.patch_experts{view,lmk}.w = w;
                    patch.patch_experts{view,lmk}.norm_w = norm_w;

                    similarities = {};
                    response_side_length = window_sizes(s) - 11 + 1;
                    for st=1:size(patch.patch_experts{view,lmk}.similarity_types, 1)
                        type_sim = patch.patch_experts{view,lmk}.similarity_types{st};
                        neighFn = @(x) similarity_neighbor_grid(x, response_side_length(1), type_sim);
                        similarities = [similarities; {neighFn}];
                    end

                    sparsities = {};

                    for st=1:size(patch.patch_experts{view,lmk}.sparsity_types, 1)
                        spFn = @(x) sparsity_grid(x, response_side_length(1), patch.patch_experts{view,lmk}.sparsity_types(st,1), patch.patch_experts{view,lmk}.sparsity_types(st,2));
                        sparsities = [sparsities; {spFn}];
                    end

                    region_length = response_side_length^2;

                    [ ~, ~, PrecalcQ2sFlat, ~ ] = CalculateSimilarities_sparsity( 1, {zeros(region_length,1)}, similarities, sparsities);

                    PrecalcQ2flat = PrecalcQ2sFlat{1};

                    SigmaInv = CalcSigmaCCNFflat(patch.patch_experts{view,lmk}.alphas, patch.patch_experts{view,lmk}.betas, region_length, PrecalcQ2flat, eye(region_length), zeros(region_length));
                    if(s == 1)
                        patch.patch_experts{view,lmk}.Sigma = {inv(SigmaInv)};
                    else
                        patch.patch_experts{view,lmk}.Sigma = cat(1, patch.patch_experts{view,lmk}.Sigma, {inv(SigmaInv)});
                    end
                end
            end
        end
    end   
    patches = patch;

end

