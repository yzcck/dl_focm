% Used to generate the ortho-learning figure in FOCM. 
% Last update: Fri 17 Oct 2014 04:56:25 PM EDT 

clear;
clc;

num_trial_per_img = 100;
patch_size = 8; 

% parameters for ADM
MAX_ITER = 10000;
DISPLAY  = true; 
TOL = 1e-5;
tau = 2; 

addpath('test_slate');
D = dir(fullfile('test_slate', '*.pgm'));   

for i = 1:length(D),
    
    disp('Loading the image!');
    
    img = imread(D(i).name);

    if ndims(img) > 2, 
        I = double(rgb2gray(imread(img)));
    else
        I = double(img);
    end

    Y = image_to_patches(I, patch_size);
    
    [m, p] = size(Y);

    done = false;
    all_obj = [];
    
    rng(i, 'twister');  % to ensure reproducibility, we specify both the seed and the alg 

    for j = 1:num_trial_per_img,
    
        [A obj_value] = learn_orthobasis_adm( Y, proj_orthogonal_group(randn(m,m)), MAX_ITER, TOL, tau, DISPLAY); 
        all_obj = [all_obj, norm1(A'*Y)];
%        allObj = [allObj, obj_value]; % objective values

        if j == 1,
		    figure(1);
			imagesc(I);
			colormap gray; 
			axis off; 
			axis image;
        
            fig = figure(2);
            set(fig, 'Position', [300, 300, 512, 512]); 
            visualize_orthobasis(A);
        end
        
        figure(3);
        stem(all_obj);
        ylim([0, 1.25 * max(all_obj)]);
                
        pause(2);
    end
    
    figure(1);
    set(gcf,'PaperPositionMode','auto'); 
    print(gcf, '-dpdf', fullfile('results', [num2str(i), '_img.pdf'])); 
    system(['pdfcrop ', fullfile('results', [num2str(i), '_img.pdf'])]); 
    
    figure(2);
    set(gcf,'PaperPositionMode','auto'); 
    print(gcf, '-dpdf', fullfile('results', [num2str(i), '_dict.pdf'])); 
    system(['pdfcrop ', fullfile('results', [num2str(i), '_dict.pdf'])]); 
    
    figure(3);
    set(gcf,'PaperPositionMode','auto'); 
    print(gcf, '-dpdf', fullfile('results', [num2str(i), '_obj.pdf'])); 
    system(['pdfcrop ', fullfile('results', [num2str(i), '_obj.pdf'])]); 
    
end