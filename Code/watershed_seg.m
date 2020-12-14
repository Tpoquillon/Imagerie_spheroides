clear all;
close all;

%open denoised image : 
I = imread("02.tif");

figure
subplot(1,2,1);
imshow(I);


%seuillage automatique pour binarisation with Otsu threshold 
[T,EM] = graythresh(I);
I_bw = im2bw(I,T);  % binarisation

subplot(1,2,2);
imshow(I_bw);


% using the watershed transform for segmentation of the binary images
% https://blogs.mathworks.com/steve/2013/11/19/watershed-transform-question-from-tech-support/

L = watershed(I_bw);
Lrgb = label2rgb(L);
imshow(Lrgb)

imshow(imfuse(I_bw,Lrgb))


%1st step : clean up the noise a bit. 
% The function bwareaopen can be used to remove very small dots. 

I_bw2 = bwareaopen(I_bw,50); % pour supprimer les faux grains contenant moins de 50 pixels
imshow(I_bw2)

% the distance transform can be useful  here
D = -bwdist(~I_bw2);
imshow(D,[])

% compute the watershed transform of D.
Ld = watershed(D);
imshow(label2rgb(Ld))


% The watershed ridge lines, in white, correspond to Ld == 0. 
% Let's use these ridge lines to segment the binary image by changing the corresponding pixels into background.

% https://fr.mathworks.com/help/images/understanding-morphological-reconstruction.html

mask = imextendedmin(D,2);
imshowpair(I_bw2,mask,'blend')


% Modify the distance transform so it only has minima at the desired locations, 
% and then repeat the watershed steps above.

D2 = imimposemin(D,mask);
Ld2 = watershed(D2);
I_bw3 = I_bw2;
I_bw3(Ld2 == 0) = 0;
imshow(I_bw3)



% proprietes morphologiques des cellules:

I_bw4 = I_bw3(:,:)>0; % image binaire dont l'intensite des  pixels est de 1 (les blancs)
[img_labelled, nombreGrains] = bwlabel(I_bw4);  % etalonnage  de l'image

stats = regionprops (I_bw4, 'Area', 'Perimeter', 'Centroid', 'Eccentricity'); 

M_area = mean([stats.Area]);  % moyenne des aires 
M_eccentricity = mean([stats.Eccentricity]);  % moyenne des circularite ( 0 = circulaire ; 1 = lineaire)
M_perimeter = mean([stats.Perimeter]);  % moyenne des perimetres


