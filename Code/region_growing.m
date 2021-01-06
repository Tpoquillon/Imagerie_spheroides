clear all;
close all;


I = imread("../Database1/images/16.tif");
%subplot(1,2,1);
imshow(I)

mask = zeros(size(I));
mask(25:end-25,25:end-25) = 1;

bw = activecontour(I,mask,10000);
%subplot(1,2,2);
imshow(bw)

imgpret=labeloverlay(I,bw); % Permet d'appliquer des couleurs en fonction des labels
%imshow(imgpret)

% proprietes morphologiques des cellules:

data_img4 = imgpret(:,:)>0; % image binaire dont l'intensite des  pixels est de 1 (les blancs)
[img_labelled, nombreGrains] = bwlabel(data_img4);  % etalonnage  de l'image
stats = regionprops (data_img4, 'Area', 'Perimeter', 'Centroid', 'Eccentricity'); 
M_area = mean([stats.Area]);  % moyenne des aires 
M_eccentricity = mean([stats.Eccentricity]);  % moyenne des circularite ( 0 = circulaire ; 1 = lineaire)
M_perimeter = mean([stats.Perimeter]);  % moyenne des perime

