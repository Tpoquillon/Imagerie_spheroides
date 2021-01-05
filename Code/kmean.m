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
    I_bw2 = bwareaopen(I,50);       % Suppression des résidus de moins de 50 pixels
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

    mask = imextendedmin(D,2);
    figure,imshowpair(I_bw2,mask,'blend');
    sgtitle('Affichage des centromères');
end


% Adaptation de l'image pour débruitage et démarquation des cellules
I_bw2 = bwareaopen(I,50); % pour supprimer les faux grains contenant moins de 50 pixels
subplot(1,2,1),imshow(I_bw2);
D = -bwdist(~I_bw2);
subplot(1,2,2),imshow(D,[]);

% Kmean sur 2 cluster
imgx=imsegkmeans(D,2); % séparation de l'image en 2 clusters (fond / cellules) 
map1=imgx(:,:)==1;     % Inconvénient : il n'y a pas de démarquation entre cellules
map2=imgx(:,:)==2;

imgpret=labeloverlay(D,imgx); % Permet d'appliquer des couleurs en fonction des labels
figure,imshow(imgpret);       % affichage de l'image clusteriser

% Affichage des différents labels (mask par mask)
figure,
subplot(1,2,1),imshow(map1);
subplot(1,2,2),imshow(map2);

mask = imextendedmin(D,2);
figure,imshowpair(I_bw2,mask,'blend');

% stat de Pierrick
data_img4 = imgpret(:,:)>0; % image binaire dont l'intensite des  pixels est de 1 (les blancs)
[img_labelled, nombreGrains] = bwlabel(data_img4);  % etalonnage  de l'image
stats = regionprops (data_img4, 'Area', 'Perimeter', 'Centroid', 'Eccentricity'); 
M_area = mean([stats.Area]);  % moyenne des aires 
M_eccentricity = mean([stats.Eccentricity]);  % moyenne des circularite ( 0 = circulaire ; 1 = lineaire)
M_perimeter = mean([stats.Perimeter]);  % moyenne des perime



%%%% truc a essayer et rajouter 
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