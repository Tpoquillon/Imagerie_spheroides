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

dir_name = "../Database1/Kmean_segmentation"; % dossier où seront stocker les résultats
if ~exist(dir_name, 'dir')
    mkdir(dir_name);
end

for i=1:length(list_img)
    
    % Récupération et débruitage supplémentaire des images
    I = image_data{i};          
    I_bw2 = bwareaopen(I,30);       % Suppression des résidus de moins de 50 pixels
    subplot(1,2,1),imshow(I_bw2);
    D = -bwdist(~I_bw2);            % Calcul de la transformé de la distance Euclidien de l'image
    subplot(1,2,2),imshow(D,[]);
    sgtitle('Débruitage des images');
    
    % Kmean sur 2 cluster (pas besoin de plus après l'étape précédente)
    imgx=imsegkmeans(D,2); % séparation de l'image en 2 clusters (fond / cellules) 
    map1=imgx(:,:)==1;     
    map2=imgx(:,:)==2;

    imgpret=labeloverlay(D,imgx); % Permet d'appliquer des couleurs en fonction des labels
    figure,imshow(imgpret);       % Affichage de l'image clusteriser en noir et bleu/jaune
    sgtitle('Résultats de la segmentation Kmean');

    % Affichage des différents labels (mask par mask)
    figure,sgtitle('Séparation des masks pour la segmentation');
    subplot(1,2,1),imshow(map1);
    subplot(1,2,2),imshow(map2);

    % Affichage des centromères
    mask = imextendedmin(D,2);
    figure,imshowpair(I_bw2,mask,'blend');
    sgtitle('Affichage des centromères');
    
    % Sauvegarde du cluster de cellule comme image binaire
    img_name = strcat(list_img(i).name(1:2), "_segmented.tif");
    img_path = strcat("../Database1/Kmean_segmentation/", img_name);
    imwrite(map2,img_path);
end