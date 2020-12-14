
%% test
% importe une image bianaire ref et une image binaire segmentation (pour ce
% test on utilise deux images mask de références 
%(Database1\msk\label_02.tif et Database1\msk\label_04.tif")
I1 = imread("C:\Users\titou\Documents\5BIM\Imagerie\Projet\Imagerie_spheroides\Database1\msk\label_02.tif");
I2 = imread("C:\Users\titou\Documents\5BIM\Imagerie\Projet\Imagerie_spheroides\Database1\msk\label_04.tif");
figure
imshow(I1)
figure
imshow(I2)
figure
imshow(I1.*I2)
% compte le nombre d'objet corectement détecté par l'algorithme 
c = count_detected_cells(I1, I2)
% calcule l'indice de Sorenson dice Global pour l'image (idice de
% superposition)
sd = GlobalSorenson_Dice(I1, I2)

%% Functions 
function count = count_detected_cells(Iref, Iseg)
    count = 0;
    I_ref_l = bwlabel(Iref,4);
    I_seg_l = bwlabel(Iseg,4);

    centro_ref = regionprops(I_ref_l,'Centroid');
    centro_seg = regionprops(I_seg_l,'Centroid');

    M = length(centro_ref);

    for i = 1:M
        center_ref = flip(round(centro_ref(i).Centroid));
        v1 = I_seg_l(center_ref(1),center_ref(2));
        if v1 ~= 0
            center_seg = flip(round(centro_seg(v1).Centroid));
            v2 = I_ref_l(center_seg(1),center_seg(2));
            if v2 == i
                count = count + 1;
            end
        end
    end

end

function SD = GlobalSorenson_Dice(Iref, Iseg)
    p_ref = Iref~=0;
    p_seg = Iseg~=0;
    TP = p_ref.*p_seg;
    SD = 2*sum(TP,"all")/(sum(p_ref,"all")+sum(p_seg,"all"));
    

end