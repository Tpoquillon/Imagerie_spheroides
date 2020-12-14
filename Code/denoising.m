clear all;
close all;

%Remove the noise caused by laser confocal scanning microscopy :

I = imread("02.tif");

% Remove black margins (crop the image) 
I_copy = I;
I_copy(I<15) = 0;

[r, c] = find(I_copy);
row1 = min(r);
row2 = max(r);
col1 = min(c);
col2 = max(c);
I_cropped = I(row1:row2, col1:col2);
imshow(I_cropped);
[M, N]=size(I_cropped);

% histogramm equalisation: 

I_eq = histeq(I_cropped);
figure
subplot(1,3,2);
imshow(I_cropped);
subplot(1,3,2);
imshow(I_cropped);
subplot(1,3,3);
imshow(I_eq);


% Separate cells in the foreground  and  cells behind in the "background"


level = graythresh(I);% seuillage automatique pour binarisation
img_bw = im2bw(I,level);% binarisation

figure 
subplot(1,2,1);
imshow(I);
%colormap(gray);
title ('image en nuances de gris');

subplot(1,2,2);
imshow(img_bw);
%colormap(gray);
title ('image binarisee en noir et blanc');


img2 = bwareaopen(img_bw,150); % pour supprimer les fausses cellules contenant moins de 100 pixels

D = -bwdist(~img2);
mask = imextendedmin(D,2);
D2 = imimposemin(D,mask);
Ld2 = watershed(D2);   % pour séparer les cellules
img3 = img2;
img3(Ld2 == 0) = 0;

data_img4 = img3(:,:)>0; % image binaire dont l'intensite des  pixels est de 1 (les blancs)
[img_labelled, nombreGrains] = bwlabel(data_img4);  % etalonnage  de l'image


figure

subplot(2,2,1);
imshow(img2);
title ('image sans "faux grains"');

subplot(2,2,2);
imshowpair(img2,mask,'blend')

subplot(2,2,3);
imshow(img3);  
title ('separation des grains')

subplot(2,2,4);
imshow(img_labelled);
title ('image etiquettee');


% proprietes morphologiques des cellules:
stats = regionprops (data_img4, 'Area', 'Perimeter', 'Centroid', 'Eccentricity'); 

M_area = mean([stats.Area]);  % moyenne des aires 
M_eccentricity = mean([stats.Eccentricity]);  % moyenne des circularite ( 0 = circulaire ; 1 = lineaire)
M_perimeter = mean([stats.Perimeter]);  % moyenne des perimetres




