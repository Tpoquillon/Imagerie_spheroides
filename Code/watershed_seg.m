clear all;
close all;

% Vecteurs contenant les 5 images débruitées et binarisées :
list_img = dir("../Database1/Denoised_images/*.tif");
image_data= cell(1,length(list_img));
for j=1:length(list_img)
    file_name = strcat('../Database1/Denoised_images/', list_img(j).name);
    image_file=imread(file_name);
    image_data{j}=image_file;
end

dir_name = "../Database1/Watershed_segmentation"; % folder name where we'll save denoised images
if ~exist(dir_name, 'dir')
    mkdir(dir_name);
end

for i=1:length(list_img)
    
    I = image_data{i}; 

    % using the watershed transform for segmentation of the binary images
    % https://blogs.mathworks.com/steve/2013/11/19/watershed-transform-question-from-tech-support/

    L = watershed(I);
    Lrgb = label2rgb(L);
    fig1 = figure
    sgtitle('Watershed transforms for segmentation');
    subplot(3,3,1);
    imshow(imfuse(I,Lrgb))


    %1st step : clean up the noise a bit. 
    % The function bwareaopen can be used to remove very small dots. 

    I_bw2 = bwareaopen(I,50); % pour supprimer les faux grains contenant moins de 50 pixels
    subplot(3,3,2);
    imshow(I_bw2)

    % the distance transform can be useful  here
    D = -bwdist(~I_bw2);
    subplot(3,3,3);
    imshow(D,[])

    % compute the watershed transform of D.
    Ld = watershed(D);
    subplot(3,3,3);
    imshow(label2rgb(Ld))


    % The watershed ridge lines, in white, correspond to Ld == 0. 
    % Let's use these ridge lines to segment the binary image by changing the corresponding pixels into background.

    % https://fr.mathworks.com/help/images/understanding-morphological-reconstruction.html

    mask = imextendedmin(D,2);
    subplot(3,3,4);
    imshowpair(I_bw2,mask,'blend')


    % Modify the distance transform so it only has minima at the desired locations, 
    % and then repeat the watershed steps above.

    D2 = imimposemin(D,mask);
    Ld2 = watershed(D2);
    
    I_bw3 = I_bw2;
    I_bw3(Ld2 == 0) = 0;
    subplot(3,3,5);
    imshow(I_bw3)


    % proprietes morphologiques des cellules:

    I_bw4 = I_bw3(:,:)>0; % image binaire dont l'intensite des  pixels est de 1 (les blancs)
    [img_labelled, nombre_cells] = bwlabel(I_bw4);  % etalonnage  de l'image
    subplot(3,3,6);
    imagesc(img_labelled);
    
    stats = regionprops (I_bw4, 'Area', 'Perimeter', 'Centroid', 'Eccentricity'); 

    M_area = mean([stats.Area]);  % moyenne des aires 
    M_eccentricity = mean([stats.Eccentricity]);  % moyenne des circularite ( 0 = circulaire ; 1 = lineaire)
    M_perimeter = mean([stats.Perimeter]);  % moyenne des perimetres
    
    table_name = strcat(list_img(i).name(1:2), "_cells_stats.txt");
    table_path = strcat("../Database1/Watershed_segmentation/", table_name);
    writetable(struct2table(stats),table_path,'Delimiter',' ')  

    fig2 = figure
    subplot(1,2,1);
    imshow(I);
    title("Original denoised and binarized image");
    
    subplot(1,2,2);
    imshow(I_bw3);
    title("Segmented image using Watershed transforms");
    
    img_name = strcat(list_img(i).name(1:2), "_segmented.tif");
    img_path = strcat("../Database1/Watershed_segmentation/", img_name);
    imwrite(I_bw3,img_path);
    
end