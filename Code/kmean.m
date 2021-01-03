clear all;
close all;

I = imread("../Database1/images/02.tif");
J= histeq(I);
K = adapthisteq(I);

subplot(2,2,1),imshow(I);
subplot(2,2,2),imshow(J);
subplot(2,2,3),imshow(I);
subplot(2,2,4),imshow(K);

% Kmean sur 2 cluster
imgx=imsegkmeans(K,2); % séparation de l'image en 3 clusters (fond / cellules) 
map1=imgx(:,:)==1;     % Inconvénient : il n'y a pas de démarquation entre cellules
map2=imgx(:,:)==2;

imgpret=labeloverlay(K,imgx); % Permet d'appliquer des couleurs en fonction des labels
imshow(imgpret)

% Affichage des différents labels
subplot(1,2,1),imshow(map1);
subplot(1,2,2),imshow(map2);

% Kmean sur 3 cluster
imgx=imsegkmeans(K,3); % séparation de l'image en 3 clusters (fond / cellules inférieures / cellules supérieures)
map1=imgx(:,:)==1; 
map2=imgx(:,:)==2;
map3=imgx(:,:)==3;

imgpret=labeloverlay(K,imgx); % Permet d'appliquer des couleurs en fonction des labels
imshow(imgpret)

% Affichage des différents labels
subplot(1,3,1),imshow(map1);
subplot(1,3,2),imshow(map2);
subplot(1,3,3),imshow(map3);

imgx=imsegkmeans(K,3,'NormalizeInput',true); % séparation de l'image en 3 clusters avec normalisation des valeurs
map1=imgx(:,:)==1;                           % Je vois pas une grande différence
map2=imgx(:,:)==2;
map3=imgx(:,:)==3;

imgpret=labeloverlay(K,imgx); % Permet d'appliquer des couleurs en fonction des labels
imshow(imgpret)

% Affichage des différents labels
subplot(1,3,1),imshow(map1);
subplot(1,3,2),imshow(map2);
subplot(1,3,3),imshow(map3);

% stat de Pierrick
data_img4 = imgpret(:,:)>0; % image binaire dont l'intensite des  pixels est de 1 (les blancs)
[img_labelled, nombreGrains] = bwlabel(data_img4);  % etalonnage  de l'image
stats = regionprops (data_img4, 'Area', 'Perimeter', 'Centroid', 'Eccentricity'); 
M_area = mean([stats.Area]);  % moyenne des aires 
M_eccentricity = mean([stats.Eccentricity]);  % moyenne des circularite ( 0 = circulaire ; 1 = lineaire)
M_perimeter = mean([stats.Perimeter]);  % moyenne des perime