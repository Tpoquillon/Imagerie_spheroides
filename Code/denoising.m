clear all;
close all;


%Remove the noise caused by laser confocal scanning microscopy 

% Vecteurs contenant les 5 images :
list_img = dir("../Database1/images/*.tif");
image_data= cell(1,length(list_img));
for j=1:length(list_img)
    file_name = strcat('../Database1/images/', list_img(j).name);
    image_file=imread(file_name);
    image_data{j}=image_file;
end

dir_name = "../Database1/Denoised_images"; % folder name where we'll save denoised images
if ~exist(dir_name, 'dir')
    mkdir(dir_name);
end

for i=1:length(list_img)
    
    I = image_data{i};

   
    % Remove black margins (crop the image) 
    I_copy = I;
    I_copy(I<15) = 0;

    [r, c] = find(I_copy);
    row1 = min(r);
    row2 = max(r);
    col1 = min(c);
    col2 = max(c);
    I_cropped = I(row1:row2, col1:col2);
    [M, N]=size(I_cropped);


    fig1 = figure
    subplot(1,2,1);
    imshow(I);
    subplot(1,2,2);
    imshow(I_cropped);

    % Opening - Closing reconstruction : 
    gmag = imgradient(I_cropped);
    fig2 = figure
    subplot(3,3,1);
    imshow(gmag,[])
    title('Gradient Magnitude')

    se = strel("disk", 5);
    Io = imopen(I_cropped,se);
    subplot(3,3,2);
    imshow(Io)
    title('Opening')

    Ie = imerode(I_cropped,se);
    Iobr = imreconstruct(Ie,I_cropped);
    subplot(3,3,3);
    imshow(Iobr)
    title('Opening-by-Reconstruction')

    Ioc = imclose(Io,se);
    subplot(3,3,4);
    imshow(Ioc)
    title('Opening-Closing')

    Iobrd = imdilate(Iobr,se);
    Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
    Iobrcbr = imcomplement(Iobrcbr);
    subplot(3,3,5);
    imshow(Iobrcbr);
    title('Opening-Closing by Reconstruction')


    % Contrast Enhancement
    I_final  =  adapthisteq(Iobrcbr);
    subplot(3,3,6);
    imshow(I_final);

    % Otsu's method for automatic image thresholding (binarization)
    [T,EM] = graythresh(I_final);
    I_bw = im2bw(I_final,T);  % binarisation

    fig3 = figure;
    subplot(1,3,1);
    imshow(I_cropped);
    title("Original image");
    
    subplot(1,3,2);
    imshow(I_final);
    title("Image after Opening-Closing by Reconstruction");
    
    subplot(1,3,3);
    imshow(I_bw);
    title("Final denoised and binarized image");
    
    img_name = strcat(list_img(i).name(1:2), "_denoised.tif");
    img_path = strcat("../Database1/Denoised_images/", img_name);
    imwrite(I_bw,img_path);


end
