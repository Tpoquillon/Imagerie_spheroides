clear all;
close all;

%Débruite l'image du sphéroide 

% Récupération des images du sphéroide :
tiff_info = imfinfo("..\Database2\raw.tif");
n_slices = size(tiff_info, 1);
image_data= cell(1,n_slices);

for i = 1 : n_slices
    image_data{i} = imread("..\Database2\raw.tif",i);
end
outputFileName = '..\Database2\Denoised_.tif';



for i=1:n_slices
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
    

    
    % Opening - Closing reconstruction : 
    gmag = imgradient(I_cropped);


    se = strel("disk", 5);
    Io = imopen(I_cropped,se);


    Ie = imerode(I_cropped,se);
    Iobr = imreconstruct(Ie,I_cropped);



    Ioc = imclose(Io,se);


    Iobrd = imdilate(Iobr,se);
    Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
    Iobrcbr = imcomplement(Iobrcbr);


    % Contrast Enhancement
    I_final  =  adapthisteq(Iobrcbr);

    I(row1:row2, col1:col2) = I_final;

    imwrite(I, outputFileName, 'WriteMode', 'append',  'Compression','none');


end
