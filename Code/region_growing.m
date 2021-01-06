clear all;
close all;


% Vecteurs contenant les 5 images débruitées et binarisées :
list_img = dir("../Database1/images/*.tif");
image_data= cell(1,length(list_img));
for j=1:length(list_img)
    file_name = strcat('../Database1/images/', list_img(j).name);
    image_file=imread(file_name);
    image_data{j}=image_file;
end

dir_name = "../Database1/region_growing"; % folder name where we'll save denoised images
if ~exist(dir_name, 'dir')
    mkdir(dir_name);
end

for i=1:length(list_img)
    
I = image_data{i}; 
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

img_name = strcat(list_img(i).name(1:2), "_segmented.tif");
img_path = strcat("../Database1/region_growing/", img_name);
imwrite(bw,img_path);
end
