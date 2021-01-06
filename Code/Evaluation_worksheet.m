clear all;
close all;


%% Ilastick segmentation evaluation
 id = ["02","04","07","09","16"];
 T1 = table('Size',[5, 5], 'VariableTypes',["string","double","double","double","double"],'VariableNames',[ "Image","Global_dice", "Av_dice_per_cell", "Cell_detection_precision", "Cell_detection_sensitivity"]);
 for i = 1:5
    I1 = imread("..\Database1\msk\label_"+id(i)+".tif");
    I2 = imread("..\Database1\Ilastik\"+id(i)+"_Object Identities.png");
    c = count_detected_cells(I1, I2);
    [ global_dice, av_dice_per_cell, cell_detection_precision, cell_detection_sensitivity] = Eval(I1, I2);
    T1(i,:) = array2table([id(i), global_dice, av_dice_per_cell, cell_detection_precision, cell_detection_sensitivity]);
 end
T1
writetable(T1,"..\Evaluation\Ilastik_segmentation_evaluation.csv")

%% Watershed segmentation evaluation
 id = ["02","04","07","09","16"];
 T2 = table('Size',[5, 5], 'VariableTypes',["string","double","double","double","double"],'VariableNames',[ "Image","Global_dice", "Av_dice_per_cell", "Cell_detection_precision", "Cell_detection_sensitivity"]);
 for i = 1:5
    I1 = imread("..\Database1\msk\label_"+id(i)+".tif");
    I2 = imread("..\Database1\Watershed_segmentation\"+id(i)+"_segmented.tif");
    c = count_detected_cells(I1, I2);
    [ global_dice, av_dice_per_cell, cell_detection_precision, cell_detection_sensitivity] = Eval(I1, I2);
    T2(i,:) = array2table([id(i), global_dice, av_dice_per_cell, cell_detection_precision, cell_detection_sensitivity]);
 end
T2
writetable(T2,"..\Evaluation\Watershed_segmentation_evaluation.csv")
%% Region-growing segmentation evaluation
 id = ["02","04","07","09","16"];
 T3 = table('Size',[5, 5], 'VariableTypes',["string","double","double","double","double"],'VariableNames',[ "Image","Global_dice", "Av_dice_per_cell", "Cell_detection_precision", "Cell_detection_sensitivity"]);
 for i = 1:5
    I1 = imread("..\Database1\msk\label_"+id(i)+".tif");
    I2 = imread("..\Database1\region_growing\"+id(i)+"_segmented.tif");
    c = count_detected_cells(I1, I2);
    [ global_dice, av_dice_per_cell, cell_detection_precision, cell_detection_sensitivity] = Eval(I1, I2);
    T3(i,:) = array2table([id(i), global_dice, av_dice_per_cell, cell_detection_precision, cell_detection_sensitivity]);
 end
T3
writetable(T3,"..\Evaluation\Region_growing_segmentation_evaluation.csv")
%% K_mean segmentation evaluation
 id = ["02","04","07","09","16"];
 T4 = table('Size',[5, 5], 'VariableTypes',["string","double","double","double","double"],'VariableNames',[ "Image","Global_dice", "Av_dice_per_cell", "Cell_detection_precision", "Cell_detection_sensitivity"]);
 for i = 1:5
    I1 = imread("..\Database1\msk\label_"+id(i)+".tif");
    I2 = imread("..\Database1\Kmean_segmentation\"+id(i)+"_segmented.tif");
    c = count_detected_cells(I1, I2);
    [ global_dice, av_dice_per_cell, cell_detection_precision, cell_detection_sensitivity] = Eval(I1, I2);
    T4(i,:) = array2table([id(i), global_dice, av_dice_per_cell, cell_detection_precision, cell_detection_sensitivity]);
 end
T4
writetable(T4,"..\Evaluation\K_mean_segmentation_evaluation.csv")

%% test eval
% % importe une image bianaire ref et une image binaire segmentation (pour ce
% % test on utilise deux images mask de références 
% %(Database1\msk\label_02.tif et Database1\msk\label_07.tif")
% %{I1 = imread("..\Database1\msk\label_09.tif");
% I2 = imread("..\Database1\Ilastik\09_Object Identities.png");
% figure
% imshow(I1)
% figure
% imshow(I2)
% figure
% imshow(I1.*I2)
% % compte le nombre d'objet corectement détecté par l'algorithme 
% c = count_detected_cells(I1, I2)
% % calcule l'indice de Sorenson dice Global pour l'image (idice de
% % superposition)
% sd = GlobalSorenson_Dice(I1, I2)

%% Test 3dcount++
id = ["02","04","07","09","16"];
slices = cell(5,1);
for i = 1:5
    slices{i}= imread("..\Database1\Ilastik\"+id(i)+"_Object Identities.png");
end
[count, maximum] = Count_cell_slices(slices)

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

function [count, precision, sensitivity  , av_dice_per_cell] = Count_Dice_cells(Iref, Iseg)
    count = 0;
    dice_sum = 0;
    I_ref_l = bwlabel(Iref,4);
    I_seg_l = bwlabel(Iseg,4);

    centro_ref = regionprops(I_ref_l,'Centroid');
    centro_seg = regionprops(I_seg_l,'Centroid');

    M = length(centro_ref);
    N = length(centro_seg); 
    for i = 1:M
        center_ref = flip(round(centro_ref(i).Centroid));
        v1 = I_seg_l(center_ref(1),center_ref(2));
        if v1 ~= 0
            center_seg = flip(round(centro_seg(v1).Centroid));
            v2 = I_ref_l(center_seg(1),center_seg(2));
            if v2 == i
                count = count + 1;
                tmp_dice = GlobalSorenson_Dice(I_ref_l==v2, I_seg_l==v1);
                dice_sum =  dice_sum + tmp_dice;
            end
        end
    end
    precision = count/N;
    sensitivity = count/M;
    av_dice_per_cell = dice_sum/count;

end

function [ global_dice, av_dice_per_cell, cell_detection_precision, cell_detection_sensitivity] = Eval(Iref, Iseg)
    global_dice = GlobalSorenson_Dice(Iref, Iseg);
    [count, cell_detection_precision, cell_detection_sensitivity, av_dice_per_cell] = Count_Dice_cells(Iref, Iseg);
end

function [count, maximum] = Count_cell_slices(slices)
sum_cell = 0;
for i = 1:length(slices)
    sum_cell = sum_cell + max(bwlabel(slices{i}),[],"all");
end
maximum = sum_cell;
for i = 1:length(slices)-1
    sum_cell = sum_cell - 2*count_detected_cells(slices{i}, slices{i+1});
end
count = sum_cell;
end